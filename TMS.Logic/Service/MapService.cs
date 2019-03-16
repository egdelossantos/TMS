using GoogleMaps.LocationServices;
using Google.Maps;
using Google.Maps.DistanceMatrix;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TMS.Entity.DataModel;
using TMS.Entity.Enum;
using TMS.Common;
using TMS.Logic.Repository;
using tms.api.Model;

namespace TMS.Logic.Service
{
    public class MapService
    {
        private readonly CallGroupRepository callGroupRepository;
        private readonly CallAddressRepository callAddressRepository;
        private readonly SystemReferenceRepository systemReferenceRepository;
        private readonly CycleRepository cycleRepository;
        public Address KingdomHallLocation;
        
        public MapService(CallGroupRepository callGroupRepository, CallAddressRepository callAddressRepository, SystemReferenceRepository systemReferenceRepository, CycleRepository cycleRepository)
        {
            this.callGroupRepository = callGroupRepository;
            this.callAddressRepository = callAddressRepository;
            this.systemReferenceRepository = systemReferenceRepository;
            this.cycleRepository = cycleRepository;
            this.KingdomHallLocation = new Address
            {
                Unit = string.Empty,
                Number = Config.KingdomHallNumber,
                StreetName = Config.KingdomHallStreet,
                Suburb = Config.KingdomHallSuburb,
                State = Config.KingdomHallState,
                Country = Config.KingdomHallCountry
            };
        }

        public Cycle GetCurrentCycle()
        {
            var systemRef = GetSystemReference();

            var localCurrentCycle = systemRef.Cycle;
            var mapsCovered = AreAllMapsCoveredInThisCycle(localCurrentCycle);

            if (mapsCovered)
            {
                localCurrentCycle = CreateNewCycle(systemRef);
            }
            
            return localCurrentCycle;
        }

        public Cycle GetCycleById(int id)
        {
            return cycleRepository.GetById(id);
        }

        public IList<CallGroup> GetCallGroups(Cycle cycle, bool availableOnly = true, bool approvedForReleaseOnly = false)
        {
            var callGroups = callGroupRepository.GetAll();
            
            // available means not called in this cycle
            if (availableOnly){
                callGroups = callGroups.Where(w => w.CurrentAssignCallActivityId == null);
            }

            if (cycle != null)
            {
                callGroups = callGroups.Where(w => w.CallActivity1 == null || w.CallActivity1.Cycle.CycleNumber < cycle.CycleNumber);
            }

            var result = callGroups.ToList().Where(w => w.CallAddresses != null && w.CallAddresses.Count(ca => ca.IsValid == true) > 0).ToList();

            if (approvedForReleaseOnly)
            {
                result = result.Where(w => w.AllowAssistantToRelease).ToList();
            }

            result = result.OrderBy(o => o.GroupCode, new SemiNumericComparer()).ToList();

            return result;
        }

        public CallGroup GetCallGroup(int id)
        {
            return callGroupRepository.GetById(id);
        }

        public IList<CallAddress> GetCallAddresses(int callGroupId = -1, int suburbId = -1, bool excludeInvalid = true)
        {
            var callAddress = callAddressRepository.GetAll();

            if (!(callGroupId == -1 && suburbId == -1))
            {
                if (callGroupId != -1 && suburbId != -1)
                {
                    callAddress = callAddressRepository.GetAll().Where(w => w.CallGroupId == callGroupId && w.SuburbId == suburbId);
                }
                else{
                    callAddress = callAddressRepository.GetAll().Where(w => w.CallGroupId == callGroupId || w.SuburbId == suburbId);
                }                
            }            

            var list = callAddress.ToList();

            if (excludeInvalid)
            {
                list = list.Where(w => w.IsValid).ToList();
            }
            
            return list;
        }

        public IList<CallAddress> GetCallAddresses(List<int> addressId)
        {
            var callAddress = callAddressRepository.GetAll().Where(w => addressId.Contains(w.Id)).ToList();

            return callAddress;
        }

        public CallAddress GetCallAddress(int addressId)
        {
            var callAddress = callAddressRepository.GetById(addressId);

            return callAddress;
        }

        public IList<CallActivityAddress> GetCallAddressToCallActivity(int callGroupId)
        {
            var list = GetCallAddresses(callGroupId)                    
                                .Select(s => new CallActivityAddress
                                {
                                    CallAddress = s
                                })
                                .OrderBy(o => o.CallAddress.RouteOrderFromKh)
                                .ToList();

            return list;
        }

