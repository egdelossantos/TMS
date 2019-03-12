using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Web.Mvc;
using System.Web.Routing;

namespace TMS.Web.Helpers
{
    public static class WebHelper
    {
        public static RouteValueDictionary CreateDictionaryForArray<T>(string key, IList<T> values)
        {
            var routeValues = new RouteValueDictionary();
            if (values != null)
            {
                for (int i = 0; i < values.Count(); i++)
                {
                    routeValues.Add(string.Format("{0}[{1}]", key, i), values[i]);
                }
            }

            return routeValues;
        }

        public static string FormatInvalidTimesheetMessage(string message)
        {
            return string.Format("{0}{1}", Environment.NewLine, message);
        }

        public static string FormatWarningTimesheetMessage(string message)
        {
            return string.Format("{0}{1}", Environment.NewLine, message);
        }

        public static IDictionary<string, object> ControlToReadOnly(bool readOnly, object obj = null)
        {
            IDictionary<string, object> result = new Dictionary<string, object>();
            StripObjectAttributes(result, obj);

            if (readOnly)
            {
                ApplyAttributeValue(result, "readonly", "readonly", overwriteExistingValue: true);
                ApplyAttributeValue(result, "class", "noTextEntry", overwriteExistingValue: false);
            }

            return result;
        }

        private static void ApplyAttributeValue(IDictionary<string, object> attributeBag, string attributeName, object value, bool overwriteExistingValue)
        {
            if (!attributeBag.ContainsKey(attributeName))
            {
                attributeBag.Add(attributeName, value);
                return;
            }

            ////there is already a value
            var existingValue = attributeBag[attributeName];
            if (overwriteExistingValue)
            {
                attributeBag[attributeName] = value;
            }
            else
            {
                attributeBag[attributeName] = existingValue + " " + value;
            }
        }

        private static void StripObjectAttributes(IDictionary<string, object> attributeBag, object obj)
        {
            if (obj == null)
            {
                return;
            }

            foreach (PropertyDescriptor property in TypeDescriptor.GetProperties(obj))
            {
                var value = property.GetValue(obj);
                ApplyAttributeValue(attributeBag, property.Name, value, overwriteExistingValue: true);
            }
        }
    }
}