using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Net;
using System.Net.Http;
using System.Web.UI.WebControls;
using TMS.Logic.Service;
using TMS.Web.JsonDtoConverters;

namespace TerritoryManagementSystem.Controllers
{
    [Authorize]
    public class PublisherController : BaseController
    {
        private MapService mapService;
        private PublisherService publisherService;

        public PublisherController(PublisherService publisherService, MapService mapService)
            : base(publisherService, mapService)
        {
            this.publisherService = publisherService;
            this.mapService = mapService;
        }

        public ActionResult Index()
        {
            ViewBag.CreateAction = "CreatePublisher";
            ViewBag.DataSourceUrl = "GetPublishers";
            ViewBag.EditUrl = "EditPublisher";
            ViewBag.Title = "Publishers";

            return View("PublisherIndex");
        }

        [HttpGet]
        public JsonResult GetPublishers()
        {
            var publishers = publisherService.GetPublishers(false).Where(w => w.Id != 1)
                            .OrderByDescending(o => o.IsActive)
                            .ThenByDescending(e => e.IsTerritoryOverseer)
                            .ThenByDescending(e => e.IsElder)
                            .ThenByDescending(e => e.IsAssistantBrother)                            
                            .ToList(); // dont show publisher id 1 = admin

            var publishersJson = PublisherConverter.PublishersToJsonSummary(publishers);

            return Json(new { publishers = publishersJson }, JsonRequestBehavior.AllowGet);
        }
    }
}
