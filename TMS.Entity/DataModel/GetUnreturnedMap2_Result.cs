//------------------------------------------------------------------------------
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
    
    public partial class GetUnreturnedMap2_Result
    {
        public int Id { get; set; }
        public int CallTypeId { get; set; }
        public string CallTypeName { get; set; }
        public int CallGroupId { get; set; }
        public string CallGroupName { get; set; }
        public System.DateTime DateReleased { get; set; }
        public int ReleasedToPublisherId { get; set; }
        public string PublisherName { get; set; }
        public string EmailAddress { get; set; }
        public int ReleasedByUserId { get; set; }
        public string ReleasedBy { get; set; }
        public int CycleId { get; set; }
        public int CycleNumber { get; set; }
        public string CycleName { get; set; }
        public int IsComplete { get; set; }
        public int DaysOut { get; set; }
        public int WarningSeverity { get; set; }
        public string WarningColour { get; set; }
    }
}
