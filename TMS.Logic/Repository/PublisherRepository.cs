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

        public Publisher GetPublisherByEmail(string email)
        {
            var publisher = Context.Publishers.FirstOrDefault(w => w.EmailAddress.ToLower().Trim() == email.ToLower().Trim());
            return publisher;
        }

        public IList<webpages_Roles> GetUserRoles()
        {
            var roles = Context.webpages_Roles.Where(w => w.RoleId != 1).ToList();
            return roles;
        }

        public int SavePublisher(int id, string emailaddress, string name, string phoneNumber, int roleId, bool isActive)
        {
            using (TerritoryEntities context = new TerritoryEntities())
            {
                var result = context.SavePublisher(id, emailaddress, name, phoneNumber, roleId, isActive);
                return result;
            }
        }
    }
}
