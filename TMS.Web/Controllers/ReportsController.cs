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
    public class ReportsController : PdfViewController
    {
        private CallActivityService callActivityService;
        private MapService mapService;
               
        public ReportsController(PublisherService publisherService, MapService mapService, CallActivityService callActivityService)            
        {
            this.callActivityService = callActivityService;
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
        public ActionResult CurrentMapAddressReport()
        {
            var model = new MapAddressReportModel
            {
                CallGroups = mapService.GetCallGroups(null, false).ToList()
            };

            return this.ViewPdf("MAP ADDRESS", "CurrentMapAddress", model);
        }

        [Authorize]
        [HttpGet]
        public ActionResult MapActivitySummary(DateTime dateFrom, DateTime? dateTo)
        {
            var localDateTo = dateTo == null ? TimeConverter.ConvertToLocalTime(DateTime.Now).Date : (DateTime)dateTo;
            var summaryResult = callActivityService.GetMapActivitySummaryReport(dateFrom, localDateTo).First();

            var result = new SummaryReportModel
            {
                ReportPeriod = string.Format("{0:MMM dd, yyyy} to {1:MMM dd, yyyy}", dateFrom, localDateTo),
                ReportTitle = "Map Activity Summary",
                Result = summaryResult
            };

            return this.ViewPdf("Kings Park Filipino Congregation", "SummaryReport", result);
        }

        [Authorize]
        [HttpGet]
        public ActionResult MapActivityDetail(DateTime dateFrom, DateTime? dateTo)
        {
            var localDateTo = dateTo == null ? TimeConverter.ConvertToLocalTime(DateTime.Now).Date : (DateTime)dateTo;
            var detailResult = callActivityService.GetMapActivityDetailReport(dateFrom, localDateTo).ToList();
            var callGroups = mapService.GetCallGroups(null, false, false).Where(w => w.IsActive).ToList();

            var result = new DetailReportModel
            {
                ReportPeriod = string.Format("{0:MMM dd, yyyy} to {1:MMM dd, yyyy}", dateFrom, localDateTo),
                ReportTitle = "Map Activity Details",
                Result = detailResult,
                CallGroupList = callGroups
            };

            return this.ViewPdf("Kings Park Filipino Congregation", "DetailReport", result);
        }  

        private IList<MapActivity> MapActivityData(DateTime dateFrom, DateTime dateTo)
        {
            var result = callActivityService.GetMapActivityReport(dateFrom, dateTo);

            var reportData = result.Select(s => new MapActivity
            {
                PublisherName = s.PublisherName,
                DateReleased = ((DateTime)s.DateReleased).ToString("yyyy-MM-dd"),
                DateReturned = s.DateReturned == null ? string.Empty : ((DateTime)s.DateReturned).ToString("yyyy-MM-dd"),
                RowNum = s.RowNum,
                ActivityCount = s.ActivityCount,
                MapName = s.MapName,
                CallGroupId = s.CallGroupId,
                GroupCode = s.GroupCode
            }).ToList();

            return reportData;
        }        
    }
}
