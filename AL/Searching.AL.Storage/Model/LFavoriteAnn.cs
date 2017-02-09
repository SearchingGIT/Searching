using System;
using System.Collections.Generic;
using System.Data.Linq.Mapping;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Searching.AL.Storage.Model
{
    [Table]
    public class LFavoriteAnn
    {
        [Column(IsPrimaryKey = true, IsDbGenerated = true)]
        public int ID { get; set; }
        [Column]
        public int Announcing_id { get; set; }
        [Column]
        public int User_id { get; set; }
    }
}
