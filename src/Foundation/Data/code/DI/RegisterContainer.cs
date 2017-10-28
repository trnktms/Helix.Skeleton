using Glass.Mapper.Sc;
using Microsoft.Extensions.DependencyInjection;
using Sitecore.DependencyInjection;
using Helix.Skeleton.Foundation.Data.Repositories;

namespace Helix.Skeleton.Foundation.Data.DI
{
    public class RegisterContainer : IServicesConfigurator
    {
        public void Configure(IServiceCollection serviceCollection)
        {
            serviceCollection.AddTransient<IItemRepository, ItemRepository>();
            serviceCollection.AddTransient<ISitecoreContext>(provider => new SitecoreContext());
        }
    }
}
