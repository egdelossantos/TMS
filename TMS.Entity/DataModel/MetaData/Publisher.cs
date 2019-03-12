using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TMS.Entity.DataModel.Interfaces;
using TMS.Entity.Enum;

namespace TMS.Entity.DataModel
{
    public partial class Publisher : IEntity
    {
        public bool Destroy { get; set;}

        public bool IsAdmin
        {
            get
            {
                if (webpages_Membership != null && webpages_Membership.webpages_Roles.FirstOrDefault(w => w.RoleName.ToLower() == PublisherEnum.UserRole.Admin.ToString().ToLower()) != null)
                {
                    return true;
                }               

                return false;
            }
        }

        public bool IsTerritoryOverseer { 
            get {
                if (IsAdmin || (webpages_Membership != null && webpages_Membership.webpages_Roles.FirstOrDefault(w => w.RoleName.ToLower() == PublisherEnum.UserRole.TerritoryOverseer.ToString().ToLower()) != null))
                {
                    return true;
                }

                return false; 
            } 
        }

        public bool IsElder
        {
            get
            {
                if (IsAdmin || IsTerritoryOverseer || (webpages_Membership != null && webpages_Membership.webpages_Roles.FirstOrDefault(w => w.RoleName.ToLower() == PublisherEnum.UserRole.Elder.ToString().ToLower()) != null))
                {
                    return true;
                }

                return false;
            }
        }

        public bool IsAssistantBrother
        {
            get
            {
                if (webpages_Membership != null && webpages_Membership.webpages_Roles.FirstOrDefault(w => w.RoleName.ToLower() == PublisherEnum.UserRole.AssistantBrother.ToString().ToLower()) != null)
                {
                    return true;
                }

                return false;
            }
        }   
    }
}
