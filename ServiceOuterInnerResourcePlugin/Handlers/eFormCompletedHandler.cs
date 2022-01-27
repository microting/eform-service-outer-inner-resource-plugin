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
using Microting.eForm.Infrastructure;
using Microting.eForm.Infrastructure.Data.Entities;
using Microting.eForm.Infrastructure.Models;
using Microting.eFormOuterInnerResourceBase.Infrastructure.Data;
using Microting.eFormOuterInnerResourceBase.Infrastructure.Data.Entities;
using Rebus.Handlers;
using ServiceOuterInnerResourcePlugin.Infrastucture.Helpers;
using ServiceOuterInnerResourcePlugin.Messages;
using CheckListValue = Microting.eForm.Infrastructure.Models.CheckListValue;
using Field = Microting.eForm.Infrastructure.Models.Field;
using FieldValue = Microting.eForm.Infrastructure.Models.FieldValue;

namespace ServiceOuterInnerResourcePlugin.Handlers
{
    public class eFormCompletedHandler : IHandleMessages<eFormCompleted>
    {
        private readonly eFormCore.Core _sdkCore;
        private readonly OuterInnerResourcePnDbContext _dbContext;

        public eFormCompletedHandler(eFormCore.Core sdkCore, DbContextHelper dbContextHelper)
        {
            _dbContext = dbContextHelper.GetDbContext();
            _sdkCore = sdkCore;
        }

        public async Task Handle(eFormCompleted message)
        {
            WriteLogEntry($"eFormCompletedHandler.Handle: we got called for message.caseId {message.caseId} and message.checkId {message.checkId}");
            await using MicrotingDbContext microtingDbContext = _sdkCore.DbContextHelper.GetDbContext();
            Language language = await microtingDbContext.Languages.SingleAsync(x => x.LanguageCode == "da");
            CaseDto caseDto = await _sdkCore.CaseLookup(message.caseId, message.checkId).ConfigureAwait(false);
            ReplyElement replyElement = await _sdkCore.CaseRead(message.caseId, message.checkId, language).ConfigureAwait(false);

            OuterInnerResourceSite machineAreaSite =
                _dbContext.OuterInnerResourceSites.SingleOrDefault(x =>
                    x.MicrotingSdkCaseId == message.caseId);

            var machineAreaTimeRegistrations =
                await _dbContext.ResourceTimeRegistrations.Where(x =>
                // x.DoneAt == replyElement.DoneAt &&
                x.SDKCaseId == (int) caseDto.CaseId &&
                x.SDKSiteId == machineAreaSite.MicrotingSdkSiteId).ToListAsync().ConfigureAwait(false);

            if (machineAreaTimeRegistrations.Count == 0)
            {
                ResourceTimeRegistration machineAreaTimeRegistration = new ResourceTimeRegistration();
                if (machineAreaSite != null)
                {
                    var outerInnerResource =
                        await _dbContext.OuterInnerResources.SingleOrDefaultAsync(x =>
                            x.Id == machineAreaSite.OuterInnerResourceId);
                    machineAreaTimeRegistration.OuterResourceId = outerInnerResource.OuterResourceId;
                    machineAreaTimeRegistration.InnerResourceId = outerInnerResource.InnerResourceId;
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
                        try
                        {

                            Console.WriteLine($"The field is {f.Label}");
                            FieldValue fv = f.FieldValues[0];
                            String fieldValue = fv.Value;
                            if (!string.IsNullOrEmpty(fieldValue))
                            {
                                Console.WriteLine($"Current field_value is {fieldValue}");
                                int registeredTime = int.Parse(fieldValue.Split("|")[3]);
                                Console.WriteLine($"We are setting the registered time to {registeredTime.ToString()}");

                                machineAreaTimeRegistration.SDKFieldValueId = fv.Id;
                                machineAreaTimeRegistration.TimeInSeconds = (registeredTime / 1000);
                                machineAreaTimeRegistration.TimeInMinutes = ((registeredTime / 1000) / 60);
                                machineAreaTimeRegistration.TimeInHours = ((registeredTime / 1000) / 3600);
                            }
                        }
                        catch (Exception ex)
                        {
                            Console.WriteLine(ex.Message);
                        }
                    }
                }

                await machineAreaTimeRegistration.Create(_dbContext).ConfigureAwait(false);
            }
            else
            {
                if (machineAreaTimeRegistrations.Count > 1)
                {
                    int i = 0;
                    foreach (ResourceTimeRegistration machineAreaTimeRegistration in machineAreaTimeRegistrations)
                    {
                        if (i > 0)
                        {
                            await machineAreaTimeRegistration.Delete(_dbContext);
                        }

                        i++;
                        Console.WriteLine("More than one time registration found");
                    }
                }
                else
                {
                    Console.WriteLine("One time registration found");
                }
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