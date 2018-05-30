using Microsoft.Extensions.DependencyInjection;
using Sitecore.DependencyInjection;
using [projectName].Foundation.DI.Extensions;

namespace [projectName].Foundation.DI.Register
{
    public class RegisterControllers : IServicesConfigurator
    {
        public void Configure(IServiceCollection serviceCollection)
        {
            serviceCollection.AddMvcControllers(
                "[projectName].Feature.*");
        }
    }
}
