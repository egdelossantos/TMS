using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TMS.Entity.DataModel.Interfaces;

namespace TMS.Entity.DataModel
{
    public partial class CallAddress : IEntity
    {
        public bool Destroy { get; set;}
        
        public string AddressDisplay
        {
            get
            {
                var address = string.Format("{0} {1}, {2}", Number, Street, Suburb == null ? string.Empty : Suburb.SuburbName);

                if (!string.IsNullOrWhiteSpace(Unit))
                {
                    address = string.Format("{0}/{1}", Unit, address);
                }

                return address;
            }
        }

        public string FullGpsAddress
        {
            get
            {
                var address = string.Format("{0}, {1} Australia", GpsAddress, Suburb == null ? string.Empty : Suburb.SuburbName + ", " + Suburb.State.StateName);

                return address;
            }
        }
    }
}
