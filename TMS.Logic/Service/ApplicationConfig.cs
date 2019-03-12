using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TMS.Logic.Service
{
    public static class ApplicationConfig
    {
        public static string ApplicationEnvironment
        {
            get
            {
                return ConfigurationManager.AppSettings["ApplicationEnvironment"];
            }
        }
    }
}
