using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TMS.Entity.DataModel;

namespace TMS.Logic.Repository
{
    public class MapsToReleaseByAssistantRepository : BaseRepository<MapsToReleaseByAssistant>
    {
        public MapsToReleaseByAssistantRepository(TerritoryEntities territoryEntityContext)
            : base(territoryEntityContext)
        {
        }
    }
}
