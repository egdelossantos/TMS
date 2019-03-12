using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using TMS.Entity.DataModel;

namespace TerritoryManagementSystem.Models
{
    public class DetailReportModel
    {
        public string ReportPeriod { get; set; }

        public string ReportTitle { get; set; }

        public IList<GetMapActivityDetail_Result> Result { get; set; }

        public IList<CallGroup> CallGroupList { get; set; }
    }
}