using tms.api.Model;

namespace TerritoryManagementSystem.Models
{
    public class AddressBestRouteModel
    {
        public string OriginAddress { get; set; }

        public string DestinationAddress { get; set; }

        public string Result { get; set; }

        public MapRouteAddress RouteAddress { get; set; }
    }
}