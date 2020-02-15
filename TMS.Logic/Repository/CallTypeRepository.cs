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
