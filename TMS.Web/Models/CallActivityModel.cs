using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using TMS.Entity.DataModel;

namespace TerritoryManagementSystem.Models
{
    public class CallActivityModel
    {
        public string ErrorMessage { get; set; }

        public IList<Publisher> Publishers { get; set; }
        
        public IList<CallGroup> AvailableMaps { get; set; }

        public IList<CallType> CallTypes { get; set; }

        public CallActivity CallActivity { get; set; }

        public Cycle CurrentCycle { get; set; }

        public IList<CallActivityAddress> CallActivityAddresses { get; set; }

        public IList<CallActivityStatu> Status { get; set; }

        public List<SelectListItem> StatusSelectList
        {
            get 
            { 
                var list = Status.Select(a => new SelectListItem { Text = a.Status, Value = a.Id.ToString() }).ToList();

                list.Insert(0, new SelectListItem { Text = " - ", Value = "" });

                return list;
            }
        }

        public IEnumerable<SelectListItem> AvailableMapsSelectList
        {
            get { return AvailableMaps.Select(a => new SelectListItem { Text = a.CallGroupDetails, Value = a.Id.ToString() }); }
        }

        public IEnumerable<SelectListItem> PublishersSelectList
        {
            get { return Publishers.Select(a => new SelectListItem { Text = a.Name, Value = a.Id.ToString() }); }
        }

        public IEnumerable<SelectListItem> CallTypessSelectList
        {
            get { return CallTypes.Select(a => new SelectListItem { Text = a.CallTypeName, Value = a.Id.ToString() }); }
        }

        public bool IsEditMode 
        {   
            get {
                return CallActivity != null && CallActivity.Id > 0;
            } 
        }
    }
}