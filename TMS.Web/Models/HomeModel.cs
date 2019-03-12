using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using TMS.Entity.DataModel;

namespace TerritoryManagementSystem.Models
{
    public class HomeModel
    {
        public IList<CallActivity> UnReturnedCallActivities { get; set; }
    }
}