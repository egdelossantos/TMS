using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Net;
using System.Net.Http;
using TMS.Entity.DataModel;
using TerritoryManagementSystem.Models;
using TMS.Logic.Service;
using TMS.Common;

namespace TerritoryManagementSystem.Controllers
{
    public class CallActivityController : BaseController
    {        
        private CallActivityService callActivityService;
        private PublisherService publisherService;
        private MapService mapService;
        
        public CallActivityController(PublisherService publisherService, CallActivityService callActivityService, MapService mapService)
            : base(publisherService, mapService)
        {
            this.callActivityService = callActivityService;
            this.publisherService = publisherService;
            this.mapService = mapService;
        }

        public ActionResult Index()
        {
            return View();
        }

        [HttpGet]
        public ActionResult Details(int id)
        {
            var model = new CallActivityModel
            {
                CallActivity = callActivityService.GetCallActivityById(id) ?? new CallActivity { DateReleased = TimeConverter.ConvertToLocalTime(DateTime.Now) },
                CallActivityAddresses = new List<CallActivityAddress>()                
            };

            LoadLists(model);
            
            return View(model);
        }

        [HttpPost]
        public ActionResult Details(CallActivityModel model)
        {
            var isSaved = false;
            ModelState.Remove("CallActivity.Id");

            if (ModelState.IsValid)
            {
                HibernateCallActivityModel(model);

                var validateResult = callActivityService.ValidateCallActivity(model.IsEditMode, model.CallActivity, model.CallActivityAddresses);
                if (!string.IsNullOrWhiteSpace(validateResult))
                {
                    ModelState.AddModelError("ErrorMessage", validateResult);
                }
                else
                {
                    model.CallActivity = callActivityService.SaveCallActivity(model.CallActivity, model.CallActivityAddresses, ViewBag.LoggedInPublisher, CurrentCycle);
                    isSaved = true;
                }                
            }            

            if (isSaved)
            {
                return RedirectToAction("Index");
            }
            else
            {
                LoadLists(model);
                return View("Details", model);
            }
        }

