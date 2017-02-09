using Searching.AL.Storage.Model;
using SearchingLibrary;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Searching.AL.Storage.Storage
{
   public  class DBCities
    {
        public static void AddCities(List<Cities>cities)
        {
            using (UserDataContext context = new UserDataContext(UserDataContext.DBConnectionString))
            {
                foreach(Cities c in cities.ToList() )
                {
                    LCities lc = new LCities();
                    lc.City_id = c.City_id;
                    lc.City_Name = c.City_name;
                    lc.Country_id = c.Country_id;
                    try
                    {
                        context.Cities.InsertOnSubmit(lc);
                        context.SubmitChanges();
                    }
                    catch(Exception ex)
                    {
                        throw ex;
                    }
                }
            }
        }
        public static IList<LCities>GetCities()
        {
            IList<LCities> list = null;
            using(UserDataContext context= new UserDataContext(UserDataContext.DBConnectionString))
            {
                IQueryable<LCities> query = from lc in context.Cities select lc;
                list = query.ToList();
            } 
            return list;
        }
    }
}
