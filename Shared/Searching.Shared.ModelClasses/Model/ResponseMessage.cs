using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace Searching.Shared.API.DataModel
{
    [DataContract]
   public  class ResponseMessage
    {
        public ResponseMessage()
        {
            Code = false;
        }

        [DataMember]
        public bool Code { get; set; }
        [DataMember]
        public int SessionId { get; set; }
        [DataMember]
        public string Message { get; set; }
    }
}
