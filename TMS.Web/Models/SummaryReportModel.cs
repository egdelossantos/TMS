using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using TMS.Entity.DataModel;

namespace TerritoryManagementSystem.Models
{
    public class SummaryReportModel
    {
        public string ReportPeriod { get; set; }

        public string ReportTitle { get; set; }

        public GetMapActivitySummary_Result Result { get; set; }
    }
}