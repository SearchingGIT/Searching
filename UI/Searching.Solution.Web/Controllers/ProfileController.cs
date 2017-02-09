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
    public class ProfileController : Controller
    {
        // GET: Auth
        public ActionResult Login()
        {
            return View();
        }

        public async Task<ActionResult> AuthUser(User user) {
            ResponseMessage result = new ResponseMessage();
            result = await QueryList.Auth(user);
            return Json(result);
        }

        public async Task<ActionResult> GetMyUser(string mail) {
            User ul = new User();
            ul = await QueryList.GetMyUser(mail);
            return Json(ul);
        }

        public async Task<ActionResult> GetMyAnnouncing(int id)
        {
            List<Announcing> annList = new List<Announcing>();
            annList = await QueryList.GetMyAnnouncing(id);
            return Json(annList);
        }

        public ActionResult Registration()
        {
            return View();
        }

        public async Task<ActionResult>RegUser(User user)
        {
            ResponseMessage value = new ResponseMessage();
            value = await QueryList.Registration(user);
            return Json(value);
        }

    }
}