using Glass.Mapper.Sc;
using Sitecore.Globalization;
using Sitecore.Mvc.Presentation;
using System;
using System.Collections.Generic;
using Helix.Skeleton.Foundation.ORM.Models;

namespace Helix.Skeleton.Foundation.Data.Repositories
{
    public class ItemRepository : IItemRepository
    {
        private readonly ISitecoreContext _sitecoreContext;

        public ItemRepository(ISitecoreContext sitecoreContext)
        {
            _sitecoreContext = sitecoreContext;
        }

        public T GetDatasourceItem<T>() where T : class, IGlassBase
        {
            return _sitecoreContext.GetItem<T>(RenderingContext.Current.Rendering.DataSource);
        }

        public T GetContextItem<T>() where T: class, IGlassBase
        {
            return _sitecoreContext.GetCurrentItem<T>();
        }

        public IEnumerable<T> GetItems<T>(string query) where T : class
        {
            return _sitecoreContext.Query<T>(query);
        }

        public IEnumerable<T> GetItemsRelative<T>(string query) where T : class
        {
            return _sitecoreContext.Query<T>(Sitecore.Context.Item.Paths.Path + query);
        }

        public T GetItem<T>(Guid id, Language language = null) where T : class, IGlassBase
        {
            return language == null ? _sitecoreContext.GetItem<T>(id) : _sitecoreContext.GetItem<T>(id, language);
        }

        public void SaveItem<T>(T item) where T : class, IGlassBase
        {
            _sitecoreContext.Save(item);
        }
    }
}
