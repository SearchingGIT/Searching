using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace Searching.Shared.API.DataModel
{
    [DataContract]
   public class Notice
    {
        public Notice()
        {
            StatusId = 0;
        }

        [DataMember]
       public int? SessionId { get; set; }
        [DataMember]
        public int? UserId { get; set; }
        [DataMember]
        public int SenderId { get; set; }
        [DataMember]
        public int? RecipientId { get; set; }
        [DataMember]
        public int StatusId { get; set; }
        [DataMember]
        public int TypeId { get; set; }
        [DataMember]
        public DateTime Date { get; set; }
        [DataMember]
        public string Message { get; set; }
        [DataMember]
        public int AnnouncingId { get; set; }
        // public int User_id { get; set; }
        [DataMember]
        public int? CategoryId { get; set; }
    }
}
