using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TMS.Entity.DataModel;

namespace TMS.Logic.Repository
{
    public class CallActivityRepository : BaseRepository<CallActivity>
    {
        public CallActivityRepository(TerritoryEntities territoryEntityContext)
            : base(territoryEntityContext)
        {
        }

        public IList<GetUnReturnedCallAddress_Result> GetUnReturnedCallAddresses(int publisherId)
        {
            using (TerritoryEntities context = new TerritoryEntities())
            {
                var result = context.GetUnReturnedCallAddress(publisherId);
                return result.ToList();
            }
        }

        public IList<GetUnreturnedMap_Result> GetUnReturnedMaps(int publisherId)
        {
            using (TerritoryEntities context = new TerritoryEntities())
            {
                var result = context.GetUnreturnedMap(publisherId);
                return result.ToList();
            }
        }

        public IList<GetMapActivity_Result> GetMapActivityReport(DateTime dateFrom, DateTime dateTo)
        {
            using (TerritoryEntities context = new TerritoryEntities())
            {
                var result = context.GetMapActivity(dateFrom, dateTo);
                return result.ToList();
            }            
        }

        public IList<GetMapActivitySummary_Result> GetMapActivitySummary(DateTime dateFrom, DateTime dateTo)
        {
            using (TerritoryEntities context = new TerritoryEntities())
            {
                var result = context.GetMapActivitySummary(dateFrom, dateTo);
                return result.ToList();
            }
        }

        public IList<GetMapActivityDetail_Result> GetMapActivityDetail(DateTime dateFrom, DateTime dateTo)
        {
            using (TerritoryEntities context = new TerritoryEntities())
            {
                var result = context.GetMapActivityDetail(dateFrom, dateTo);
                return result.ToList();
            }
        }  
    }
}
