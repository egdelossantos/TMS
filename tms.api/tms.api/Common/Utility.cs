using Google.Maps;
using System;
using System.Collections.Generic;
using System.Configuration;

namespace tms.api.Common
{
    public static class Utility
    {
        public static string GoogleMapApiKey()
        {
            string mapKey = ConfigurationManager.AppSettings["MapKey"];
            string apiKey = StringCipher.Decrypt(mapKey, Config.CongregationCode);

            return apiKey;
        }

        public static int GetValueFromResponse(ValueText valueText)
        {
            var strValue = valueText.ToString();
            var openBracket = strValue.IndexOf('(');
            var closeBracket = strValue.IndexOf(')');
            strValue = strValue.Substring(openBracket + 1, (closeBracket - openBracket) - 1);
            return int.Parse(strValue);
        }

        public static IEnumerable<List<T>> SplitList<T>(List<T> list, int nSize = 10)
        {
            for (int i = 0; i < list.Count; i += nSize)
            {
                yield return list.GetRange(i, Math.Min(nSize, list.Count - i));
            }
        }
    }
}