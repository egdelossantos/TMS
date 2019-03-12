using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Html;

namespace TMS.Web.Helpers
{
    public static class HtmlHelperExtensions
    {
        public static MvcHtmlString ValidationMessagesFor<TModel, TProperty>(this HtmlHelper<TModel> htmlHelper, Expression<Func<TModel, TProperty>> expression, object htmlAttributes = null)
        {
            var propertyName = ModelMetadata.FromLambdaExpression(expression, htmlHelper.ViewData).PropertyName;
            var modelState = htmlHelper.ViewData.ModelState;

            if (modelState.ContainsKey(propertyName) && modelState[propertyName].Errors.Count > 1)
            {
                var msgs = new List<MvcHtmlString>();
                foreach (ModelError error in modelState[propertyName].Errors)
                {
                    msgs.Add(htmlHelper.ValidationMessageFor(expression, error.ErrorMessage, htmlAttributes as IDictionary<string, object> ?? htmlAttributes));
                }

                // Return standard ValidationMessageFor, overriding the message with our concatenated list of messages.
                return new MvcHtmlString(string.Join(Environment.NewLine, msgs));
            }

            // Revert to default behaviour.
            return htmlHelper.ValidationMessageFor(expression, null, htmlAttributes as IDictionary<string, object> ?? htmlAttributes);
        }

        public static MvcHtmlString ArrayToJsArray<TModel, T>(this HtmlHelper<TModel> htmlHelper, IEnumerable<T> array, params Expression<Func<T, object>>[] properties)
        {
            var arrayBuilder = new StringBuilder("[");
            foreach (T t in array)
            {
                arrayBuilder.Append("{");
                foreach (var property in properties)
                {
                    arrayBuilder.AppendFormat("{0}:'{1}',", GetMemberName(property).Replace(".", "_"), property.Compile().Invoke(t));
                }

                arrayBuilder.Append("}," + Environment.NewLine);
            }

            arrayBuilder.Append("]");

            return new MvcHtmlString(arrayBuilder.ToString());
        }

        public static MvcHtmlString ArrayToJsArray<TModel, T>(this HtmlHelper<TModel> htmlHelper, Func<TModel, IEnumerable<T>> expression)
        {
            var arrayBuilder = new StringBuilder("[");
            foreach (T t in expression.Invoke(htmlHelper.ViewData.Model))
            {
                arrayBuilder.AppendFormat("{{{0}}}{1}", t, Environment.NewLine);

                arrayBuilder.Append("]");
            }

            return new MvcHtmlString(arrayBuilder.ToString());
        }

        public static string GetMemberName<TModel, TMember>(this HtmlHelper<TModel> htmlHelper, Expression<Func<TModel, TMember>> expression)
        {
            return GetMemberName(expression);
        }

        public static string GetMemberName<TSource, TMember>(Expression<Func<TSource, TMember>> memberReference)
        {
            string name = ExpressionHelper.GetExpressionText(memberReference);

            if (string.IsNullOrEmpty(name))
            {
                var expression = memberReference.Body as MemberExpression;

                var convertexp = memberReference.Body as UnaryExpression;
                if (convertexp != null)
                {
                    expression = convertexp.Operand as MemberExpression;
                }

                if (expression == null)
                {
                    throw new ArgumentNullException("memberReference");
                }

                return expression.Member.Name;
            }

            return name;
        }

        public static MvcHtmlString DropDownListWithLabelFor<TModel, TValue>(this HtmlHelper<TModel> html, Expression<Func<TModel, TValue>> expression, IEnumerable<SelectListItem> selectList, string labelText, bool isReadOnly = false, object htmlAttributes = null, string optionLabel = null)
        {
            MvcHtmlString labelHtml = html.LabelFor(expression, labelText, new { @class = "dropdownLabel" });
            MvcHtmlString selectHtml = html.DropDownListFor(expression, selectList, optionLabel: optionLabel, htmlAttributes: htmlAttributes);
            MvcHtmlString validationHtml = html.ValidationMessageFor(expression);

            if (isReadOnly)
            {
                Func<TModel, TValue> compiledExpression = expression.Compile();
                TValue expressionValue = compiledExpression(html.ViewData.Model);
                var listItem = selectList.FirstOrDefault(w => w.Value == expressionValue.ToString());

                selectHtml = new MvcHtmlString(string.Format("<label class='readOnly'>{0}</label>", listItem == null ? string.Empty : listItem.Text));
            }

            return new MvcHtmlString(labelHtml.ToHtmlString() + selectHtml.ToHtmlString() + validationHtml.ToHtmlString());
        }

        public static MvcHtmlString TextBoxWithLabelFor<TModel, TValue>(this HtmlHelper<TModel> html, Expression<Func<TModel, TValue>> expression, string labelText, bool shortTextbox = false)
        {
            MvcHtmlString labelHtml = html.LabelFor(expression, labelText, new { @class = "dropdownLabel" });
            MvcHtmlString textHtml = html.TextBoxFor(expression, shortTextbox ? new { @class = "short" } : null);
            MvcHtmlString validationHtml = html.ValidationMessageFor(expression);

            return new MvcHtmlString(labelHtml.ToHtmlString() + textHtml.ToHtmlString() + validationHtml.ToHtmlString());
        }

        public static SelectList TypedSelectList<TObject, TId, TValue>(IEnumerable<TObject> items, Expression<Func<TObject, TId>> idExpression, Expression<Func<TObject, TValue>> valueExpression)
        {
            return new SelectList(items, GetMemberName(idExpression), GetMemberName(valueExpression));            
        }

        public static object ExtractValueFromParameters(ActionExecutingContext filterContext, string parameterName)
        {
            object objectValue = filterContext.ActionParameters.ContainsKey(parameterName) ? filterContext.ActionParameters[parameterName] : filterContext.HttpContext.Request.Form[parameterName];

            return objectValue;
        }

        public static int? ExtractIdFromParameters(ActionExecutingContext filterContext, string parameterName)
        {
            var objectValue = ExtractValueFromParameters(filterContext, parameterName);
            return objectValue == null ? null : (int?)Convert.ToInt32(objectValue);
        }

        public static DateTime? ExtractDateFromParameters(ActionExecutingContext filterContext, string parameterName)
        {
            var objectValue = ExtractValueFromParameters(filterContext, parameterName);
            return objectValue == null ? null : (DateTime?)Convert.ToDateTime(objectValue);
        }
    }
}