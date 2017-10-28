using System.Web.Mvc;
using Helix.Skeleton.Feature.Demo.Services;

namespace Helix.Skeleton.Feature.Demo.Controllers
{
    public class DemoController : Controller
    {
        private readonly IDemoService _demoService;

        public DemoController(IDemoService demoService)
        {
            _demoService = demoService;
        }

        public ActionResult Demo()
        {
            return View("~/Views/Demo/Demo.cshtml", _demoService.GetModel());
        }
    }
}
