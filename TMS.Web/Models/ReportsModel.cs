using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using TMS.Entity.DataModel;

namespace TerritoryManagementSystem.Models
{
    public class ReportsModel
    {
        public enum ReportTypeEnum
        {
            ActivitySummary,
            ActivityDetail
        }

        [Required]
        [Display(Name = "Date From")]
        public DateTime DateFrom { get; set; }

        [Required]
        [Display(Name = "Date To")]
        public DateTime DateTo { get; set; }

        public string ReportTitle { get; set; }

        public ReportTypeEnum ReportType { get; set; }

        public string ReportAction { get; set; }

        public string ReportPeriod {
            get {
                var dateTo = DateTo;
                if (dateTo == null)
                {
                    dateTo = DateTime.Now;
                }

                return string.Format("{0:MMM dd, yyyy} to {1:MMM dd, yyyy}", DateFrom, dateTo);
            }
        }

        public GetMapActivitySummary_Result ActivitySummaryResult { get; set; }

        public GetMapActivityDetail_Result ActivityDetailResult { get; set; }

        public IList<CallGroup> CallGroupList { get; set; }
    }
}