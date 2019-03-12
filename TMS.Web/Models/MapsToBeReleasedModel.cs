using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity;
using System.Globalization;
using System.Web.Security;
using TMS.Entity.DataModel;

namespace TerritoryManagementSystem.Models
{
    public class MapsToBeReleasedModel
    {
        public List<CallGroup> AvailableMaps { get; set; }

        public List<MapsToReleaseByAssistant> MapsToBeReleased { get; set; }
    }
}
