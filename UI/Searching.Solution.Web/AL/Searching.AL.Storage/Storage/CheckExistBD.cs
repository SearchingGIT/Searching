using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Searching.AL.Storage.Storage
{
   public static class CheckExistBD
    {
        public static void CheckExist()
        {
            using (UserDataContext context = new UserDataContext(UserDataContext.DBConnectionString))
            {
                if (!context.DatabaseExists())
                    context.CreateDatabase();
            }
        }

    }
}
