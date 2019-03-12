using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TMS.Common
{
    public static class TimeConverter
    {
        public const string AusEasternTime = "AUS Eastern Standard Time";

        public static DateTime ConvertToLocalTime(DateTime dateTime, string timeZone = null)
        {
            if (string.IsNullOrEmpty(timeZone)){
                timeZone = AusEasternTime;
            }

            TimeZoneInfo timeZoneInfo = TimeZoneInfo.FindSystemTimeZoneById(timeZone);
            var utcTime = DateTime.UtcNow;
            var localTime = TimeZoneInfo.ConvertTimeFromUtc(utcTime, timeZoneInfo);

            return localTime;
        }
    }
}
