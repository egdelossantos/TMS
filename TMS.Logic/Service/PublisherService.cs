using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TMS.Entity.DataModel;
using TMS.Entity.Enum;
using TMS.Logic.Repository;

namespace TMS.Logic.Service
{
    public class ValidationResult
    {
        public string FieldName { get; set; }

        public string ErrorMessage { get; set; }
    }

    public class PublisherService
    {
        private readonly PublisherRepository publisherRepository;

        public PublisherService(PublisherRepository publisherRepository)
        {
            this.publisherRepository = publisherRepository;
        }

        public Publisher GetPublisherById(int id)
        {
            var publisher = publisherRepository.GetById(id);

            return publisher;
        }

        public Publisher GetPublisherByEmail(string email)
        {
            var publisher = publisherRepository.GetPublisherByEmail(email);

            return publisher;
        }

        public IList<webpages_Roles> GetUserRoles()
        {
            var userRoles = publisherRepository.GetUserRoles();

            return userRoles.ToList();
        }

        // activeOnly = true will show only active publishers 
        // activeOny = false will show all publishers regardless of status
        public IList<Publisher> GetPublishers(bool activeOnly = true)
        {
            IList<Publisher> publishersList;
            var publishers = publisherRepository.GetAll();
            if (activeOnly)
            {
                publishersList = publishers.Where(w => w.IsActive == true).OrderBy(o => o.Name).ToList();
            }
            else
            {
                publishersList = publishers.OrderBy(o => o.Name).ToList();
            }

            return publishersList;
        }

        public List<ValidationResult> ValidatePublisher(Publisher publisher)
        {
            var result = new List<ValidationResult>();

            if (string.IsNullOrEmpty(publisher.Name))
                result.Add(new ValidationResult { FieldName = "Name", ErrorMessage = "Name is required." });

            if (string.IsNullOrEmpty(publisher.EmailAddress))
                result.Add(new ValidationResult { FieldName = "EmailAddress", ErrorMessage = "Email Address is required." });
            
            var emailPublisher = publisherRepository.GetPublisherByEmail(publisher.EmailAddress);
            if (emailPublisher != null && publisher.Id != emailPublisher.Id)
                result.Add(new ValidationResult { FieldName = "EmailAddress", ErrorMessage = "Email Address is owned by someone else." });
            
            return result;
        }
         
        public Publisher SavePublisher(Publisher publisher)
        {
            var publisherId = publisherRepository.SavePublisher(publisher.Id, publisher.EmailAddress, publisher.Name, publisher.PhoneNumber, publisher.UserRoleId ?? 3);
            var dbPublisher = GetPublisherById(publisherId);           

            return dbPublisher;
        }
    }
}
