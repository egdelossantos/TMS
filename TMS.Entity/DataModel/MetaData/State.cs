using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TMS.Entity.DataModel.Interfaces;

namespace TMS.Entity.DataModel
{
    public partial class State : IEntity
    {
        public bool Destroy { get; set;}
    }
}
