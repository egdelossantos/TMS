using Nancy;
using Nancy.ModelBinding;
using Nancy.Responses;
using Newtonsoft.Json;
using System.Net.Http;
using System.Net.Http.Headers;
using tms.api.Common;
using tms.api.Model;

namespace tms.api.Map
{
    public class Module : NancyModule
    {
        public Module()
        {
            Get["/map"] = arguments => Hello();

            Get["/map/{name}"] = arguments => HelloName(arguments.name);

            Get["/map/{name1}/{name2}"] = arguments => HelloName(arguments.name1, arguments.name2);

            Post["/map/route"] = _ =>
            {
                var model = this.Bind<MapRouteAddress>();
                var bestRoute = MapService.GetBestRoute(model);
               
                return new JsonResponse(bestRoute, new DefaultJsonSerializer());
            };
        }

        private string HelloName(string name)
        {
            return string.Format("hello {0}", name);
        }

        private string HelloName(string name1, string name2)
        {
            return string.Format("hello {0} - {1}", name1, name2);
        }

        private string Hello()
        {
            var sss = Utility.GoogleMapApiKey();
            return "hello";
        }
    }
}