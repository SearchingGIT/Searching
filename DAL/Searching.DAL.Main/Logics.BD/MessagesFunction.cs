
using Searching.Shared.API.DataModel;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Searching.DAL.Main.Logics.BD
{
   public static class MessagesFunction
    {
        public static ResponseMessage Add(Notice msg)
        {
            ResponseMessage response = new ResponseMessage();
            string query = "insert into MessageList(Date_message,Message,Sender_id,Status_id,Session_id) values(@DateMessage, @Message, @Sender_id, @Status_id, @Session_id)";
            string connectionString = SqlAccess.GetConnectionString();
            SqlConnection connect = new SqlConnection(connectionString);
            SqlCommand command = new SqlCommand(query, connect);
            command = DBValueCheking.AddValue(command, "@DateMessage", msg.Date);
            command = DBValueCheking.AddValue(command, "@Message", msg.Message);
            command = DBValueCheking.AddValue(command, "@Sender_id", msg.SenderId);
            command = DBValueCheking.AddValue(command, "@Status_id", msg.StatusId);
            command = DBValueCheking.AddValue(command, "@Session_id", msg.SessionId);
            try
            {
                connect.Open();
                command.ExecuteNonQuery();
                response.Code = true;
                response.Message = "Сообщение успешно добавлено!";
            }
            catch (Exception ex)
            {
                Logger.CreateLog(ex);
                response.Code = false;
                response.Message = "Ошибка операции добавления сообщения! "+ex.Message;
                //throw ex;
            }
            finally
            {
                connect.Close();
            }

            //    var table = SqlAccess.CreateQuery(command, "MessageList");
               // }
                return response;
            
        }

        public static ResponseMessage Delete(int ID)
        {
            ResponseMessage response = new ResponseMessage();
            string query = "DELETE FROM MessageList WHERE Message_id=@id";
            var connectionString = SqlAccess.GetConnectionString();
            SqlConnection connect = new SqlConnection(connectionString);
            SqlCommand command = new SqlCommand(query, connect);
            command = DBValueCheking.AddValue(command, "@id", ID);
            try
            {
                connect.Open();
                command.ExecuteNonQuery();
                response.Code = true;
                response.Message = "Операция прошла успешно!";
            }catch(Exception ex)
            {
                Logger.CreateLog(ex);
                response.Code = false;
                response.Message = ex.Message;
            }
            finally
            {
                connect.Close();
            }
            return response;
        }
    }
}
