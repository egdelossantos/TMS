using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TMS.Entity.DataModel;

namespace TMS.Logic.Repository
{
    public class StateRepository : BaseRepository<State>
    {
        public StateRepository(TerritoryEntities territoryEntityContext)
            : base(territoryEntityContext)
        {
        }

        public State GetStateByName(string stateName)
        {
            return GetAll().Where(w => w.StateName.Contains(stateName)).FirstOrDefault();            
        }
    }
}
