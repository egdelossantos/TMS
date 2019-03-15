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
            var publishers = publisherService.GetPublishers(false).Where(w => w.Id != 1) // dont show publisher id 1 = admin
                            .OrderByDescending(o => o.IsActive)
                            .ThenByDescending(e => e.IsTerritoryOverseer)
                            .ThenByDescending(e => e.IsElder)
                            .ThenByDescending(e => e.IsAssistantBrother)                            
                            .ToList(); 

            var publishersJson = PublisherConverter.PublishersToJsonSummary(publishers);

            return Json(new { publishers = publishersJson }, JsonRequestBehavior.AllowGet);
        }

        [HttpGet]
        public ActionResult CreatePublisher()
        {
            var model = new PublisherModel
            {
                Publisher = new Publisher { Id = 0, IsActive = true },
                RoleId = 0,
                UserRoles = publisherService.GetUserRoles()
            };

            return View(model);
        }

        [HttpPost]
        public ActionResult CreatePublisher(PublisherModel model)
        {
            if (SavePublisher(model))
            {                
                return RedirectToAction("Index");
            }
            else
            {
                model.RoleId = model.Publisher.UserRoleId ?? 0;
                model.UserRoles = publisherService.GetUserRoles();
                return View("CreatePublisher", model);
            }
        }

        [HttpGet]
        public ActionResult EditPublisher(int id)
        {
            var model = new PublisherModel
            {
                Publisher = publisherService.GetPublisherById(id),
                UserRoles = publisherService.GetUserRoles()
            };

            model.RoleId = model.Publisher.UserRoleId ?? 0;

            return View(model);
        }

        [HttpPost]
        public ActionResult EditPublisher(PublisherModel model)
        {
            if (SavePublisher(model))
            {
                return RedirectToAction("Index");
            }
            else
            {
                model.RoleId = model.Publisher.UserRoleId ?? 0;
                model.UserRoles = publisherService.GetUserRoles();
                return View("EditPublisher", model);
            }
        }

        private bool SavePublisher(PublisherModel model)
        {
            var isSaved = false;
            ModelState.Remove("Publisher.Id");

            if (ModelState.IsValid)
            {
                var validationResult = model.IsEditMode ? new List<ValidationResult>() : publisherService.ValidatePublisher(model.Publisher);
                if (validationResult.Count > 0)
                {
                    foreach (var result in validationResult)
                        ModelState.AddModelError(string.Format("Publisher.{0}", "EmailAddress"), result.ErrorMessage);
                }
                else
                {
                    model.Publisher = publisherService.SavePublisher(model.Publisher);
                    isSaved = true;
                }
            }
            return isSaved;            
        }
    }
}
