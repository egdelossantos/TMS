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
    
    public partial class webpages_PasswordResets
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public string ResetQuestion { get; set; }
        public string ResetAnswer { get; set; }
    
        public virtual webpages_Membership webpages_Membership { get; set; }
    }
}
