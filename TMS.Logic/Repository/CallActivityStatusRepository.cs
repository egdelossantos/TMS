using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TMS.Entity.DataModel;

namespace TMS.Logic.Repository
{
    public class CallActivityStatusRepository : BaseRepository<CallActivityStatu>
    {
        public CallActivityStatusRepository(TerritoryEntities territoryEntityContext)
            : base(territoryEntityContext)
        {
        }
    }
}
