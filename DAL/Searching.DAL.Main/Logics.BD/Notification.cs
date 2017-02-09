using Searching.Shared.API.DataModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Searching.DAL.Main.Logics.BD
{
   public static class Notification
    {
        public static List<Notice> GetNews()
        {
            List<Notice> msgList = new List<Notice>();
            Notice msg = new Notice();
            for(int i = 0; i < 10; i++)
            {
                msg.AnnouncingId = i;
                msg.CategoryId = 1;
                msgList.Add(msg);
            }
            return msgList;

        }
    }
}
