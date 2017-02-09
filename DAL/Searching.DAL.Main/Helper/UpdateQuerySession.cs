using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Searching.DAL.Main.Helper
{
    public static class UpdateQuerySession
    {
        public static string AddSubscriber_Sender(string query)
        {
            string queryResult = "";
            queryResult += query + " " + "insert into SubscribeList_Session(User_id,Session_id) values(@Sender_id,@Session_id)";
            return queryResult;
        }

        public static string AddSubscriber_Recipient(string query,int? Recipient_id)
        {
            string queryResult = "";
            if (Recipient_id != 0) { 
                queryResult += query + " " + "insert into SubscribeList_Session(User_id,Session_id) values(@Recipient_id,@Session_id)";
            }
            else
            {
                return query;
            }
            return queryResult;
        }
        public static string AddReturnValue(string query)
        {
            string queryResult = "";
            queryResult += query + " " + "select @Session_id as id";
            return queryResult;
        }
    }
}
