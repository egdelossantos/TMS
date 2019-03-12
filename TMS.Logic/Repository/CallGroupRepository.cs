using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TMS.Entity.DataModel;

namespace TMS.Logic.Repository
{
    public class CallGroupRepository : BaseRepository<CallGroup>
    {
        public CallGroupRepository(TerritoryEntities territoryEntityContext)
            : base(territoryEntityContext)
        {
        }

        public IList<CallAddress> GetAddressInCallGroup(int callGroupId, bool activeOnly = true)
        {
            var callGroup = GetById(callGroupId);
            if (callGroup == null)
            {
                return new List<CallAddress>();
            }

            var callAddress = callGroup.CallAddresses;
            if (activeOnly)
            {
                return callAddress.Where(w => w.IsValid).Select(s => new CallAddress
                {
                    Id = s.Id,
                    Unit = s.Unit,
                    Number = s.Number,
                    Street = s.Street,
                    Suburb = s.Suburb,
                    SuburbId = s.SuburbId,
                    MelwayRefNo = s.MelwayRefNo,
                    CallGroup = s.CallGroup,
                    CallGroupId = s.CallGroupId,
                    RouteOrderFromKh = s.RouteOrderFromKh,
                    IsValid = s.IsValid,
                    CallActivityAddresses = s.CallActivityAddresses,
                    CallAddressNotes = s.CallAddressNotes
                }).ToList();
            }

            return callAddress.ToList();
        }
    }
}
