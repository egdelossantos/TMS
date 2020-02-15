using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TMS.Entity.DataModel;

namespace TMS.Logic.Repository
{
    public class SuburbRepository : BaseRepository<Suburb>
    {
        public SuburbRepository(TerritoryEntities territoryEntityContext)
            : base(territoryEntityContext)
        {
        }

        public Suburb GetSuburbByName(string suburbName)
        {
            return GetAll().Where(w => w.SuburbName.Contains(suburbName)).FirstOrDefault();            
        }
    }
}
