using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TMS.Common;
using TMS.Entity.DataModel;
using TMS.Entity.Enum;
using TMS.Logic.Repository;

namespace TMS.Logic.Service
{
    public class CallActivityService
    {
        private readonly CallActivityRepository callActivityRepository;
        private readonly CallActivityAddressRepository callActivityAddressRepository;        
        private readonly CallTypeRepository callTypeRepository;
        private readonly CallGroupRepository callGroupRepository;
        private readonly CallActivityStatusRepository callActivityStatusRepository;
        private readonly CallAddressRepository callAddressRepository;
        
        public CallActivityService(CallActivityRepository callActivityRepository, 
                                   CallActivityAddressRepository callActivityAddressRepository,
                                   CallTypeRepository callTypeRepository, 
                                   CallGroupRepository callGroupRepository,
                                   CallActivityStatusRepository callActivityStatusRepository,
                                   CallAddressRepository callAddressRepository)
        {
            this.callActivityRepository = callActivityRepository;
            this.callActivityAddressRepository = callActivityAddressRepository;
            this.callTypeRepository = callTypeRepository;
            this.callGroupRepository = callGroupRepository;
            this.callActivityStatusRepository = callActivityStatusRepository;
            this.callAddressRepository = callAddressRepository;
        }

        public IList<CallActivity> GetUnreturnedMaps(Publisher publisher)
        {
            var result = callActivityRepository.GetUnReturnedMaps(publisher.Id).ToList();

            var callActivities = result.Select(s => new CallActivity
            {
                Id = s.Id,
                CallTypeId = s.CallTypeId,
                CallType = new CallType { Id = s.CallTypeId, CallTypeName = s.CallTypeName },
                CallGroupId = s.CallGroupId,
                CallGroup = new CallGroup { Id = s.CallGroupId, CallGroupName = s.CallGroupName },
                DateReleased = s.DateReleased,
                ReleasedToPublisherId = s.ReleasedToPublisherId,
                Publisher = new Publisher { Id = s.ReleasedToPublisherId, Name = s.PublisherName, EmailAddress = s.EmailAddress },
                DaysOut = s.DaysOut,
                WarningSeverity = s.WarningSeverity,
                WarningColour = s.WarningColour
            }).ToList();

            return callActivities;
        }

        public IList<CallActivity> GetUnReturnedCallAddresses(Publisher publisher)
        {
            var result = callActivityRepository.GetUnReturnedCallAddresses(publisher.Id).ToList();

            var callActivities = result.GroupBy(g => new { g.Id, g.CallGroupId, g.CallGroupName, g.CallTypeId, g.CallTypeName, g.DateReleased, g.ReleasedToPublisherId, PublisherName = g.Name, g.PhoneNumber, g.EmailAddress, g.DaysOut, g.WarningSeverity, g.WarningColour })
                                        .Select(s => new CallActivity
                                        {
                                            Id = s.Key.Id,
                                            CallTypeId = s.Key.CallTypeId,
                                            CallType = new CallType { Id = s.Key.CallTypeId, CallTypeName = s.Key.CallTypeName },
                                            CallGroupId = s.Key.CallGroupId,
                                            CallGroup = new CallGroup { Id = s.Key.CallGroupId, CallGroupName = s.Key.CallGroupName },
                                            DateReleased = s.Key.DateReleased,
                                            ReleasedToPublisherId = s.Key.ReleasedToPublisherId,
                                            Publisher = new Publisher { Id = s.Key.ReleasedToPublisherId, Name = s.Key.PublisherName, PhoneNumber = s.Key.PhoneNumber, EmailAddress = s.Key.EmailAddress },
                                            DaysOut = s.Key.DaysOut ?? 0,
                                            WarningSeverity = s.Key.WarningSeverity,
                                            WarningColour = s.Key.WarningColour,
                                            CallActivityAddresses = s.Select(s1 => new CallActivityAddress
                                            {
                                                Id = s1.CallActivityAddressId,
                                                CallActivityId = s.Key.Id,
                                                CallAddressId = s1.CallAddressId,
                                                Address = s1.Address,
                                                CallActivityStatusId = s1.CallActivityStatusId,
                                                CallActivityStatu = new CallActivityStatu { Id = s1.CallActivityStatusId ?? 0, Status = s1.CallActivityStatus },
                                                CallAddress = new CallAddress { 
                                                    Id = s1.CallAddressId, 
                                                    RouteOrderFromKh = s1.RouteOrderFromKh
                                                },
                                                Note = s1.Note

                                            }).OrderBy(o => o.CallAddress.RouteOrderFromKh).ToList()
                                        }).ToList();

            var dontIncludeInResult = new List<int>();
            foreach(var callActivity in callActivities){
                var allAddressVisited = !(callActivity.CallActivityAddresses.Any(c => c.CallActivityStatusId == null));
                if (allAddressVisited)
                {
                    callActivity.WarningSeverity = 3;
                    callActivity.WarningColour = "info";
                    callActivity.AllAddressVisited = true;

                    if (!publisher.IsTerritoryOverseer)
                    {
                        var haveAtLeastOneNotAtHome1 = callActivity.CallActivityAddresses.Any(c => c.CallActivityStatusId ==  (int)ActivityStatusEnum.Status.NotAtHome1);
                        if (!haveAtLeastOneNotAtHome1)
                        {
                            dontIncludeInResult.Add(callActivity.Id);
                        }
                    }
                }

                foreach (var callActivityAddress in callActivity.CallActivityAddresses)
                {
                    var dbCallAddress = callAddressRepository.GetById(callActivityAddress.CallAddressId);
                    callActivityAddress.CallAddress.Unit = dbCallAddress.Unit;
                    callActivityAddress.CallAddress.Number = dbCallAddress.Number;
                    callActivityAddress.CallAddress.Street = dbCallAddress.Street;
                    callActivityAddress.CallAddress.Suburb = new Suburb { Id = dbCallAddress.SuburbId, SuburbName = dbCallAddress.Suburb.SuburbName, State = new State { Id = dbCallAddress.Suburb.State.Id, StateName = dbCallAddress.Suburb.State.StateName } };
                    callActivityAddress.CallAddress.Latitude = dbCallAddress.Latitude;
                    callActivityAddress.CallAddress.Longtitude = dbCallAddress.Longtitude;                         
                }
            }

            callActivities.RemoveAll(r => dontIncludeInResult.Contains(r.Id));

            return callActivities.OrderByDescending(o => o.AllAddressVisited).ThenBy(o => o.DateReleased).ToList();
        }

