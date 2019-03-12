using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TMS.Entity.Enum
{
    public static class PublisherEnum
    {
        public enum UserRole
        {
            Admin = 1,
            TerritoryOverseer = 2,
            Publisher = 3,
            Elder = 4,
            AssistantBrother = 5
        }
    }
}
