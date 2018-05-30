using Microsoft.Extensions.DependencyInjection;
using Sitecore.DependencyInjection;
using [projectName].Feature.Demo.Services;

namespace [projectName].Feature.Demo.DI
{
    public class RegisterContainer : IServicesConfigurator
    {
        public void Configure(IServiceCollection serviceCollection)
        {
            serviceCollection.AddTransient<IDemoService, DemoService>();
        
        }
    }
}