        public IList<GetMapActivity_Result> GetMapActivityReport(DateTime dateFrom, DateTime dateTo)
        {
            var result = callActivityRepository.GetMapActivityReport(dateFrom, dateTo);

            return result;
        }

        public IList<GetMapActivitySummary_Result> GetMapActivitySummaryReport(DateTime dateFrom, DateTime dateTo)
        {
            var result = callActivityRepository.GetMapActivitySummary(dateFrom, dateTo);

            return result;
        }

        public IList<GetMapActivityDetail_Result> GetMapActivityDetailReport(DateTime dateFrom, DateTime dateTo)
        {
            var result = callActivityRepository.GetMapActivityDetail(dateFrom, dateTo);

            return result;
        }

        public CallActivity GetCallActivityById(int id)
        {
            var callActivity = callActivityRepository.GetById(id);

            return callActivity;
        }

        public IList<CallType> GetCallTypes()
        {
            var callTypes = callTypeRepository.GetAll();

            return callTypes.ToList();
        }

        public IList<CallActivityStatu> GetStatus()
        {
            var status = callActivityStatusRepository.GetAll();

            return status.ToList();
        }

        public IList<CallActivityStatu> GetStatusByCallType(int callTypeId)
        {
            var status = GetStatus();

            if (callTypeId == (int)CallTypeEnum.CallType.Campaign)
            {
                var campaignStatus = new[] { (int)ActivityStatusEnum.Status.Done, (int)ActivityStatusEnum.Status.NotFilipino, (int)ActivityStatusEnum.Status.AddressNotFound };
                status = status.Where(w => campaignStatus.Contains(w.Id)).ToList();
            }

            return status.ToList();
        }

        public string ValidateCallActivity(CallActivity callActivity)
        {
            var currentMapOwner = callActivityRepository.GetAll().FirstOrDefault(w => w.CallGroupId == callActivity.CallGroupId && w.DateReturned == null);
            if (currentMapOwner != null)
            {
                var callGroup = callGroupRepository.GetById(callActivity.CallGroupId);
                return string.Format("{0} is currently assigned to {1}.", callGroup.GroupNameWithCount, currentMapOwner.Publisher.Name);
            }

            return string.Empty;
        }

        public CallActivity SaveCallActivity(CallActivity callActivity,
                                            IList<CallActivityAddress> callActivityAddresses,
                                            Publisher loggedInUser, 
                                            Cycle cycle)
        {
            SaveCallActivityDetails(callActivity, callActivityAddresses, loggedInUser, cycle);

            SaveCallActivityAddress(callActivity, callActivityAddresses, loggedInUser);

            return callActivity;
        }

