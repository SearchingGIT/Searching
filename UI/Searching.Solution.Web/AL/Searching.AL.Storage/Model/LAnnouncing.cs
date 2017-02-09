using System;
using System.Collections.Generic;
using System.Data.Linq.Mapping;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Searching.AL.Storage.Model
{
    [Table]
  public class LAnnouncing
    {
        [Column(IsDbGenerated =true,IsPrimaryKey =true)]
        public int ID { get; set; }
        [Column]
        public string UserName { get; set; }
        [Column]
        public string UserLastName { get; set; }
        [Column]
        public string Name_City { get; set; }
        [Column]
        public int Announcing_id { get; set; }
        [Column]
        public string Name_Announcing { get; set; }
        [Column]
        public Nullable<int> Phone_Announcing { get; set; }
        [Column]
        public System.DateTime? Date_Announcing { get; set; }
        [Column]
        public string Info_Announcing { get; set; }
        [Column]
        public int Categories_id { get; set; }
        [Column]
        public int User_id { get; set; }
        [Column]
        public int City_id { get; set; }
        [Column]
        public Nullable<int> Areas_id { get; set; }
    }
}
