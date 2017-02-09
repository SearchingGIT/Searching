using Searching.AL.Storage.Model;
using SearchingLibrary;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Searching.AL.Storage.Storage
{
   public class DBAreas
    {
      public static void AddAreas(List<AreasOfCity>areas)
        {

        }
        public static IList<LAreas> GetAreas()
        {
            IList<LAreas> list = null;
            using (UserDataContext context = new UserDataContext(UserDataContext.DBConnectionString))
            {
                IQueryable<LAreas> query = from c in context.Areas select c;
                list = query.ToList();
            }
            return list;
        }
    }
}
