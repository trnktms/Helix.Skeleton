using Microsoft.Extensions.DependencyInjection;
using Sitecore.DependencyInjection;
using Helix.Skeleton.Feature.Demo.Services;

namespace Helix.Skeleton.Feature.Demo.DI
{
    public class RegisterContainer : IServicesConfigurator
    {
        public void Configure(IServiceCollection serviceCollection)
        {
            serviceCollection.AddTransient<IDemoService, DemoService>();
        
        }
    }
}
