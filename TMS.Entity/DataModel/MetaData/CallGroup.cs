using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TMS.Entity.DataModel.Interfaces;

namespace TMS.Entity.DataModel
{
    public partial class CallGroup : IEntity
    {
        public bool Destroy { get; set;}

        public DateTime? LastCallDate
        {
            get
            {
                DateTime? lastCallDate = null;

                if (LastAssignCallActivityId != null && CallActivity1.DateReturned != null)
                {
                    lastCallDate = CallActivity1.DateReturned;
                }

                return lastCallDate;
            }
        }

        public string GroupNameWithCount
        {
            get
            {
                var name = CallGroupName;

                if (Id > 0)
                {
                    var count = (CallAddresses != null && CallAddresses.Count > 0
                                    ? string.Format(" [{0}]", CallAddresses.Count) : string.Empty);

                    name = string.Format("{0} - {1}{2}", CallGroupName, GroupCode, count);
                }
                
                return name;               
            }
        }

        public string CallGroupDetails
        {
            get
            {
                var name = GroupNameWithCount;

                if (LastCallDate != null)
                {
                    var lastCallDate = Convert.ToDateTime(LastCallDate).ToString("yyyy-MM-dd");
                    name = string.Format("{0} ({1})", name, lastCallDate);
                }

                return name;
            }
        }        
    }
}
