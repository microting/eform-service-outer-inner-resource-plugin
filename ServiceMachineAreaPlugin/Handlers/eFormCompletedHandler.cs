/*
The MIT License (MIT)
Copyright (c) 2007 - 2019 Microting A/S
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

using System;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using Microting.eForm.Dto;
using Microting.eForm.Infrastructure.Models;
using Microting.eFormMachineAreaBase.Infrastructure.Data;
using Microting.eFormMachineAreaBase.Infrastructure.Data.Entities;
using Rebus.Handlers;

namespace ServiceMachineAreaPlugin.Handlers
{
    public class eFormCompletedHandler : IHandleMessages<ServiceMachineAreaPlugin.Messages.eFormCompleted>
    {
        private readonly eFormCore.Core _sdkCore;
        private readonly MachineAreaPnDbContext _dbContext;

        public eFormCompletedHandler(eFormCore.Core sdkCore, MachineAreaPnDbContext dbContext)
        {
            _dbContext = dbContext;
            _sdkCore = sdkCore;
        }

        public async Task Handle(ServiceMachineAreaPlugin.Messages.eFormCompleted message)
        {
            #region get case information

            WriteLogEntry($"eFormCompletedHandler.Handle: we got called for message.caseId {message.caseId} and message.checkId {message.checkId}");
            Case_Dto caseDto = _sdkCore.CaseLookup(message.caseId, message.checkId);
            ReplyElement replyElement = _sdkCore.CaseRead(message.caseId, message.checkId);

            MachineAreaSite machineAreaSite =
                _dbContext.MachineAreaSites.SingleOrDefault(x =>
                    x.MicrotingSdkCaseId == int.Parse(message.caseId));
            
            MachineAreaTimeRegistration machineAreaTimeRegistration = 
                await _dbContext.MachineAreaTimeRegistrations.SingleOrDefaultAsync(x =>
                x.DoneAt == replyElement.DoneAt && 
                x.SDKCaseId == (int) caseDto.CaseId &&
                x.SDKSiteId == machineAreaSite.MicrotingSdkSiteId);

            if (machineAreaTimeRegistration == null)
            {
                machineAreaTimeRegistration = new MachineAreaTimeRegistration();
                if (machineAreaSite != null)
                {
                    machineAreaTimeRegistration.AreaId = machineAreaSite.MachineArea.AreaId;
                    machineAreaTimeRegistration.MachineId = machineAreaSite.MachineArea.MachineId;
                    machineAreaTimeRegistration.DoneAt = replyElement.DoneAt;
                    if (caseDto.CaseId != null) machineAreaTimeRegistration.SDKCaseId = (int) caseDto.CaseId;
                    machineAreaTimeRegistration.SDKSiteId = machineAreaSite.MicrotingSdkSiteId;
                }

                CheckListValue dataElement = (CheckListValue)replyElement.ElementList[0];
                foreach (var field in dataElement.DataItemList)
                {
                    Field f = (Field) field;
                    if (f.Label.ToLower().Contains("start/stop tid"))
                    {
                        Console.WriteLine($"The field is {f.Label}");
                        FieldValue fv = f.FieldValues[0];
                        String fieldValue = fv.Value;
                        Console.WriteLine($"Current field_value is {fieldValue}");
                        int registeredTime = int.Parse(fieldValue.Split("|")[3]);
                        Console.WriteLine($"We are setting the registered time to {registeredTime.ToString()}");
                    
                        machineAreaTimeRegistration.SDKFieldValueId = fv.Id;
                        machineAreaTimeRegistration.TimeInSeconds = (registeredTime / 1000);
                        machineAreaTimeRegistration.TimeInMinutes = ((registeredTime / 1000) / 60);
                        machineAreaTimeRegistration.TimeInHours = ((registeredTime / 1000) / 3600);
                    }
                }
                #endregion

                await machineAreaTimeRegistration.Create(_dbContext);
            }
        }

        private void WriteLogEntry(string message)
        {
            var oldColor = Console.ForegroundColor;
            Console.ForegroundColor = ConsoleColor.Gray;
            Console.WriteLine("[DBG] " + message);
            Console.ForegroundColor = oldColor;
        }
    }
}