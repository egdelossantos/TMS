using System.Collections.Generic;

namespace tms.api.Model
{
    public class MapRouteAddress
    {
        public Address Origin { get; set; }

        public List<Address> Destinations { get; set; }
    }
}