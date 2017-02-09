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
    public class AnnController : Controller
    {
        // GET: Ann

        public ActionResult UserBlock()
        {
            return View();
        }

       public ActionResult AnnBlock()
        {
            return View();
        }

        public ActionResult CategoryBlock()
        {
            return View();
        }

        public async Task<ActionResult> GetAnnFilter(AnnouncingFilter filter)
        {
            List<Announcing> la = new List<Announcing>();
            la = await QueryList.GetAnnouncingFilter(filter);
            return Json(la);
        }
       
        public async Task<ActionResult> GetAnnFull(int announcing_id)
        {
            Announcing ann = new Announcing();
            ann = await QueryList.GetAnnouncingFull(announcing_id.ToString());
            return Json(ann);
        }

        public async Task<ActionResult> AddtoSelected(SelectedAnnouncing ann)
        {
            ResponseMessage result = new ResponseMessage();
            result=await QueryList.AddtoSelected(ann); 
            return Json(result);
        }

        public async Task<ActionResult> AddtoFavorite(SelectedAnnouncing ann)
        {
            ResponseMessage result = new ResponseMessage();
            result = await QueryList.AddtoFavorite(ann);
            return Json(result);
        }
    }
}