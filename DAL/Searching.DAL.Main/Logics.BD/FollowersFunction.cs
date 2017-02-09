using Searching.Shared.API.DataModel;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Searching.DAL.Main.Logics.BD
{
    //Класс, в котором все функции, которые связанные с подписчиками 
   public static class FollowersFunction
    {
        public static ResponseMessage Add(SelectedUser user)
        {
            ResponseMessage response = new ResponseMessage();
            string connectString = SqlAccess.GetConnectionString();
            string queryString = "INSERT INTO Selected_User (User_id, Selected_user) VALUES(@User_id, @Selected_user)";
            SqlConnection connect = new SqlConnection(connectString);
            SqlCommand command = new SqlCommand(queryString, connect);
            command = DBValueCheking.AddValue(command, "@User_id", user.UserId);
            command = DBValueCheking.AddValue(command, "@Selected_user", user.Id);
            try
            {
                connect.Open();
                command.ExecuteNonQuery();
                response.Code = true;
                response.Message = "Пользователь успешно добавлен!";
            }
            catch (Exception ex)
            {
                response.Code = false;
                response.Message = ex.Message;
                Logger.CreateLog(ex);
                //throw ex;
            }
            finally
            {
                connect.Close();
            }
            return response;
        }
        public static ResponseMessage Delete(SelectedUser user)
        {
            ResponseMessage response = new ResponseMessage();
            string connectString = SqlAccess.GetConnectionString();
            string queryString = "DELETE FROM Selected_User WHERE User_id = @User_id AND Selected_user = @Selected_user";
            SqlConnection connect = new SqlConnection(connectString);
            SqlCommand command = new SqlCommand(queryString, connect);
            command = DBValueCheking.AddValue(command, "@User_id", user.UserId);
            command = DBValueCheking.AddValue(command, "@Selected_user", user.Id);
            try
            {
                connect.Open();
                command.ExecuteNonQuery();
                response.Code = true;
                response.Message = "Пользователь успешно удален!";
            }
            catch (Exception ex)
            {
                response.Code = false;
                response.Message = ex.Message;
                Logger.CreateLog(ex);
                //throw ex;
            }
            finally
            {
                connect.Close();
            }
            return response;
        }

        public static DataTable Get(int userId)
        {
            string connectString = SqlAccess.GetConnectionString();
            string queryString = "";
            SqlConnection connect = new SqlConnection(connectString);
            SqlCommand command = new SqlCommand(queryString, connect);
            
            try
            {
                connect.Open();
                command.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                Logger.CreateLog(ex);
                //throw ex;
            }
            finally
            {
                connect.Close();
            }
            var table = SqlAccess.CreateQuery(command, "FollowersList");
            return table;
        }
    }
}
