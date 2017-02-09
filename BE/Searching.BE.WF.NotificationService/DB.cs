using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using Searching.BE.WF.NotificationService.ApiService;

namespace WorkflowService3
{
    public static class DB
    {
        public static List<Searching.BE.WF.NotificationService.ApiService.Messages> GetNewsMessages()
        { 
            DataTable table = new DataTable();
            List<Searching.BE.WF.NotificationService.ApiService.Messages> msgList = new List<Messages>();
            Searching.BE.WF.NotificationService.ApiService.Messages msg = new Searching.BE.WF.NotificationService.ApiService.Messages();
            string query = "select * from SubscribeList_Session ss join MessageList ml on ss.Session_id=ml.Session_id where (ml.Status_id=1 or ml.Status_id=2) and (ss.User_id !=ml.Sender_id)";
            string connectingString = Searching.DAL.Main.SqlAccess.GetConnectionString();
            SqlConnection connect = new SqlConnection(connectingString);
            SqlCommand command = new SqlCommand(query, connect);
            try
            {
              table = Searching.DAL.Main.SqlAccess.CreateQuery(command, "NewsMessages");
            }catch(Exception ex)
            {
                Searching.DAL.Main.Logger.CreateLog(ex);
            }
            foreach(DataRow row in table.Rows)
            {
                msg.Message = row["Message"].ToString();
                msg.User_id =  int.Parse(row["User_id"].ToString());
                msg.Status_id = int.Parse(row["Status_id"].ToString());
                msgList.Add(msg);
            }
            return msgList;
        }
    }
}