using Searching.AL.Storage.Model;
using SearchingLibrary;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Searching.AL.Storage.Storage
{
   public class DBCountries
    {
        public static void AddCountries(List<Country> countries)
        {
            using (UserDataContext context = new UserDataContext(UserDataContext.DBConnectionString))
            {
                foreach(Country c in countries.ToList())
                {
                    LCountries lc = new LCountries();
                    lc.Country_id = c.Country_id;
                    lc.Name_Country = c.Name_country;
                    try
                    {
                        context.Countries.InsertOnSubmit(lc);
                        context.SubmitChanges();
                    }
                    catch(Exception ex)
                    {
                        throw ex;
                    }
                }
            }
        }
        public static IList<LCountries> GetCountries()
        {
            IList<LCountries> list = null;
            using (UserDataContext context = new UserDataContext(UserDataContext.DBConnectionString))
            {
                IQueryable<LCountries> query = from c in context.Countries select c;
                list = query.ToList();
            }
            return list;
        }
    }
}
