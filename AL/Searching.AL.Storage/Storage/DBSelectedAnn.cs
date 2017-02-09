using Searching.AL.Storage.Model;
using SearchingLibrary;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Searching.AL.Storage.Storage
{
   public class DBSelectedAnn
    {
        public static void AddSelectedAnn(List<Selected_Announcing> sa)
        {
            using (UserDataContext context = new UserDataContext(UserDataContext.DBConnectionString))
            {
                foreach(Selected_Announcing  sann in sa.ToList())
                {
                    LSelectedAnn lsa = new LSelectedAnn();
                    lsa.Announcing_id = sann.Announcing_id;
                    lsa.User_id = sann.User_id;
                    context.SelectedAnn.InsertOnSubmit(lsa);
                    context.SubmitChanges();
                }
            }
        }
        public static IList<LSelectedAnn> GetFavoriteAnn(UserList user)
        {
            IList<LSelectedAnn> fa = null;
            using (UserDataContext context = new UserDataContext(UserDataContext.DBConnectionString))
            {
                IQueryable<LSelectedAnn> query = from c in context.SelectedAnn where c.User_id==user.User_id  select c;
                fa = query.ToList();
            }
                return fa;
        }
    }
}
