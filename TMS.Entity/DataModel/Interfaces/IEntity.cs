using System;

namespace TMS.Entity.DataModel.Interfaces
{
    public interface IEntity
    {
        bool Destroy { get; set; }
        int Id { get; set; }
    }
}