using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TMS.Entity.DataModel;

namespace TMS.Logic.Repository
{
    public class PublisherRepository : BaseRepository<Publisher>
    {
        public PublisherRepository(TerritoryEntities territoryEntityContext)
            : base(territoryEntityContext)
        {
        }

        //public Publisher GetPublisherByUserName(string userName)
        //{
        //    var publisher = Context.Publishers.FirstOrDefault(w => w.UserName.ToLower().Trim() == userName.ToLower().Trim());
        //    return publisher;
        //}

        public Publisher GetPublisherByEmail(string email)
        {
            var publisher = Context.Publishers.FirstOrDefault(w => w.EmailAddress.ToLower().Trim() == email.ToLower().Trim());
            return publisher;
        }
    }
}
