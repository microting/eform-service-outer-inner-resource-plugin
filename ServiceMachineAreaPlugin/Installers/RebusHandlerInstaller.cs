using Castle.MicroKernel.Registration;
using Castle.MicroKernel.SubSystems.Configuration;
using Castle.Windsor;
using Rebus.Handlers;
using ServiceMachineAreaPlugin.Handlers;
using ServiceMachineAreaPlugin.Messages;

namespace ServiceMachineAreaPlugin.Installers
{
    public class RebusHandlerInstaller : IWindsorInstaller
    {
        public void Install(IWindsorContainer container, IConfigurationStore store)
        {
            container.Register(Component.For<IHandleMessages<eFormCompleted>>().ImplementedBy<eFormCompletedHandler>().LifestyleTransient());
        }
    }
}