using System.Web.Mvc;
using [projectName].Feature.[subProjectName].Models;
using [projectName].Foundation.Data.Repositories;

namespace [projectName].Feature.[subProjectName].Controllers
{
    public class [moduleName]Controller : Controller
    {
        private readonly IItemRepository _itemRepository;

        public [moduleName]Controller(IItemRepository itemRepository)
        {
            _itemRepository = itemRepository;
        }

        public ActionResult [moduleName]()
        {
            return View("~/Views/[subProjectName]/[moduleName].cshtml", _itemRepository.GetDatasourceItem<I[moduleName]>());
        }
    }
}