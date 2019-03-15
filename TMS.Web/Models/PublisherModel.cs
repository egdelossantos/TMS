using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using TMS.Entity.DataModel;

namespace TerritoryManagementSystem.Models
{
    public class PublisherModel
    {
        public Publisher Publisher { get; set; }

        public int RoleId { get; set; }

        public bool IsActive { get; set; }

        public IList<webpages_Roles> UserRoles { get; set; }

        public bool IsEditMode
        {
            get
            {
                return Publisher != null && Publisher.Id > 0;
            }
        }
    }
}