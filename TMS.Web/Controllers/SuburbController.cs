using System.Linq;
using System.Web.Mvc;
using System.Web.UI.WebControls;
using TMS.Logic.Service;
using TMS.Web.JsonDtoConverters;
using TerritoryManagementSystem.Models;
using TMS.Entity.DataModel;
using System.Collections.Generic;

namespace TerritoryManagementSystem.Controllers
{
    [Authorize]
    public class SuburbController : BaseController
    {
        private MapService mapService;
        private PublisherService publisherService;

        public SuburbController(PublisherService publisherService, MapService mapService)
            : base(publisherService, mapService)
        {
            this.publisherService = publisherService;
            this.mapService = mapService;
        }

        public ActionResult Index()
        {
            ViewBag.Title = "Suburb";

            return View("Index");
        }
    }
}
