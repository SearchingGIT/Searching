using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Searching.Shared.API.DataModel
{
   public static class DateHelper
    {
        public static DateTime ParseToDateTime(string JsonDate)
        {
            if (JsonDate != null)
                return DateTime.Parse(JsonDate);
            return new DateTime();
        }
    }
}
