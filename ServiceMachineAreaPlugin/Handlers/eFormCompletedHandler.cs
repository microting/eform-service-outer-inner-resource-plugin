using System.Threading.Tasks;
using Microting.eFormMachineAreaBase.Infrastructure.Data;
using Rebus.Handlers;
using ServiceMachineAreaPlugin.Messages;

namespace ServiceMachineAreaPlugin.Handlers
{
    public class eFormCompletedHandler : IHandleMessages<eFormCompleted>
    {
        private readonly eFormCore.Core _sdkCore;
        private readonly MachineAreaPnDbContext _dbContext;

        public eFormCompletedHandler(eFormCore.Core sdkCore, MachineAreaPnDbContext dbContext)
        {
            _dbContext = dbContext;
            _sdkCore = sdkCore;
        }

        public Task Handle(eFormCompleted message)
        {
            throw new System.NotImplementedException();
        }
    }
}