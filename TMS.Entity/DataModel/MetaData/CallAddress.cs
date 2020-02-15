using System;
using System.Linq;
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
                var address = string.Format("{0}, {1} Australia", AddressDisplay, Suburb.State.StateName);

                return address;
            }
        }

        public string FullAddress
        {
            get
            {
                var address = string.Format("{0}, {1} Australia", AddressDisplay, Suburb.State.StateName);

                if (!string.IsNullOrWhiteSpace(Unit))
                {
                    address = string.Format("{0}/{1}", Unit, address);
                }

                return address;
            }
        }

        public string FullAddressNoStreetType
        {
            get
            {
                string[] separator = { " " };
                var parts = Street.Split(separator, StringSplitOptions.RemoveEmptyEntries);
                parts = parts.Take(parts.Length - 1).ToArray();
                var streetNoType = string.Join(",", parts);

                var address = string.Format("{0} {1}, {2}", Number, streetNoType, Suburb == null ? string.Empty : Suburb.SuburbName);

                if (!string.IsNullOrWhiteSpace(Unit))
                {
                    address = string.Format("{0}/{1}", Unit, address);
                }

                address = string.Format("{0}, {1} Australia", address, Suburb.State.StateName);

                return address;
            }
        }

        public string CompleteAddress(bool withStreetType = true, bool useAlternativeSuburb = false)
        {
            var streetName = Street;

            if (!withStreetType)
            {
                string[] separator = { " " };
                var parts = Street.Split(separator, StringSplitOptions.RemoveEmptyEntries);
                parts = parts.Take(parts.Length - 1).ToArray();
                streetName = string.Join(",", parts);
            }

            var suburbName = Suburb == null ? string.Empty : useAlternativeSuburb ? Suburb.AlternativeName ?? Suburb.SuburbName : Suburb.SuburbName;

            var address = string.Format("{0} {1}, {2}", Number, streetName, suburbName);

            if (!string.IsNullOrWhiteSpace(Unit))
            {
                address = string.Format("{0}/{1}", Unit, address);
            }

            address = string.Format("{0}, {1} Australia", address, Suburb.State.StateName);

            return address;
        }
    }
}
