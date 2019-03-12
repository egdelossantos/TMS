using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TMS.Entity.DataModel.Interfaces;

namespace TMS.Entity.DataModel
{
    public partial class CallActivityAddress : IEntity
    {
        public bool Destroy { get; set;}

        public string Address { get; set; }
    }
}
