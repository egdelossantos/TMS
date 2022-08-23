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
    using System.Collections.Generic;
    
    public partial class CallActivity
    {
        public CallActivity()
        {
            this.CallActivityAddresses = new HashSet<CallActivityAddress>();
            this.CallGroups = new HashSet<CallGroup>();
            this.CallGroups1 = new HashSet<CallGroup>();
        }
    
        public int Id { get; set; }
        public int CallGroupId { get; set; }
        public int CallTypeId { get; set; }
        public System.DateTime DateReleased { get; set; }
        public int ReleasedToPublisherId { get; set; }
        public int ReleasedByUserId { get; set; }
        public Nullable<System.DateTime> DateReturned { get; set; }
        public Nullable<int> ReturnedByPublisherId { get; set; }
        public Nullable<int> ReturnedToUserId { get; set; }
        public int CycleId { get; set; }
    
        public virtual CallType CallType { get; set; }
        public virtual Cycle Cycle { get; set; }
        public virtual ICollection<CallActivityAddress> CallActivityAddresses { get; set; }
        public virtual Publisher Publisher { get; set; }
        public virtual Publisher Publisher1 { get; set; }
        public virtual Publisher Publisher2 { get; set; }
        public virtual Publisher Publisher3 { get; set; }
        public virtual CallGroup CallGroup { get; set; }
        public virtual ICollection<CallGroup> CallGroups { get; set; }
        public virtual ICollection<CallGroup> CallGroups1 { get; set; }

        public Boolean CallActivityIsVirtual {
            get {
                return CallType == null ? false : CallType.IsVirtual;
            }
        }
    }
}
