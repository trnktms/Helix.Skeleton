using Glass.Mapper.Sc;
using Microsoft.Extensions.DependencyInjection;
using Sitecore.DependencyInjection;
using [projectName].Foundation.Data.Repositories;

namespace [projectName].Foundation.Data.DI
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