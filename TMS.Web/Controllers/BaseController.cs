using System.Web.Mvc;
using TMS.Entity.DataModel;
using TMS.Logic.Service;
using WebMatrix.WebData;

namespace TerritoryManagementSystem.Controllers
{
    [Authorize]
    public class BaseController : Controller
    {
        private readonly PublisherService publisherService;
        private readonly MapService mapService;

        public BaseController(PublisherService publisherService, MapService mapService)
        {
            this.publisherService = publisherService;
            this.mapService = mapService;
        }

        protected PublisherService PublisherService
        {
            get { return publisherService; }
        }

        protected Publisher LoggedInPublisher
        {
            get { return ViewBag.LoggedInPublisher as Publisher; }
        }

        protected Cycle CurrentCycle
        {
            get { return ViewBag.CurrentCycle as Cycle; }
        }

        protected override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            ViewBag.IsInTestMode = true;

            if (Request.IsAuthenticated)
            {
                var publisher = publisherService.GetPublisherByEmail(HttpContext.User.Identity.Name);
                if (publisher == null)
                {
                    WebSecurity.Logout();
                }
               
                ViewBag.LoggedInPublisher = publisher;

                ViewBag.CurrentCycle = mapService.GetCurrentCycle();
            }
            else
            {
                ViewBag.LoggedInPublisher = null;
            }
        }

        protected void SetViewBagToastrMessage(string type, string message)
        {
            ViewBag.ToastrType = type;
            ViewBag.ToastrMessage = message;
        }
    }
}