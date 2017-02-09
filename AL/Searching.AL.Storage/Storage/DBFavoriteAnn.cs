using Searching.AL.Storage.Model;
using SearchingLibrary;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Searching.AL.Storage.Storage
{
   public class DBFavoriteAnn
    {
        public static void AddFavoriteAnn(List<Favorite_Announcing> fa_list)
        {
            using (UserDataContext context = new UserDataContext(UserDataContext.DBConnectionString))
            {
                foreach (Favorite_Announcing fa in fa_list.ToList())
                {
                    LFavoriteAnn lfa = new LFavoriteAnn();
                    lfa.Announcing_id = fa.Announcing_id;
                    lfa.User_id = fa.User_id;
                    context.FavoriteAnn.InsertOnSubmit(lfa);
                    context.SubmitChanges();
                }
            }
        }
        public static IList<LFavoriteAnn> GetFavoriteAnn(UserList user)
        {
            IList<LFavoriteAnn> fa = null;
            using (UserDataContext context = new UserDataContext(UserDataContext.DBConnectionString))
            {
                IQueryable<LFavoriteAnn> query = from c in context.FavoriteAnn where c.User_id == user.User_id select c;
                fa = query.ToList();
            }
                return fa;
        }
    }
}
