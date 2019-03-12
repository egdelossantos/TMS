using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Web.WebPages.OAuth;
using TerritoryManagementSystem.Models;
using WebMatrix.WebData;

namespace TerritoryManagementSystem
{
    public static class AuthConfig
    {
        public static void RegisterAuth()
        {
            WebSecurity.InitializeDatabaseConnection("MembershipConnection", "Publisher", "Id", "EmailAddress", autoCreateTables: false);
        }
    }
}
