using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TMS.Entity.Enum
{
    public static class ActivityStatusEnum
    {
        public enum Status
        {
            Done = 1,
            NotAtHome1 = 2,
            NotAtHome2 = 3,
            AddressNotFound = 4,
            NotFilipino = 5
        }
    }
}
