using System.Collections.Generic;
using System.Linq;
using TMS.Entity.DataModel;

namespace TMS.Web.JsonDtoConverters
{
    public static class PublisherConverter
    {
        public static IEnumerable<object> PublishersToJsonSummary(IEnumerable<Publisher> publishers)
        {
            return publishers.Select(PublisherToJsonSummary);
        }

        public static object PublisherToJsonSummary(Publisher publisher)
        {
            return new
                {
                    id = publisher.Id,
                    name = publisher.Name,
                    emailaddress = publisher.EmailAddress,
                    phonenumber = publisher.PhoneNumber,
                    isActive = publisher.IsActive,
                    roleId = publisher.UserRoleId ?? 0,
                    roleName = publisher.webpages_Roles == null ? string.Empty : publisher.webpages_Roles.RoleName ?? string.Empty
                };
        }
    }
}