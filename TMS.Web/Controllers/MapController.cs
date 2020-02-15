using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using TerritoryManagementSystem.Models;
using TMS.Logic.Service;
using Newtonsoft.Json;
using tms.api.Model;
using TMS.Common;
using TMS.Entity.DataModel;

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
                OriginAddress = JsonConvert.SerializeObject(mapService.KingdomHallLocation),
                DestinationAddress = string.Empty,
                RouteAddress = new MapRouteAddress { Origin = mapService.KingdomHallLocation, Destinations = new List<Address>() }
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

            model.RouteAddress = mapService.GetBestRoute(routeAddress);
            
            model.Result = JsonConvert.SerializeObject(model.RouteAddress);

            ModelState.Clear();

            return View(model);
        }

        [HttpGet]
        public ActionResult AddAddress()
        {
            var model = new AddressModel
            {
                CallGroupId = 0,
                Maps = GetActiveCallGroups()
            };

            return View(model);
        }

        [HttpPost]
        public ActionResult AddAddress(AddressModel model)
        {
            var isSaved = false;

            if (ModelState.IsValid)
            {
                var callAddress = MapModelToCallAddress(model);
                var validateResult = mapService.ValidateCallAddress(callAddress);
                if (!string.IsNullOrWhiteSpace(validateResult))
                {
                    ModelState.AddModelError("ErrorMessage", validateResult);
                }
                else
                {
                    callAddress.Suburb = null;
                    mapService.SaveCallAddress(callAddress);
                    isSaved = true;
                }
               
            }

            if (isSaved)
            {
                return RedirectToAction("Index", "CallActivity");
            }
            else
            {
                model.Maps = GetActiveCallGroups();
                return View("AddAddress", model);
            }
        }

        private List<CallGroup> GetActiveCallGroups()
        {
            return mapService.GetCallGroups(CurrentCycle, false, false).OrderBy(o => o.LastCallDate).ThenBy(o => o.CallGroupName).ThenBy(o => o.GroupCode, new SemiNumericComparer()).ToList();
        }

        private CallAddress MapModelToCallAddress(AddressModel model)
        {
            var suburb = mapService.GetSuburbByName(model.Suburb);

            return new CallAddress
            {
                Unit = model.Unit ?? "",
                Number = model.Number ?? "",
                Street = model.Street ?? "",
                Suburb = suburb,
                SuburbId = suburb != null ? suburb.Id : 0,
                SuggestedCallGroupId = model.CallGroupId,
                IsValid = true,
                Latitude = model.Latitude,
                Longtitude = model.Longtitude
            };
        }
    }
}
