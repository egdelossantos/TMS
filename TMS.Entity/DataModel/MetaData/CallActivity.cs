using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TMS.Common;
using TMS.Entity.DataModel.Interfaces;

namespace TMS.Entity.DataModel
{
    [MetadataType(typeof(CallActivityMetadata))]
    public partial class CallActivity : IEntity, IValidatableObject
    {
        public bool Destroy { get; set;}

        public int DaysOut { get; set; }

        public bool AllAddressVisited { get; set; }

        public int WarningSeverity { get; set; }

        public string WarningColour { get; set; }

        public string DateReleasedText {
            get
            {
                return DateReleased.ToString("yyyy-MM-dd");
            }
        }

        public string TempDateReleased { get; set; }

        public string ContentHtml { get; set; }

        public IList<PlotAddressInMapModel> AddressesInMap { get; set; }
        
        public IEnumerable<ValidationResult> Validate(ValidationContext validationContext)
        {
            var validationErrors = new List<ValidationResult>();

            bool callTypeSpecified = CallTypeId > 0;
            bool mapSpecified = CallGroupId > 0;
            bool publisherSpecified = ReleasedToPublisherId > 0;
            bool dateReleasedSpecified = DateReleased > new DateTime(1, 1, 001);
          
            if (!callTypeSpecified)
            {
                validationErrors.Add(new ValidationResult("Call Type is required.", new[] { "CallTypeId" }));
            }

            if (!mapSpecified)
            {
                validationErrors.Add(new ValidationResult("Map is required.", new[] { "CallGroupId" }));
            }

            if (!publisherSpecified)
            {
                validationErrors.Add(new ValidationResult("Publisher is required.", new[] { "ReleasedToPublisherId" }));
            }

            if (DateReleased.Date > TimeConverter.ConvertToLocalTime(DateTime.Now).Date)
            {
                validationErrors.Add(new ValidationResult("Date DateReleased is later than current date.", new[] { "DateReleased" }));
            }

            if (DateReturned != null && Convert.ToDateTime(DateReturned).Date > TimeConverter.ConvertToLocalTime(DateTime.Now).Date)
            {
                validationErrors.Add(new ValidationResult("Date Completed is later than current date.", new[] { "DateReturned" }));
            }

            if (DateReleased != null && DateReturned != null)
            {
                if (DateReleased.Date > Convert.ToDateTime(DateReturned).Date)
                {
                    validationErrors.Add(new ValidationResult("Date Released is later than Date Completed.", new[] { "DateReturned" }));
                }
            }

            return validationErrors;
        }
    }

    public class CallActivityMetadata
    {
        [Required(ErrorMessage="Date Released is required.")]
        public System.DateTime DateReleased { get; set; }       
    }
}
