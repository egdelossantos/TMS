using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity.Infrastructure;
using System.Data.Entity.Validation;
using System.Linq;
using TMS.Entity.DataModel;
using TMS.Entity.DataModel.Interfaces;

namespace TMS.Logic.Repository
{
    public abstract class BaseRepository<T> where T : class, IEntity
    {
        private readonly TerritoryEntities territoryEntityContext;

        protected BaseRepository(TerritoryEntities territoryEntityContext)
        {
            this.territoryEntityContext = territoryEntityContext;
        }

        protected TerritoryEntities Context
        {
            get { return territoryEntityContext; }
        }

        private System.Data.Entity.Core.Objects.ObjectContext ObjectContext
        {
            get
            {
                var adapter = (IObjectContextAdapter)Context;
                return adapter.ObjectContext;
            }
        }

        public virtual T GetById(int id)
        {
            return id == default(int) ? null : Context.Set<T>().Find(id);
        }

        public IQueryable<T> GetAll()
        {
            return Context.Set<T>();
        }

        public IQueryable<T> GetByIds(IEnumerable<int?> ids)
        {
            IEnumerable<int> nonNullIds = ids.Where(id => id.HasValue).Select(id => id.Value);
            return GetByIds(nonNullIds);
        }

        public IQueryable<T> GetByIds(IEnumerable<int> ids)
        {
            return Context.Set<T>().Where(e => ids.Contains(e.Id));
        }

        public virtual void SaveOrUpdate(T entity, bool deferSave = false)
        {
            if (entity.Destroy)
            {
                Context.Set<T>().Remove(entity);
            }
            else if (IsNewEntity(entity))
            {
                Context.Set<T>().Add(entity);
            }
            else if (Context.Entry(entity) == null)
            {
                Context.Set<T>().Attach(entity);
                Context.Entry(entity).State = System.Data.Entity.EntityState.Modified;
            }

            if (!deferSave)
            {
                Context.SaveChanges();

                if (!entity.Destroy && Context.Entry(entity) != null && Context.Entry(entity).State != System.Data.Entity.EntityState.Unchanged)
                {
                    ObjectContext.Refresh(System.Data.Entity.Core.Objects.RefreshMode.StoreWins, entity);    
                }                
            }
        }

        public void SaveOrUpdate(IEnumerable<T> entities)
        {
            foreach (var entity in entities)
            {
                SaveOrUpdate(entity, deferSave: true);
            }

            Context.SaveChanges();
        }       

        protected bool IsNewEntity(T entity)
        {
            return entity != null && entity.Id == default(int);
        }

        protected void EvictOtherWhere<U>(Func<U, bool> whereClause) where U : class
        {
            foreach (var entry in Context.ChangeTracker.Entries<U>().Where(t => whereClause(t.Entity)))
            {
                ObjectContext.Detach(entry.Entity);
            }
        }

        protected void EvictWhere(Func<T, bool> whereClause)
        {
            EvictOtherWhere(whereClause);
        }
    }
}