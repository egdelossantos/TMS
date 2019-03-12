using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using TerritoryManagementSystem.Models;
using TMS.Entity.DataModel;
using TMS.Logic.Service;

namespace TerritoryManagementSystem.Controllers
{
    public class HomeController : BaseController
    {       
        public HomeController(PublisherService publisherService, MapService mapService)
            : base(publisherService, mapService)
        {            
        }

        [Authorize]
        public ActionResult Index()
        {
            return RedirectToAction("Index", "CallActivity");
        }

        public ActionResult Error()
        {
            return View();
        }
    }
}
