using Microsoft.Extensions.DependencyInjection;
using Sitecore.DependencyInjection;
using Helix.Skeleton.Foundation.DI.Extensions;

namespace Helix.Skeleton.Foundation.DI.Register
{
    public class RegisterControllers : IServicesConfigurator
    {
        public void Configure(IServiceCollection serviceCollection)
        {
            serviceCollection.AddMvcControllers(
                "Helix.Skeleton.Feature.*");
        }
    }
}
