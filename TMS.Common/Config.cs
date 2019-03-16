using System.Configuration;

namespace TMS.Common
{
    public static class Config
    {
        public static string CongregrationName {
            get
            {
                return ConfigurationManager.AppSettings["CongregationName"];
            }
        }

        public static string KingdomHallAddress
        {
            get
            {
                return ConfigurationManager.AppSettings["KingdomHallAddress"];
            }
        }

        public static decimal KingdomHallLongtitude
        {
            get
            {
                string khLongtitude = ConfigurationManager.AppSettings["KingdomHallLongtitude"];

                return decimal.Parse(khLongtitude);
            }
        }

        public static decimal KingdomHallLatitude
        {
            get
            {
                string khLatitude = ConfigurationManager.AppSettings["KingdomHallLatitude"];

                return decimal.Parse(khLatitude);
            }
        }

        public static string CongregationCode
        {
            get
            {
                return ConfigurationManager.AppSettings["CongregationCode"];
            }
        }

        public static int NumberOfAddressInBatch
        {
            get
            {
                string numAdd = ConfigurationManager.AppSettings["NumberOfAddressInBatch"];

                return int.Parse(numAdd);
            }
        }
    }
}