        public void SetMapsAllowToBeReleased(IList<CallGroup> callGroups)
        {
            foreach(var callGroup in callGroups){
                SetMapAllowToBeReleased(callGroup.Id, callGroup.AllowAssistantToRelease);
            }
        }

        public void SetMapAllowToBeReleased(int callGroupId, bool allow)
        {
            var callGroup = callGroupRepository.GetById(callGroupId);
            if (callGroup != null)
            {
                callGroup.AllowAssistantToRelease = allow;
            }

            callGroupRepository.SaveOrUpdate(callGroup);
        }

        public void UpdateAddressGeoCode(IList<CallAddress> addresses)
        {
            foreach (var address in addresses)
            {
                var address1 = GetGeoCodeCallAddress(address);

                callAddressRepository.SaveOrUpdate(address);
            }
        }

        public CallAddress GetGeoCodeCallAddress(CallAddress address)
        {
            var locationService = new GoogleLocationService();
            var point = locationService.GetLatLongFromAddress(address.FullGpsAddress);

            address.Latitude = point.Latitude;
            address.Longtitude = point.Longitude;

            return address;
        }

        public IList<PlotAddressInMapModel> HibernateCallAddress(IList<CallAddress> addresses, string mapMarkerColour = "red")
        {
            var result = addresses.Select(s => new PlotAddressInMapModel
            {
                AddressdId = s.Id,
                AddressDisplay = s.AddressDisplay,
                GpsAddress = s.FullGpsAddress,
                CallGroupId = s.CallGroupId ?? -1,
                CallGroupName = s.CallGroup == null ? string.Empty : s.CallGroup.CallGroupName,
                Latitude = s.Latitude ?? 0.00,
                Longtitude = s.Longtitude ?? 0.00,
                RouteOrder = s.RouteOrderFromKh ?? 0,
                MapMarkerColour = mapMarkerColour,
                Status = s.CallActivityStatu != null ? s.CallActivityStatu.Status : string.Empty

            }).OrderBy(o => o.CallGroupId).ThenBy(o1 => o1.RouteOrder).ToList();

            return result;
        }

        private Cycle CreateNewCycle(SystemReference sysRef)
        {
            var latestCycle = cycleRepository.GetLatestCycle();
            latestCycle.EndDate = TimeConverter.ConvertToLocalTime(DateTime.Now);
            cycleRepository.SaveOrUpdate(latestCycle);

            var cycle = new Cycle
            {
                Id = 0,
                CycleNumber = latestCycle.CycleNumber + 1,
                StartDate = TimeConverter.ConvertToLocalTime(DateTime.Now)
            };

            cycleRepository.SaveOrUpdate(cycle);

            sysRef.CurrentCycleId = cycle.Id;
            sysRef.CurrentCycleNumber = cycle.CycleNumber;
            systemReferenceRepository.SaveOrUpdate(sysRef);

            return cycle;
        }

        private SystemReference GetSystemReference()
        {
            var systemRef = systemReferenceRepository.GetAll().FirstOrDefault();
            if (systemRef == null)
            {
                var currentCycle = cycleRepository.GetLatestCycle();

                // if no record, create one
                systemRef = new SystemReference
                {
                    Id = 0,
                    CurrentCycleId = currentCycle.Id,
                    CurrentCycleNumber = currentCycle.CycleNumber
                };

                systemReferenceRepository.SaveOrUpdate(systemRef);
            }

            return systemRef;
        }

        private bool AreAllMapsCoveredInThisCycle(Cycle cycle)
        {
            var callGroups = callGroupRepository.GetAll().Where(w => w.IsActive);
            var callGroupsCovered = callGroups.Where(w => w.IsActive && (w.CallActivity != null && w.CallActivity.CycleId == cycle.Id) || (w.CallActivity1 != null && w.CallActivity1.CycleId == cycle.Id));
            return callGroupsCovered.Count() == callGroups.Count(); // equals means covered
        }

        public MapRouteAddress GetBestRoute(MapRouteAddress mapAddress)
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

        public Address GetNearestFromOrigin(Address origin, List<Address> addresses)
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

        private List<Address> GetDistanceFromOrigin(Address origin, List<Address> addresses)
        {
            DistanceMatrixRequest request = new DistanceMatrixRequest();

            request.AddOrigin(new Location(origin.GpsAddress));

            foreach (Address address in addresses)
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