        public void SaveCallActivityAddress(CallActivity callActivity, IList<CallActivityAddress> callActivityAddresses, Publisher loggedInUser)
        {
            foreach (var callActivityAddress in callActivityAddresses.Where(w => w.CallActivityStatusId != null))
            {
                UpdateCallActivityAddress(callActivityAddress);
            }

            if (callActivity.DateReturned != null)
            {
                var doneStatus = callActivityStatusRepository.GetById((int)ActivityStatusEnum.Status.Done);
                foreach (var callActivityAddress in callActivityAddresses)
                {
                    if (callActivityAddress.CallActivityStatusId == null || callActivityAddress.CallActivityStatusId <= 0)
                    {
                        callActivityAddress.CallActivityStatusId = doneStatus.Id; //Done
                        callActivityAddress.CallActivityStatu = doneStatus;
                        UpdateCallActivityAddress(callActivityAddress);
                    }

                    UpdateCallAddressLatestInfo(callActivityAddress);

                    if (loggedInUser.IsAdmin || loggedInUser.IsTerritoryOverseer)
                    {
                        DeactivateCallAddress(callActivityAddress, loggedInUser);
                    }
                }                    
            }
        }

        public string EmailCallAddress(CallActivity callActivity)
        {
            // email call address
            var email = callActivity.Publisher.EmailAddress.ToLower();            
            var emailHandler = new EmailNotificationHandler();
            var dateReleased = callActivity.DateReleased.ToString("yyyy-MM-dd");
            string emailSubject = string.Format("Map {0} Released on {1}", callActivity.CallGroup.GroupNameWithCount, dateReleased);
            string emailBody = string.Format(
                    @"
                          <html>
                            <body>
                                <div>
                                    Publisher : {0}
                                </div>
                                <div style='margin-bottom:10px;'>
                                    Date Released : {1}
                                </div>
                                <div>
                                    {2}
                                </div> 
                                <div>                                                    
                                    {3}
                                </div>
                                <div>
                                    <span style = 'font-size:.8em;'>Territory Management System - Kings Park Congregation
                                </div>
                            </body> 
                        </html>",
                    callActivity.Publisher.Name,
                    dateReleased,
                    callActivity.CallGroup.GroupNameWithCount,
                    callActivity.ContentHtml);

            bool sendEmailSuccess = emailHandler.SendEmailNotification(email, "noreply@territory101.info", emailSubject, emailBody);

            var result = "Ok";
            if (!sendEmailSuccess)
            {
                result = "An error occured while sending email.";
            }

            return result;
        }

        private void DeactivateCallAddress(CallActivityAddress callActivityAddress, Publisher loggedInUser)
        {
            if (callActivityAddress.CallActivityStatusId > 0 && callActivityAddress.CallActivityStatu == null)
            {
                callActivityAddress.CallActivityStatu = callActivityStatusRepository.GetById((int)callActivityAddress.CallActivityStatusId);
            }

            if (callActivityAddress.CallActivityStatu.IsValidAddress)
            {
                return;
            }

            var localAddress = callAddressRepository.GetById(callActivityAddress.CallAddressId);
            if (localAddress == null)
            {
                return;
            }

            callAddressRepository.DeactivateCallAddresses(localAddress.Id, TimeConverter.ConvertToLocalTime(DateTime.Now), loggedInUser.Id);
            
            // check if map is still valid
            // if all address are invalid, make the map invalid too
            var callGroupValidAddressCount = callAddressRepository.GetAll().Count(w => w.CallGroupId == localAddress.CallGroupId && w.IsValid == true);
            if (callGroupValidAddressCount <= 0)
            {
                var callGroup = callGroupRepository.GetById((int)localAddress.CallGroupId);
                if (callGroup != null)
                {
                    callGroup.IsActive = false;
                    callGroupRepository.SaveOrUpdate(callGroup);
                }
            }
        }

