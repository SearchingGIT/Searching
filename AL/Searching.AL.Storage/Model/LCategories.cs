using System;
using System.Collections.Generic;
using System.Data.Linq.Mapping;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Searching.AL.Storage.Model
{
   [Table]
   public class LCategories
    {
        [Column(IsDbGenerated =true,IsPrimaryKey =true)]
        public int ID { get; set; }
        [Column]
        public int Categories_id { get; set; }
        [Column]
        public string Name_Category { get; set; }
        [Column]
        public string Info_Category { get; set; }
    }
}
