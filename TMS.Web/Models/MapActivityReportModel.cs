using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using TMS.Entity.DataModel;

namespace TerritoryManagementSystem.Models
{
    public class MapActivity
    {
        public string MapNameDisplay
        {
            get
            {
                if (RowNum > 1)
                {
                    return string.Empty;
                }
                else
                {
                    return MapName;
                }
            }

        }

        public string PublisherName { get; set; }
        public string DateReleased { get; set; }
        public string DateReturned { get; set; }

        public int RowNum { get; set; }
        public int CallGroupId { get; set; }
        public string GroupCode { get; set; }
        public string MapName { get; set; }
        public int ActivityCount { get; set; }        
    }

    public class MapActivityReportModel
    {
        public List<MapActivity> MapActivities { get; set; }
    }
}