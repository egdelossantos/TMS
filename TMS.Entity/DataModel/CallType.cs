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
    
    public partial class CallType
    {
        public CallType()
        {
            this.CallActivityWarnings = new HashSet<CallActivityWarning>();
            this.CallActivities = new HashSet<CallActivity>();
        }
    
        public int Id { get; set; }
        public string CallTypeName { get; set; }
    
        public virtual ICollection<CallActivityWarning> CallActivityWarnings { get; set; }
        public virtual ICollection<CallActivity> CallActivities { get; set; }
    }
}
