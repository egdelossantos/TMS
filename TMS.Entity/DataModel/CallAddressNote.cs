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
    
    public partial class CallAddressNote
    {
        public int Id { get; set; }
        public int CallAddressId { get; set; }
        public string Note { get; set; }
        public System.DateTime DateNoteAdded { get; set; }
    
        public virtual CallAddress CallAddress { get; set; }
    }
}
