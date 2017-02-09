using Searching.AL.Storage.Model;
using SearchingLibrary;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Searching.AL.Storage.Storage
{
   public class DBCategories
    {
        public static IList<LCategories> GetCategories()
        {
            IList<LCategories> list = null;
            using (UserDataContext context =new UserDataContext(UserDataContext.DBConnectionString))
            {
                IQueryable<LCategories> query = from c in context.Categories select c;
                list = query.ToList();
            }
            return list;
        }
        public static void AddCategories(List<Categories>categories)
        {
            using (UserDataContext context = new UserDataContext(UserDataContext.DBConnectionString))
            {
                foreach(Categories cat in categories.ToList())
                {
                    LCategories lc = new LCategories();
                    lc.Categories_id = cat.Categories_id;
                    lc.Info_Category = cat.Info_Category;
                    lc.Name_Category = cat.Name_Category;
                    try { 
                    context.Categories.InsertOnSubmit(lc);
                    context.SubmitChanges();
                    }
                    catch(Exception ex)
                    {
                        throw ex;
                    }
                }
            }
        }
    }
}
