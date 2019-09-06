using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Microting.eForm.Dto;
using Microting.eFormMachineAreaBase.Infrastructure.Data;
using Rebus.Bus;
using Rebus.Handlers;
using ServiceMachineAreaPlugin.Messages;

namespace ServiceMachineAreaPlugin.Handlers
{
    public class CheckAllCasesHandler : IHandleMessages<CheckAllCases>
    {
        private readonly eFormCore.Core _sdkCore;
        private readonly MachineAreaPnDbContext _dbContext;
        private readonly IBus _bus;

        public CheckAllCasesHandler(eFormCore.Core sdkCore, MachineAreaPnDbContext dbContext, IBus bus)
        {
            _dbContext = dbContext;
            _sdkCore = sdkCore;
            _bus = bus;
        }
        
        public async Task Handle(CheckAllCases message)
        {
            List<Case> list = _sdkCore.CaseReadAll(message.eFormId, null, null);

            foreach (Case @case in list)
            {
                WriteLogEntry($"CheckAllCasesHandler.Handle: Dispatching eFormCompleted for @case.MicrotingUId {@case.MicrotingUId} @case.CheckUIid {@case.CheckUIid}");
                await _bus.SendLocal(new eFormCompleted(@case.MicrotingUId, @case.CheckUIid));
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