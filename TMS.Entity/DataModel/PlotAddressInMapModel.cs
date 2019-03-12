using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using TMS.Entity.DataModel;

namespace TMS.Entity.DataModel
{
    public class PlotAddressInMapModel
    {
        public int AddressdId { get; set; }
        public string AddressDisplay { get; set; }
        public string GpsAddress { get; set; }
        public double Latitude { get; set; }
        public double Longtitude { get; set; }
        public int CallGroupId { get; set; }
        public string CallGroupName { get; set; }
        public int RouteOrder { get; set; }
        public string Status { get; set; }

        private string _mapMarkerColour;
        public string MapMarkerColour
        {
            get
            {
                if (string.IsNullOrWhiteSpace(_mapMarkerColour))
                {
                    return "red";
                }
                else
                {
                    return _mapMarkerColour;
                }
            }
            set
            {
                _mapMarkerColour = value;
            }
        }
    }
}