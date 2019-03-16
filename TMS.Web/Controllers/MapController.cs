using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Net;
using System.Net.Http;
using TMS.Entity.DataModel;
using TerritoryManagementSystem.Models;
using TMS.Common;
using TMS.Logic.Service;
using Newtonsoft.Json;
using tms.api.Model;

namespace TerritoryManagementSystem.Controllers
{
    public class MapController : BaseController
    {
        private MapService mapService;       
        private PublisherService publisherService;

        public MapController(PublisherService publisherService, MapService mapService)
            : base(publisherService, mapService)
        {
            this.publisherService = publisherService;
            this.mapService = mapService;
        }

        [HttpGet]
        public ActionResult MapsAllowedToBeReleased()
        {
            var model = new MapsAllowedToBeReleasedModel
            {
                AvailableMaps = mapService.GetCallGroups(CurrentCycle).ToList()
            };

            if (model.AvailableMaps.Any())
            {
                model.AvailableMaps = model.AvailableMaps.OrderBy(o => o.AllowAssistantToRelease).ThenBy(o => o.LastCallDate).ThenBy(o => o.CallGroupName).ToList();
            }

            return View(model);
        }

        [HttpPost]
        public ActionResult MapsAllowedToBeReleased(MapsAllowedToBeReleasedModel model)
        {
            mapService.SetMapsAllowToBeReleased(model.AvailableMaps);

            return RedirectToAction("Index", "CallActivity");
        }

        [HttpGet]
        public ActionResult PlotAddressInMap()
        {
            return View("PlotAddressInMap");
        }

        [HttpGet]
        public JsonResult GetAddressesToPlot()
        {
            var addresses = mapService.GetCallAddresses(-1, 5);

            var result = new JsonResult { JsonRequestBehavior = JsonRequestBehavior.AllowGet, Data = mapService.HibernateCallAddress(addresses), MaxJsonLength = int.MaxValue };

            return result;
        }

        [HttpGet]
        public ActionResult GeoCodeAddresses()
        {
            var callAddresses = mapService.GetCallAddresses(-1, -1, false).Where(w => w.Latitude == null).ToList();
            mapService.UpdateAddressGeoCode(callAddresses);

            return RedirectToAction("Index", "CallActivity");
        }

        [HttpGet]
        public ActionResult AddressBestRoute()
        {
            var model = new AddressBestRouteModel {
                OriginAddress = "sssss",
                DestinationAddress = string.Empty,
                RouteAddress = new MapRouteAddress()
            };
            return View(model);
        }

        [HttpPost]
        public ActionResult AddressBestRoute(AddressBestRouteModel model)
        {
            var origin = string.Format("\"Origin\" : {0}", model.OriginAddress);
            var destination = string.Format("\"Destinations\" : {0}", model.DestinationAddress);
            var jsonString = string.Format("{{ {0}, {1} }}", origin, destination);
            var routeAddress = JsonConvert.DeserializeObject<MapRouteAddress>(jsonString);

            MapRouteAddress bestRoute = mapService.GetBestRoute(routeAddress);

            model.Result = JsonConvert.SerializeObject(bestRoute);

            ModelState.Clear();
            return View(model);
        }
    }
}