        public JsonResult IsMapAvailable()
        {
            var isMapAvailable = mapService.GetCallGroups(CurrentCycle, true, true).Count > 0;
            return Json(new { isMapAvailable = isMapAvailable }, JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetCallActivities()
        {
            var callActivities = callActivityService.GetUnreturnedMaps(ViewBag.LoggedInPublisher);
            HibernateCallActivity(callActivities);
            return Json(callActivities, JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetCallActivityAddresses(int callActivityId)
        {
            var callActivityAddresses = callActivityService.GetCallActivityAddresses(callActivityId);
            var callAddress = HibernateCallAddress(callActivityAddresses.ToList());
            var result = Json(new { callAddress = callAddress }, JsonRequestBehavior.AllowGet);
            return result;
        }

        [HttpPost]
        public JsonResult DeleteCallActivity(CallActivity callActivity)
        {
            var result = callActivityService.DeleteCallActivity(callActivity.Id);
            return Json(result, JsonRequestBehavior.AllowGet);
        }

        public ActionResult GetAddressesByGroup(int callActivityId, int callGroupId, int callTypeId)
        {
            var model = new CallActivityModel
            {
                CallActivity = new CallActivity { Id = callActivityId, CallGroupId = callGroupId, CallTypeId = callTypeId },
                CallActivityAddresses = new List<CallActivityAddress>()
            };

            LoadLists(model, true);

            return PartialView("_CallActivityAddress", model);
        }

        public ActionResult EmailCallAddress(CallActivity callActivity)
        {
            var localCallActivity = callActivityService.GetCallActivityById(callActivity.Id);
            localCallActivity.ContentHtml = callActivity.ContentHtml;

            var result = callActivityService.EmailCallAddress(localCallActivity);

            return Json(result, JsonRequestBehavior.AllowGet);
        }

        private void LoadLists(CallActivityModel model, bool isReloadAddress = false)
        {
            HibernateCallActivityModel(model);

            model.AvailableMaps = mapService.GetCallGroups(CurrentCycle, true, true).OrderBy(o => o.LastCallDate).ThenBy(o => o.CallGroupName).ThenBy(o => o.GroupCode, new SemiNumericComparer()).ToList();

            if (model.IsEditMode)
            {
                model.AvailableMaps.Add(mapService.GetCallGroup(model.CallActivity.CallGroupId));

                model.CallActivity.TempDateReleased = string.Empty;
                if (!model.CallActivityAddresses.Any(c => c.CallActivityStatusId == null) && model.CallActivity.DateReturned == null && !model.CallActivity.CallActivityIsVirtual)
                {
                    model.CallActivity.TempDateReleased = string.Format(" ({0:yyyy-MM-dd})", model.CallActivityAddresses.Max(m => m.DateFinished));
                }

                model.CallActivityAddresses = model.CallActivityAddresses.OrderBy(o => o.CallAddress.RouteOrderFromKh).ToList();
            }

            model.Publishers = publisherService.GetPublishers(true).Where(w => w.Id != 1).ToList(); // dont show publisher id 1 = admin
            model.CallTypes = callActivityService.GetCallTypes();
            model.Status = callActivityService.GetStatusByCallType(model.CallActivity.CallTypeId);
            model.Status.Insert(0, new CallActivityStatu { Id = -1, Status = " - " });

            int callGroupId = -1;
            if (model.CallActivity.CallGroupId <= 0)
            {
                model.CallActivityAddresses = new List<CallActivityAddress>();
            }
            else
            {
                if (isReloadAddress || !model.IsEditMode)
                {
                    callGroupId = model.CallActivity.CallGroupId;
                    model.CallActivityAddresses = mapService.GetCallAddressToCallActivity(callGroupId);
                }
            }                
                
            model.Publishers.Insert(0, new Publisher { Id = -1, Name = " - " });
            model.AvailableMaps.Insert(0, new CallGroup { Id = -1, CallGroupName = " - " });
        }

        private void HibernateCallActivityModel(CallActivityModel model)
        {
            if (model.CallActivity.Publisher == null && model.CallActivity.ReleasedToPublisherId > 0)
            {
                model.CallActivity.Publisher = publisherService.GetPublisherById(model.CallActivity.ReleasedToPublisherId);
            }

            if (model.CurrentCycle == null)
            {
                model.CurrentCycle = mapService.GetCurrentCycle();
            }

            if (model.CallActivity.Cycle == null && model.CallActivity.CycleId > 0)
            {
                model.CallActivity.Cycle = mapService.GetCycleById(model.CallActivity.CycleId);
            }

            if ((model.CallActivityAddresses == null || model.CallActivityAddresses.Count == 0) && model.IsEditMode)
            {
                model.CallActivityAddresses = callActivityService.GetCallActivityAddresses(model.CallActivity.Id);
            }

            if (model.CallActivity.CallType == null && model.CallActivity.CallTypeId > 0)
            {
                model.CallActivity.CallType = callActivityService.GetCallTypeById(model.CallActivity.CallTypeId);
            }

            HibernateCallActivityAddress(model.CallActivityAddresses);
        }

        private void HibernateCallActivityAddress(IList<CallActivityAddress> callActivityAddresses)
        {
            if (callActivityAddresses != null && callActivityAddresses.Any())
            {
                foreach (var callAddress in callActivityAddresses)
                {

                    if (callAddress.CallAddress == null)
                    {
                        callAddress.CallAddress = mapService.GetCallAddress(callAddress.CallAddressId);
                    }                    
                }                
            }
        }

        private void HibernateCallActivity(IList<CallActivity> callActivities)
        {
            foreach(var callActivity in callActivities){
                callActivity.AddressesInMap = new List<PlotAddressInMapModel>();
            }
        }

        private List<PlotAddressInMapModel> HibernateCallAddress(IList<CallActivityAddress> callActivityAddresses)
        {
            var addressInMap = new List<PlotAddressInMapModel>();
            for (var i = 0; i < callActivityAddresses.Count; i++ )
            {
                callActivityAddresses[i].CallAddress.CallActivityStatu = callActivityAddresses[i].CallActivityStatu;
                callActivityAddresses[i].CallAddress.LastCallActivityStatusId = callActivityAddresses[i].CallActivityStatusId;                    
            }

            addressInMap.AddRange(mapService.HibernateCallAddress(callActivityAddresses.Select(s => s.CallAddress).ToList()));

            return addressInMap;
        }
    }
}
