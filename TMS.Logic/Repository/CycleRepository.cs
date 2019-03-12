using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TMS.Common;
using TMS.Entity.DataModel;

namespace TMS.Logic.Repository
{
    public class CycleRepository : BaseRepository<Cycle>
    {
        public CycleRepository(TerritoryEntities territoryEntityContext)
            : base(territoryEntityContext)
        {
        }

        public Cycle GetLatestCycle()
        {
            var cycles = GetAll();
            if (cycles.Any())
            {
                return cycles.OrderByDescending(o => o.CycleNumber).First();
            }

            // if no record, create one
            var cycle = new Cycle
            {
                Id = 0,
                CycleNumber = 1,
                StartDate = TimeConverter.ConvertToLocalTime(DateTime.Now)
            };

            SaveOrUpdate(cycle);

            return cycle;
        }
    }
}
