using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Searching.DAL.Main.Helper
{
  public static  class QueryPaging
    {
        public static string CreareObjectList(string qeury)
        {
            string result = "";
            result = "WITH ObjectList AS(" + qeury + ")";
            return result;
        }
        public static  string CreatePaging(string query)
        {
            string result = "";
            result = query + " SELECT *FROM ObjectList WHERE Row_id BETWEEN((@nPage - 1) * @sizePage + 1) AND(@nPage * @sizePage)";
            return result;
        }
    }
}
