using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TMS.Entity.DataModel;

namespace TMS.Logic.Repository
{
    public class CallTypeRepository : BaseRepository<CallType>
    {
        public CallTypeRepository(TerritoryEntities territoryEntityContext)
            : base(territoryEntityContext)
        {
        }
    }
}
