using Sitecore.Globalization;
using System;
using System.Collections.Generic;
using Helix.Skeleton.Foundation.ORM.Models;

namespace Helix.Skeleton.Foundation.Data.Repositories
{
    public interface IItemRepository
    {
        T GetDatasourceItem<T>() where T : class, IGlassBase;

        T GetContextItem<T>() where T : class, IGlassBase;

        T GetItem<T>(Guid id, Language language = null) where T : class, IGlassBase;

        IEnumerable<T> GetItems<T>(string query) where T : class;

        IEnumerable<T> GetItemsRelative<T>(string query) where T : class;

        void SaveItem<T>(T item) where T : class, IGlassBase;       

    }
}
