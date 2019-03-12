using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using TerritoryManagementSystem.Models;
using TMS.Entity.DataModel;
using TMS.Logic.Service;
using ReportManagement;
using TMS.Common;

namespace TerritoryManagementSystem.Controllers
{
    public class ReportsFilterController : BaseController
    {
        private MapService mapService;
        private PublisherService publisherService;

        public ReportsFilterController(PublisherService publisherService, MapService mapService)
            : base(publisherService, mapService)
        {
            this.publisherService = publisherService;
            this.mapService = mapService;
        }

        [Authorize]
        [HttpGet]
        public ActionResult MapActivityReport()
        {
            var model = new ReportsModel
            {
                DateFrom = TimeConverter.ConvertToLocalTime(DateTime.Now).Date,
                DateTo = TimeConverter.ConvertToLocalTime(DateTime.Now).Date
            };

            return View("MapActivityReport", model);           
        }

        [Authorize]
        [HttpGet]
        public ActionResult ActivitySummaryReport()
        {
            var model = new ReportsModel
            {
                DateFrom = TimeConverter.ConvertToLocalTime(DateTime.Now).Date.AddMonths(-3),
                DateTo = TimeConverter.ConvertToLocalTime(DateTime.Now),
                ReportTitle = "Map Activity Summary Report",
                ReportType = ReportsModel.ReportTypeEnum.ActivitySummary,
                ReportAction = "MapActivitySummary"
            };

            return View("ReportsFilter", model);
        }

        [Authorize]
        [HttpGet]
        public ActionResult ActivityDetailReport()
        {
            var model = new ReportsModel
            {
                DateFrom = TimeConverter.ConvertToLocalTime(DateTime.Now).Date.AddMonths(-3),
                DateTo = TimeConverter.ConvertToLocalTime(DateTime.Now),
                ReportTitle = "Map Activity Detail Report",
                ReportType = ReportsModel.ReportTypeEnum.ActivityDetail,
                ReportAction = "MapActivityDetail"
            };

            return View("ReportsFilter", model);
        } 
    }
}
