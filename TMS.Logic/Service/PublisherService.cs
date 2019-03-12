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
    }
}
