using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TMS.Entity.DataModel;

namespace TMS.Logic.Repository
{
    public class CallActivityAddressRepository : BaseRepository<CallActivityAddress>
    {
        public CallActivityAddressRepository(TerritoryEntities territoryEntityContext)
            : base(territoryEntityContext)
        {
        }

        public IList<CallActivityAddress> GetCallActivityAddresses(int callActivityId)
        {
            return GetAll().Where(w => w.CallActivityId == callActivityId).ToList();
        }

        public void DeleteCallActivityAddress(IEnumerable<int> ids)
        {
            var addresses = GetByIds(ids);
            foreach (var address in addresses)
            {
                address.Destroy = true;
            }

            SaveOrUpdate(addresses);
        }
    }
}