        private void SaveCallActivityDetails(CallActivity callActivity, IList<CallActivityAddress> callActivityAddresses, Publisher loggedInUser, Cycle cycle)
        {
            var dbCallActivity = GetCallActivityById(callActivity.Id);
            if (dbCallActivity == null)
            {
                dbCallActivity = new CallActivity
                {
                    Id = 0,
                    CallGroupId = callActivity.CallGroupId,
                    CallTypeId = callActivity.CallTypeId,
                    ReleasedToPublisherId = callActivity.ReleasedToPublisherId,
                    ReleasedByUserId = loggedInUser.Id,
                    DateReleased = callActivity.DateReleased,
                    CycleId = cycle.Id
                };

                var callAddress = callGroupRepository.GetAddressInCallGroup(callActivity.CallGroupId).ToList();
                dbCallActivity.CallActivityAddresses = callAddress.Select(s => new CallActivityAddress
                {
                    Id = 0,
                    CallActivity = dbCallActivity,
                    CallAddressId = s.Id
                }).ToList();
            }
            else
            {
                dbCallActivity.CallTypeId = callActivity.CallTypeId;
                dbCallActivity.ReleasedToPublisherId = callActivity.ReleasedToPublisherId;
            }

            if (callActivity.DateReturned == null)
            {
                var doneActivities = callActivityAddresses.Count(c => c.CallActivityStatusId == (int)ActivityStatusEnum.Status.Done || c.CallActivityStatusId == (int)ActivityStatusEnum.Status.NotAtHome2);
                if (doneActivities == callActivityAddresses.Count)
                {
                    callActivity.DateReturned = TimeConverter.ConvertToLocalTime(DateTime.Now);
                    callActivity.ReturnedToUserId = loggedInUser.Id;
                }
            }

            // set who tag map as completed
            if (dbCallActivity.DateReturned == null && callActivity.DateReturned != null)
            {
                dbCallActivity.ReturnedToUserId = loggedInUser.Id;
            }

            dbCallActivity.DateReleased = callActivity.DateReleased;
            dbCallActivity.DateReturned = callActivity.DateReturned;

            callActivityRepository.SaveOrUpdate(dbCallActivity);

            // call group update
            var callGroup = callGroupRepository.GetById(callActivity.CallGroupId);

            if (callActivity.DateReturned == null)
            {
                callGroup.CurrentAssignCallActivityId = dbCallActivity.Id;
            }
            else
            {
                callGroup.CurrentAssignCallActivityId = null;
                callGroup.LastAssignCallActivityId = dbCallActivity.Id;
            }

            callGroup.AllowAssistantToRelease = false;

            callGroupRepository.SaveOrUpdate(callGroup);
        }

        private void UpdateCallActivityAddress(CallActivityAddress callActivityAddresses)
        {
            var localAddress = callActivityAddressRepository.GetById(callActivityAddresses.Id);
            if (localAddress == null)
            {
                return;
            }

            // dont touch if status is same
            if (localAddress.CallActivityStatusId == callActivityAddresses.CallActivityStatusId)
            {
                return;
            }

            localAddress.CallActivityStatusId = callActivityAddresses.CallActivityStatusId <= 0 ? null : callActivityAddresses.CallActivityStatusId;

            localAddress.DateFinished = localAddress.CallActivityStatusId != null ? (DateTime?)TimeConverter.ConvertToLocalTime(DateTime.Now) : null;

            callActivityAddresses.DateFinished = localAddress.DateFinished;

            callActivityAddressRepository.SaveOrUpdate(localAddress);
        }

        private void UpdateCallAddressLatestInfo(CallActivityAddress callActivityAddresses)
        {
            var localAddress = callAddressRepository.GetById(callActivityAddresses.CallAddressId);
            if (localAddress == null)
            {
                return;
            }

            localAddress.LastCallDate = callActivityAddresses.DateFinished;
            localAddress.LastCallActivityStatusId = callActivityAddresses.CallActivityStatusId;

            callAddressRepository.SaveOrUpdate(localAddress);
        }

        public IList<CallActivityAddress> GetCallActivityAddresses(int callActivityId)
        {
            var addresses = callActivityAddressRepository.GetCallActivityAddresses(callActivityId).ToList();

            return addresses;
        }

        public CallActivityAddress GetCallActivityAddressById(int id)
        {
            var address = callActivityAddressRepository.GetById(id);

            return address;
        }

        public string DeleteCallActivity(int id)
        {
            var callActivity = callActivityRepository.GetById(id);
            if (callActivity == null)
            {
                return "Error deleting Call Activity";
            }

            var addresses = callActivityAddressRepository.GetCallActivityAddresses(id).ToList();
            if (addresses.Any(w => w.CallActivityStatusId != null && w.CallActivityStatusId > 0))
            {
                return "Cannot delete this Call Activity. Call Address has been updated.";
            }

            var callGroup = callGroupRepository.GetById(callActivity.CallGroupId);
            callGroup.CurrentAssignCallActivityId = null;
            callGroup.AllowAssistantToRelease = true;

            callGroupRepository.SaveOrUpdate(callGroup);

            callActivityAddressRepository.DeleteCallActivityAddress(addresses.Select(s => s.Id).ToArray());
            
            callActivity.Destroy = true;
            callActivityRepository.SaveOrUpdate(callActivity);

            return string.Empty;
        }        
    }
}
