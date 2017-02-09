using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Searching.UI.Web.Controllers
{
    public class HomeController : Controller
    {
        // GET: Home
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