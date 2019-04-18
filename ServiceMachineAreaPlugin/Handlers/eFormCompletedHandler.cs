using System;
using System.Linq;
using System.Threading.Tasks;
using eFormData;
using eFormShared;
using Microsoft.EntityFrameworkCore;
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
            Case_Dto caseDto = _sdkCore.CaseLookup(message.caseId, message.checkId);
            //var microtingUId = caseDto.MicrotingUId;
            //var microtingCheckUId = caseDto.CheckUId;
            ReplyElement replyElement = _sdkCore.CaseRead(message.caseId, message.checkId);
            CheckListValue dataElement = (CheckListValue)replyElement.ElementList[0];
            Console.WriteLine("Trying to find the field with the approval value");
            int registeredTime = 0;
            
            MachineAreaSite machineAreaSite =
                _dbContext.MachineAreaSites.SingleOrDefault(x =>
                    x.MicrotingSdkCaseId == int.Parse(message.caseId));
            
            MachineAreaTimeRegistration machineAreaTimeRegistration = new MachineAreaTimeRegistration();
            if (machineAreaSite != null)
            {
                machineAreaTimeRegistration.AreaId = machineAreaSite.MachineArea.AreaId;
                machineAreaTimeRegistration.MachineId = machineAreaSite.MachineArea.MachineId;
                machineAreaTimeRegistration.DoneAt = replyElement.DoneAt;
                machineAreaTimeRegistration.SDKCaseId = (int)caseDto.CaseId;
                machineAreaTimeRegistration.SDKSiteId = machineAreaSite.MicrotingSdkSiteId;
            }

            foreach (var field in dataElement.DataItemList)
            {
                Field f = (Field) field;
                if (f.Label.Contains("Start/Stop tid"))
                {
                    Console.WriteLine($"The field is {f.Label}");
                    FieldValue fv = f.FieldValues[0];
                    String fieldValue = fv.Value;
                    registeredTime = int.Parse(fieldValue.Split("|")[3]);
                    Console.WriteLine($"We are setting the registered time to {registeredTime.ToString()}");
                    
                    machineAreaTimeRegistration.SDKFieldValueId = fv.Id;
                    machineAreaTimeRegistration.TimeInSeconds = (registeredTime / 1000);
                    machineAreaTimeRegistration.TimeInMinutes = ((registeredTime / 1000) / 60);
                    machineAreaTimeRegistration.TimeInHours = ((registeredTime / 1000) / 3600);
                }
            }
            #endregion

            await machineAreaTimeRegistration.Save(_dbContext);
        }
    }
}