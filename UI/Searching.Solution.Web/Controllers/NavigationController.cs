using Searching.Solution.Web.Logic.Transport;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;

namespace Searching.Solution.Web.Controllers
{
    public class NavigationController : Controller
    {
        public ActionResult Search()
        {

            return View();
        }

        public ActionResult Profile()
        {
            return View();
        }

        public ActionResult Messages()
        {
            return View();
        }

        public ActionResult Header()
        {
            return View();
        }

        public ActionResult Footer()
        {
            return View();
        }

    }
}