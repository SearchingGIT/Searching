using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.ServiceModel;
using System.ServiceModel.Description;
using System.Text;
using System.Threading.Tasks;

namespace Searching.BE.Service
{
    class Program
    {
        static void Main(string[] args)
        {
            // Step 1 Create a URI to serve as the base address.
            string baseAddress = "http://" + Environment.MachineName + ":8000/Service";
            ServiceHost host = new ServiceHost(typeof(WCFRESTService), new Uri(baseAddress));
            WebHttpBinding binding = new WebHttpBinding { CrossDomainScriptAccessEnabled = true };
            WebHttpBehavior behavior = new WebHttpBehavior();
            host.AddServiceEndpoint(typeof(IWCFRESTService), binding, "").Behaviors.Add(behavior);
            host.Open();
            Console.WriteLine("Host opened");

            HttpWebRequest req = (HttpWebRequest)HttpWebRequest.Create(baseAddress + "/TestFunction");
            req.Method = "POST";
            req.GetRequestStream().Close();
            HttpWebResponse resp = (HttpWebResponse)req.GetResponse();
            Console.WriteLine("HTTP/{0} {1} {2}", resp.ProtocolVersion, (int)resp.StatusCode, resp.StatusDescription);
            foreach (var header in resp.Headers.AllKeys)
            {
                Console.WriteLine("{0}: {1}", header, resp.Headers[header]);
            }
            if (resp.ContentLength > 0)
            {
                Console.WriteLine(new StreamReader(resp.GetResponseStream()).ReadToEnd());
            }

            Console.Write("Press ENTER to close the host");
            Console.ReadLine();
            host.Close();
        }
    }
}
