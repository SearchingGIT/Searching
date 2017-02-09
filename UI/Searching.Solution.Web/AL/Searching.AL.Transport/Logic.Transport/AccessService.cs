using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using SearchingLibrary;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;

namespace Searching.AL.Transport.Logic.Transport
{
   public static class AccessService
    {
        public static async Task<string> ServiceCalled(string MethodRequestType, string MethodName, string BodyParam = "")
        {
            string ServiceURI = GetServiceHost()+MethodName;
            HttpClient client = new HttpClient();
           // client.DefaultRequestHeaders.Accept.Add(new System.Net.Http.Headers.MediaTypeWithQualityHeaderValue("application/json"));
            HttpRequestMessage request = new HttpRequestMessage(MethodRequestType == "GET" ? HttpMethod.Get : HttpMethod.Post, ServiceURI);
            if (!string.IsNullOrEmpty(BodyParam))
            {
                request.Content = new StringContent(BodyParam, Encoding.UTF8, "application/json");
            }
            HttpResponseMessage response = new HttpResponseMessage();
            try { 
             response = await client.SendAsync(request);
            }
            catch(Exception ex)
            {
                throw ex;
            }
            string returnValue = await response.Content.ReadAsStringAsync();
            return returnValue;
        }
        public static async Task<string> ServiceCalledWithJson( string MethodName, object customObject)
        {
            try
            { 
            string ServiceURI = GetServiceHost() + MethodName;                                 
            var httpClient = new HttpClient();
            var result = JsonConvert.SerializeObject(new { filter = customObject });
            var request = new StringContent(result, Encoding.UTF8, "application/json");
            var response = await httpClient.PostAsync(ServiceURI, request);
            string content = await response.Content.ReadAsStringAsync();
            return content;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        private static string GetServiceHost()
        {
            return "http://192.168.200.100:1703/Searching.BE.Service//WCFRESTService.svc/";
        }
    }
}
