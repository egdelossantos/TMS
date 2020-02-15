using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using TMS.Entity.DataModel;

namespace TerritoryManagementSystem.Models
{
    public class AddressModel
    {
        public string ErrorMessage { get; set; }
        public string Unit { get; set; }
        public string Number { get; set; }
        public string Street { get; set; }
        public string Suburb { get; set; }
        public string State { get; set; }
        public string Country { get; set; }
        public float Latitude { get; set; }
        public float Longtitude { get; set; }
        public int SuburbId { get; set; }
        public int CallGroupId { get; set; }

        public IList<CallGroup> Maps { get; set; }

        public IEnumerable<SelectListItem> MapsSelectList
        {
            get {
                var maps = Maps
                            .Where(w => w.IsActive)
                            .OrderBy(o => o.CallGroupDetails)
                            .ToList();
                maps.Insert(0, new CallGroup { Id = 0, CallGroupName = "-" });

                return maps.Select(a => new SelectListItem { Text = a.CallGroupDetails, Value = a.Id.ToString() });
            }
        }
    }
}