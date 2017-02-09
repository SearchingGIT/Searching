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
    //Класс, в котором все функции над Выбранными Объявлениями
  public static  class FavoriteAnnouncingFunction
    {

        public static DataTable CheckRecording(FavoriteAnnouncing ann)
        { 
            string connectString = SqlAccess.GetConnectionString();
            string queryString = "SELECT* from Favorite_Announcing f where f.Announcing_id = @ann_id AND f.User_id = @user_id";
            SqlConnection connect = new SqlConnection(connectString);
            SqlCommand command = new SqlCommand(queryString, connect);
            DBValueCheking.AddValue(command, "@ann_id", ann.Id);
            DBValueCheking.AddValue(command, "@user_id", ann.UserId);
            //try {
            //    connect.Open(); 
            //    command.ExecuteNonQuery();
                
            //}catch(Exception ex)
            //{
                
            //    Logger.CreateLog(ex);
            //    throw ex;
            //}
            //finally
            //{
            //    connect.Close();
            //}
            var table = SqlAccess.CreateQuery(command, "Recording");
            return table;
        } 
        public static DataTable Get(int userId)
        {
            string connectString = SqlAccess.GetConnectionString();
            string queryString = "SELECT a.Announcing_id, a.Name_Announcing, a.Phone_Announcing, a.Areas_id, a.Date_Announcing, a.Info_Announcing, a.Categories_id FROM   Favorite_Announcing fa JOIN Announcing a ON  a.Announcing_id = fa.Announcing_id WHERE fa.[User_id] = @User_id";
            SqlConnection connect = new SqlConnection(connectString);
            SqlCommand command = new SqlCommand(queryString, connect);
            command.Parameters.Add("@User_id", SqlDbType.Int);
            command.Parameters["@User_id"].Value = userId;
           // command.ExecuteNonQuery();
            DataTable table = SqlAccess.CreateQuery(command, "FavoriteAnnouncing");
            return table;
        }
        public static ResponseMessage Add(FavoriteAnnouncing ann)
        {
            ResponseMessage response = new ResponseMessage();
            string connectString = SqlAccess.GetConnectionString();
            string queryString = "INSERT INTO Favorite_Announcing(Announcing_id,User_id) VALUES(@Announcing_id, @User_id);";
            SqlConnection connect = new SqlConnection(connectString);
            SqlCommand command = new SqlCommand(queryString, connect);
            command = DBValueCheking.AddValue(command, "@Announcing_id", ann.Id);
            command = DBValueCheking.AddValue(command, "@User_id", ann.UserId);
            try
            {
                connect.Open();
                command.ExecuteNonQuery();
                response.Code = true;
                response.Message = "Объявления успешно добавлено!";
            }
            catch (Exception ex)
            {
                Logger.CreateLog(ex);
                response.Code = false;
                response.Message = ex.Message;
                //throw ex;
            }
            finally
            {
                connect.Close();
                
            }
            return response;
        }
        public static ResponseMessage Delete(FavoriteAnnouncing ann)
        {
            ResponseMessage response = new ResponseMessage();
            string connectString = SqlAccess.GetConnectionString();
            string queryString = "DELETE FROM Favorite_Announcing WHERE Announcing_id = @Announcing_id AND User_id = @User_id";
            SqlConnection connect = new SqlConnection(connectString);
            SqlCommand command = new SqlCommand(queryString, connect);
            command = DBValueCheking.AddValue(command, "@Announcing_id", ann.Id);
            command = DBValueCheking.AddValue(command, "@User_id", ann.UserId);
            try
            {
                connect.Open();
                command.ExecuteNonQuery();
                response.Code = true;
                response.Message = "Объявление успешно удалено!";
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
    }
}
