using System;
using System.Collections.Generic;
using System.Data.Linq.Mapping;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Searching.AL.Storage.Model
{
    [Table]
    public class LCountries
    {
        [Column(IsPrimaryKey =true,IsDbGenerated =true)]
        public int ID { get; set; }
        [Column]
        public int Country_id { get; set; }
        [Column]
        public string Name_Country { get; set; }

    }
}
