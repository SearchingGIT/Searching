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
  //Класс, в котором все функции над Объявлениями
   public  static class AnnouncingFunction
    {
        public static ResponseMessage  Add(Announcing ann)
        {
            ResponseMessage response = new ResponseMessage();
            string connectionString = SqlAccess.GetConnectionString();
            SqlConnection connect = new SqlConnection(connectionString);
            string query = "INSERT INTO Announcing (Name_Announcing, Phone_Announcing,DT_Announcing, Info_Announcing, Categories_id, User_id,City_id, Areas_id) VALUES(@Name_Announcing, @Phone_Announcing, @Date_Announcing, @Info_Announcing, @Categories_id, @User_id, @City_id,@Areas_id);";
            SqlCommand command = new SqlCommand(query, connect);
            command = DBValueCheking.AddValue(command, "@Name_Announcing", ann.Name);
            command = DBValueCheking.AddWithCheckValue(command, "@Phone_Announcing", ann.Phone);
            command = DBValueCheking.AddValue(command, "@Date_Announcing", ann.Date);
            command = DBValueCheking.AddValue(command, "@Info_Announcing", ann.Info);
            command = DBValueCheking.AddValue(command, "@Categories_id", ann.CategoryId);
            command = DBValueCheking.AddValue(command, "@User_id", ann.UserId);
            command = DBValueCheking.AddValue(command, "@City_id", ann.CityId);
            command = DBValueCheking.AddWithCheckValue(command, "@Areas_id", ann.AreaId);
            try
            {
                connect.Open();
                command.ExecuteNonQuery();
                response.Code = true;
                response.Message = "Объявления успешно добавлено!";
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

        public static DataTable GetMy(int ID)
        {
            DataTable table = new DataTable();
            string connectingString = SqlAccess.GetConnectionString();
            SqlConnection connect = new SqlConnection(connectingString);
            string query = "SELECT a.Announcing_id, a.Name_Announcing, a.Phone_Announcing, a.DT_Announcing, a.Info_Announcing, a.Categories_id, a.[User_id], a.City_id, a.Areas_id,ul.[User_id], ul.[Name], ul.LastName FROM   Announcing a JOIN UserList ul  ON a.[User_id]= ul.User_id WHERE a.[User_id]=@User_id";
            SqlCommand command = new SqlCommand(query, connect);
            command = DBValueCheking.AddValue(command, "@User_id", ID);
            try
            {
                table = SqlAccess.CreateQuery(command, "MyAnnList");
            }
            catch (Exception ex)
            {
                Logger.CreateLog(ex);
            }
            return table;
        }

        public static ResponseMessage Edit(Announcing ann)
        {
            ResponseMessage response = new ResponseMessage();
            string connectionString = SqlAccess.GetConnectionString();
            SqlConnection connect = new SqlConnection(connectionString);
            string queryString = "UPDATE Announcing SET Name_Announcing = ISNULL(@Name_Announcing, Name_Announcing), Phone_Announcing = ISNULL(@Phone_Announcing, Phone_Announcing), DT_Announcing = ISNULL(@DT_Announcing, Date_Announcing), Info_Announcing = ISNULL(@Info_Announcing, Info_Announcing), Categories_id = ISNULL(@Categories_id, Categories_id), City_id = ISNULL(@City_id, City_id), Areas_id = ISNULL(@Areas_id, Areas_id) WHERE Announcing_id = @Announcing_id";
            SqlCommand command = new SqlCommand(queryString, connect);
            command = DBValueCheking.AddWithCheckValue(command, "@Name_Announcing", ann.Name);
            command = DBValueCheking.AddWithCheckValue(command, "@Phone_Announcing", ann.Phone);
            command = DBValueCheking.AddWithCheckValue(command, "@Date_Announcing", ann.Date);
            command = DBValueCheking.AddWithCheckValue(command, "@Info_Announcing", ann.Info);
            command = DBValueCheking.AddWithCheckValue(command, "@Categories_id", ann.CategoryId);
            command = DBValueCheking.AddValue(command, "@Announcing_id", ann.Id);
            command = DBValueCheking.AddWithCheckValue(command, "@City_id", ann.CityId);
            command = DBValueCheking.AddWithCheckValue(command, "@Areas_id", ann.AreaId);
            try 
            {
                connect.Open();
                command.ExecuteNonQuery();
                response.Code = true;
                response.Message = "Объявления успешно изменено!";
            }
            catch(Exception ex)
            {
                response.Code = false;
                response.Message = ex.Message;
                Logger.CreateLog(ex);
               // throw ex;
            }
            finally
            {
                connect.Close();
            }
            return response;
        }
        public static ResponseMessage Delete(int ID)
        {
            ResponseMessage response = new ResponseMessage();
            string connectionString = SqlAccess.GetConnectionString();
            SqlConnection connect = new SqlConnection(connectionString);
            string queryString = "DELETE FROM Announcing WHERE Announcing_id = @Announcing_id";
            SqlCommand command = new SqlCommand(queryString, connect);
            command = DBValueCheking.AddValue(command, "@Announcing_id", ID);
            try 
            {
                connect.Open();
                command.ExecuteNonQuery();
                response.Code = true;
                response.Message = "Объявление успешно удалено!";
            }
            catch(Exception ex)
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
