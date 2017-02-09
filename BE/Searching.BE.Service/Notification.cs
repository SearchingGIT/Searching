using Searching.Shared.API.DataModel;
using System;
using System.Collections;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;

namespace Searching.BE.Service
{
    public class Notification
    {
        public static List<int> Subscribers { get; set; }
        public static List<Notice> Messages = new List<Notice>();
        private object notifyAddLock = new object();
        public static void PushMsg(List<Notice>news_msg)
        {
            foreach(Notice msg in news_msg.AsParallel())
            {
                Messages.Add(msg);
            }
        }

        public List<Notice> Check(int id )
        {
            List<Notice> msgs = new List<Notice>();
            foreach(Notice messg in msg.AsParallel())
            {
                if (messg.RecipientId == id)
                    msgs.Add(messg);
            }
            return msgs;
        }

        public List<Notice> msg
        {
            get
            {
                lock (notifyAddLock)
                {
                    return Messages;
                }
            }
            set
            {
                lock (notifyAddLock)
                {
                    Messages = value;
                }
            }
        }


        public Notification( )
        {
            
        }

        public void Notify(int id)
        {
            Subscribers.Add(id);
        }
        public event EventHandler Changed;

        public void onChanged(EventArgs e)
        {
            EventHandler handler = Changed;
            if (handler != null) handler(this, e);
        }
    
    }
}