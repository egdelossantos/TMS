using Google.Maps;
using Google.Maps.DistanceMatrix;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using tms.api.Common;
using tms.api.Model;

namespace tms.api.Map
{
    public static class MapService
    {
        public static MapRouteAddress GetBestRoute(MapRouteAddress mapAddress)
        {
            var routedAddresses = new List<Address>();
            var origin = mapAddress.Origin;
            var cont = true;

            while (cont)
            {
                var addressesToLookUp = mapAddress.Destinations.Where(addr => !routedAddresses.Any(f => f.GpsAddress == addr.GpsAddress))
                               .Select(addr => addr).ToList();

                cont = addressesToLookUp.Count > 0;

                if (cont)
                {
                    var nearestAddress = GetNearestFromOrigin(origin, addressesToLookUp);
                    routedAddresses.Add(nearestAddress);
                    origin = nearestAddress;
                }
            }            

            return new MapRouteAddress { Origin = mapAddress.Origin, Destinations = routedAddresses };
        }

        public static Address GetNearestFromOrigin(Address origin, List<Address> addresses)
        {
            var sortedAddresses = new List<Address>();

            var batchList = Utility.SplitList(addresses, Config.NumberOfAddressInBatch);

            var listOfTasks = new List<Task>();

            foreach (var batch in batchList)
            {
                listOfTasks.Add(Task.Run(() => sortedAddresses.AddRange(GetDistanceFromOrigin(origin, batch))));
            }

            Task.WaitAll(listOfTasks.ToArray());

            sortedAddresses.Sort(
                (first, second) => first.DistanceMeterFromPrevious.CompareTo(second.DistanceMeterFromPrevious)
            );

            return sortedAddresses.First();
        }

        private static List<Address> GetDistanceFromOrigin(Address origin, List<Address> addresses)
        {
            DistanceMatrixRequest request = new DistanceMatrixRequest();

            request.AddOrigin(new Location(origin.GpsAddress));

            foreach(Address address in addresses)
            {
                request.AddDestination(new Location(address.GpsAddress));
            }
            
            request.Mode = TravelMode.driving;

            var svc = new DistanceMatrixService(new GoogleSigned(Utility.GoogleMapApiKey()));

            DistanceMatrixResponse response = svc.GetResponse(request);

            if (response.Status == ServiceResponseStatus.Ok && response.Rows.Length == 1)
            {
                var responseRow = response.Rows[0];

                for (int i = 0; i < responseRow.Elements.Length; i++)
                {
                    var rowElement = responseRow.Elements[i];

                    if (rowElement.Status == ServiceResponseStatus.Ok)
                    {
                        addresses[i].DistanceMeterFromPrevious = Utility.GetValueFromResponse(rowElement.distance);
                        addresses[i].DistanceFromPreviousDesc = rowElement.distance.ToString();
                        addresses[i].DurationSecondFromPrevious = Utility.GetValueFromResponse(rowElement.duration);
                        addresses[i].DurationFromPreviousDesc = rowElement.duration.ToString();
                    }
                    else
                    {
                        addresses[i].DistanceMeterFromPrevious = -1;
                        addresses[i].DurationSecondFromPrevious = -1;
                        addresses[i].DistanceFromPreviousDesc = string.Empty;
                        addresses[i].DurationFromPreviousDesc = string.Empty;
                    }                    
                }
            }
            else
            {
                Console.WriteLine("Unable to geocode.  Status={0} and ErrorMessage={1}", response.Status, response.ErrorMessage);
            }

            return addresses;
        }
    }
}