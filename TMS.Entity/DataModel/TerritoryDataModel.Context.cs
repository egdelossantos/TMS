﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace TMS.Entity.DataModel
{
    using System;
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    using System.Data.Entity.Core.Objects;
    using System.Linq;
    
    public partial class TerritoryEntities : DbContext
    {
        public TerritoryEntities()
            : base("name=TerritoryEntities")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public virtual DbSet<CallActivityWarning> CallActivityWarnings { get; set; }
        public virtual DbSet<CallAddressNote> CallAddressNotes { get; set; }
        public virtual DbSet<CallType> CallTypes { get; set; }
        public virtual DbSet<Country> Countries { get; set; }
        public virtual DbSet<State> States { get; set; }
        public virtual DbSet<Suburb> Suburbs { get; set; }
        public virtual DbSet<webpages_Membership> webpages_Membership { get; set; }
        public virtual DbSet<webpages_PasswordResets> webpages_PasswordResets { get; set; }
        public virtual DbSet<webpages_Roles> webpages_Roles { get; set; }
        public virtual DbSet<CallActivityStatu> CallActivityStatus { get; set; }
        public virtual DbSet<Cycle> Cycles { get; set; }
        public virtual DbSet<SystemReference> SystemReferences { get; set; }
        public virtual DbSet<CallActivity> CallActivities { get; set; }
        public virtual DbSet<CallActivityAddress> CallActivityAddresses { get; set; }
        public virtual DbSet<Publisher> Publishers { get; set; }
        public virtual DbSet<vwAddress> vwAddresses { get; set; }
        public virtual DbSet<CallGroup> CallGroups { get; set; }
        public virtual DbSet<CallAddress> CallAddresses { get; set; }
        public virtual DbSet<Color> Colors { get; set; }
        public virtual DbSet<InactiveCallAddress> InactiveCallAddresses { get; set; }
    
        public virtual ObjectResult<GetUnReturnedCallAddress_Result> GetUnReturnedCallAddress(Nullable<int> publisherId)
        {
            var publisherIdParameter = publisherId.HasValue ?
                new ObjectParameter("publisherId", publisherId) :
                new ObjectParameter("publisherId", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<GetUnReturnedCallAddress_Result>("GetUnReturnedCallAddress", publisherIdParameter);
        }
    
        public virtual ObjectResult<GetMapActivity_Result> GetMapActivity(Nullable<System.DateTime> fromDate, Nullable<System.DateTime> toDate)
        {
            var fromDateParameter = fromDate.HasValue ?
                new ObjectParameter("fromDate", fromDate) :
                new ObjectParameter("fromDate", typeof(System.DateTime));
    
            var toDateParameter = toDate.HasValue ?
                new ObjectParameter("toDate", toDate) :
                new ObjectParameter("toDate", typeof(System.DateTime));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<GetMapActivity_Result>("GetMapActivity", fromDateParameter, toDateParameter);
        }
    
        public virtual ObjectResult<GetMapActivitySummary_Result> GetMapActivitySummary(Nullable<System.DateTime> dateFrom, Nullable<System.DateTime> dateTo)
        {
            var dateFromParameter = dateFrom.HasValue ?
                new ObjectParameter("dateFrom", dateFrom) :
                new ObjectParameter("dateFrom", typeof(System.DateTime));
    
            var dateToParameter = dateTo.HasValue ?
                new ObjectParameter("dateTo", dateTo) :
                new ObjectParameter("dateTo", typeof(System.DateTime));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<GetMapActivitySummary_Result>("GetMapActivitySummary", dateFromParameter, dateToParameter);
        }
    
        public virtual int DeactivateCallAddress(Nullable<int> callAddressId, Nullable<System.DateTime> approvedDate, Nullable<int> approvedBy)
        {
            var callAddressIdParameter = callAddressId.HasValue ?
                new ObjectParameter("callAddressId", callAddressId) :
                new ObjectParameter("callAddressId", typeof(int));
    
            var approvedDateParameter = approvedDate.HasValue ?
                new ObjectParameter("approvedDate", approvedDate) :
                new ObjectParameter("approvedDate", typeof(System.DateTime));
    
            var approvedByParameter = approvedBy.HasValue ?
                new ObjectParameter("approvedBy", approvedBy) :
                new ObjectParameter("approvedBy", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("DeactivateCallAddress", callAddressIdParameter, approvedDateParameter, approvedByParameter);
        }
    
        public virtual ObjectResult<GetMapActivityDetail_Result> GetMapActivityDetail(Nullable<System.DateTime> dateFrom, Nullable<System.DateTime> dateTo)
        {
            var dateFromParameter = dateFrom.HasValue ?
                new ObjectParameter("dateFrom", dateFrom) :
                new ObjectParameter("dateFrom", typeof(System.DateTime));
    
            var dateToParameter = dateTo.HasValue ?
                new ObjectParameter("dateTo", dateTo) :
                new ObjectParameter("dateTo", typeof(System.DateTime));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<GetMapActivityDetail_Result>("GetMapActivityDetail", dateFromParameter, dateToParameter);
        }
    
        public virtual int SavePublisher(Nullable<int> id, string email, string name, string phoneNumber, Nullable<int> roleID, Nullable<bool> isActive)
        {
            var idParameter = id.HasValue ?
                new ObjectParameter("id", id) :
                new ObjectParameter("id", typeof(int));
    
            var emailParameter = email != null ?
                new ObjectParameter("email", email) :
                new ObjectParameter("email", typeof(string));
    
            var nameParameter = name != null ?
                new ObjectParameter("name", name) :
                new ObjectParameter("name", typeof(string));
    
            var phoneNumberParameter = phoneNumber != null ?
                new ObjectParameter("phoneNumber", phoneNumber) :
                new ObjectParameter("phoneNumber", typeof(string));
    
            var roleIDParameter = roleID.HasValue ?
                new ObjectParameter("roleID", roleID) :
                new ObjectParameter("roleID", typeof(int));
    
            var isActiveParameter = isActive.HasValue ?
                new ObjectParameter("isActive", isActive) :
                new ObjectParameter("isActive", typeof(bool));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("SavePublisher", idParameter, emailParameter, nameParameter, phoneNumberParameter, roleIDParameter, isActiveParameter);
        }
    
        public virtual ObjectResult<GetUnreturnedMap_Result> GetUnreturnedMap(Nullable<int> publisherId)
        {
            var publisherIdParameter = publisherId.HasValue ?
                new ObjectParameter("publisherId", publisherId) :
                new ObjectParameter("publisherId", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<GetUnreturnedMap_Result>("GetUnreturnedMap", publisherIdParameter);
        }
    }
}
