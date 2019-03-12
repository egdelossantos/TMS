using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TMS.Entity.DataModel;

namespace TMS.Logic.Repository
{
    public class CallAddressRepository : BaseRepository<CallAddress>
    {
        public CallAddressRepository(TerritoryEntities territoryEntityContext)
            : base(territoryEntityContext)
        {            
        }

        public void DeactivateCallAddresses(int callAddressId, DateTime approvedDate, int approvedBy)
        {
            using (TerritoryEntities context = new TerritoryEntities())
            {
                var result = context.DeactivateCallAddress(callAddressId, approvedDate, approvedBy);               
            }
        }
    }
}
