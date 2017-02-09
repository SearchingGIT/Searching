using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace Searching.Shared.API.DataModel
{
    [DataContract]
    public class MessageAsyncResult:IAsyncResult
    {
        //[DataMember]
        public AsyncCallback Callback { get; set; }
        private readonly object accessLock = new object();
        private bool isCompleted = false;
        private List<Notice> result;
        private object asyncState;
        private int recipient_id;
       public MessageAsyncResult(object state, AsyncCallback callback)
        {
            this.asyncState = state;
            this.Callback = callback;
        }
        [DataMember]
        public int Recipient_id
        {
            get { lock (accessLock)
                {
                    return recipient_id;
                }
            }
            set
            {
                lock (accessLock)
                {
                    recipient_id = value;
                }
            }
        }
        [DataMember]
        public List<Notice> Result
        {
            get
            {
                lock(accessLock){ 
                return result;
                }
            }
            set
            {
                lock (accessLock) { 
                result = value;
                }
            }
        }
        [DataMember]
        public bool IsCompleted
        {
            get
            {
                lock (accessLock)
                {
                    return isCompleted;
                }
            }
            set
            {
                isCompleted = value;
            }
        }
        [DataMember]
        public object AsyncState
        {
            get
            {
                return asyncState;
            }
        }
        public bool CompletedSynchronously
        {
            get
            {
                return false;
            }
        }
        public WaitHandle AsyncWaitHandle
        {
            get
            {
                return null;
            }
        }
    }
}
