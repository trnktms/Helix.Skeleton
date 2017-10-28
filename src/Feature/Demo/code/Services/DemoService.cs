using Helix.Skeleton.Feature.Demo.Models;
using Helix.Skeleton.Foundation.Data.Repositories;

namespace Helix.Skeleton.Feature.Demo.Services
{
    /// <summary>
    /// This service only created for demo purposes.
    /// Service is only needed when you need a more complex business logic.
    /// </summary>
    public class DemoService : IDemoService
    {
        private readonly IItemRepository _itemRepository;

        public DemoService(IItemRepository itemRepository)
        {
            _itemRepository = itemRepository;
        }

        public IDemo GetModel()
        {
            return _itemRepository.GetDatasourceItem<IDemo>();
        }
    }
}
