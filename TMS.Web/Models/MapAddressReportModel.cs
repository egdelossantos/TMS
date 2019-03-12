using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using TMS.Entity.DataModel;

namespace TerritoryManagementSystem.Models
{
    public class MapAddressReportModel
    {
        public List<CallGroup> CallGroups { get; set; }
    }
}