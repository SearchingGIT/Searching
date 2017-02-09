using Newtonsoft.Json;
using Searching.Solution.Web.App_Start;
using Searching.Solution.Web.Logic.Transport;
using Searching.Shared.API.DataModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;

namespace Searching.Solution.Web.Controllers
{
    public class HomeController : Controller
    {   
        //GET: Home
        [HttpGet]
        [AllowCrossSiteJson]
        public ActionResult StartPage()
        {
           return View();
        }

        public ActionResult Footer()
        {
            return View();
        }
    }
}