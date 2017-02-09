
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
   public  static class Profile
    {
        //Класс, в котором функции связанны с пользователем
        public static DataTable GetForeignUser(int userId)
        {
            string connectString = SqlAccess.GetConnectionString();
            string queryString = "SELECT * FROM User WHERE User_id = @User_id";
            SqlConnection connect = new SqlConnection(connectString);
            SqlCommand command = new SqlCommand(queryString, connect);
            command.Parameters.Add("@User_id", SqlDbType.Int);
            command.Parameters["@User_id"].Value = userId;
          //  command.ExecuteNonQuery();
            DataTable table = SqlAccess.CreateQuery(command, "UserList");
            return table;
        }

        public static DataTable GetMyUser(string mail)
        {
            string connectString = SqlAccess.GetConnectionString();
            string queryString = "SELECT * FROM UserList u WHERE u.Mail=@Mail";
            SqlConnection connect = new SqlConnection(connectString);
            SqlCommand command = new SqlCommand(queryString, connect);
            command = DBValueCheking.AddValue(command, "@Mail", mail);
            //try
            //{
            //    connect.Open();
            //    command.ExecuteNonQuery();
            //}
            //catch(Exception ex)
            //{
            //    command.Cancel();
            //    Logger.CreateLog(ex);
            //}
            //finally
            //{
            //    connect.Close();
            //}
            DataTable table = SqlAccess.CreateQuery(command, "MyUser");
            return table;
        }
        public static ResponseMessage Registration(User user)
        {
            string connectString = SqlAccess.GetConnectionString();
            ResponseMessage response = new ResponseMessage();
            response.Code = false;
            using (SqlConnection connect = new SqlConnection(connectString))
            {
                connect.Open();
                SqlTransaction tran = connect.BeginTransaction();
                SqlParameter param = new SqlParameter(); 
                string procedureName = "RegUser";
                SqlCommand command = connect.CreateCommand();
                command.Transaction = tran;
                command.CommandType = CommandType.StoredProcedure;
                command.CommandText = procedureName;
                param = DBValueCheking.AddSqlParamInput("@Mail", SqlDbType.VarChar, user.Mail);
                command.Parameters.Add(param);
                param = DBValueCheking.AddSqlParamInput("@PassNew", SqlDbType.NVarChar, user.Password);
                command.Parameters.Add(param);
                param = DBValueCheking.AddSqlParamInput("@Name", SqlDbType.VarChar, user.Name);
                command.Parameters.Add(param);
                param = DBValueCheking.AddSqlParamInput("@LastName", SqlDbType.VarChar, user.LastName);
                command.Parameters.Add(param);
                param = DBValueCheking.AddSqlParamInput("@Phone", SqlDbType.TinyInt, user.Phone);
                command.Parameters.Add(param);
                param = DBValueCheking.AddSqlParamInput("@Gender_user", SqlDbType.Char, user.Gender);
                command.Parameters.Add(param);
                param = DBValueCheking.AddSqlParamInput("@Date_Bearthday", SqlDbType.Date, user.Date_Bearthday);
                command.Parameters.Add(param);
                param = DBValueCheking.AddSqlParamInput("@Type_login", SqlDbType.TinyInt, user.TypeLogin);
                command.Parameters.Add(param);
                param = DBValueCheking.AddSqlParamInput("@City_id", SqlDbType.Int, user.CityId);
                command.Parameters.Add(param);
                param = DBValueCheking.AddSqlParamInput("@Country_id", SqlDbType.Int, user.CountryId);
                command.Parameters.Add(param);
                param = DBValueCheking.AddSqlParamInput("@Info", SqlDbType.VarChar, user.Info);
                command.Parameters.Add(param);
                try
                {
                    command.ExecuteNonQuery();
                    tran.Commit();
                    response.Code = true;
                    response.Message="Регистрация прошла успешно!";
                }
                catch (Exception ex)
                {
                    tran.Rollback();
                    Logger.CreateLog(ex);
                    response.Message = ex.Message;
                    //throw ex;
                }
                finally
                {
                    connect.Close();
                }
            }
            
            return response;
             
        }
        public static ResponseMessage Auth(User user)
        {
            ResponseMessage response = new ResponseMessage();
            response.Code = false;
            string connectString = SqlAccess.GetConnectionString();
            using (SqlConnection connect = new SqlConnection(connectString))
            {
                connect.Open();
                SqlTransaction tran = connect.BeginTransaction();
                SqlParameter param = new SqlParameter();
                string procedureName = "CheckPass";
                SqlCommand command = connect.CreateCommand();
                command.Transaction = tran;
                command.CommandType = CommandType.StoredProcedure;
                command.CommandText = procedureName;
                param = DBValueCheking.AddSqlParamInput("@Mail", SqlDbType.VarChar, user.Mail);
                command.Parameters.Add(param);
                param = DBValueCheking.AddSqlParamInput("@Pass", SqlDbType.NVarChar, user.Password);
                command.Parameters.Add(param);
                param = DBValueCheking.AddSqlParamOutput("@isValid", SqlDbType.Bit, 1);
                command.Parameters.Add(param);
                try
                {
                    command.ExecuteNonQuery();
                    tran.Commit();
                    response.Code = (bool)command.Parameters["@isValid"].Value;
                    response.Message = "Аутентификация прошла без ошибок!";
                }
                catch(Exception ex)
                {
                    tran.Rollback();
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

        public static DataTable GetUser(User user)
        {
            string connectString = SqlAccess.GetConnectionString();
            SqlConnection connect = new SqlConnection(connectString);
            string queryString = "SELECT * FROM UserList u WHERE u.Mail=@Mail";
            SqlCommand command = new SqlCommand(queryString, connect);
            command = DBValueCheking.AddValue(command, "@Mail", user.Mail);
            try
            {
                connect.Open();
                command.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                Logger.CreateLog(ex);
            }
            finally
            {
                connect.Close();
            }
            DataTable table = SqlAccess.CreateQuery(command, "User");
            return table;
        }

        public static DataTable Edit(User user)
        {
            ResponseMessage response = new ResponseMessage();
            string connectString = SqlAccess.GetConnectionString();
            string queryString = "UPDATE UserList SET    Mail = ISNULL(NULL, Mail), NAME = ISNULL(NULL, NAME), LastName = ISNULL(NULL, LastName), Phone = ISNULL(NULL, Phone), Gender_user = ISNULL(NULL, Gender_user), Date_Bearthday = ISNULL(NULL, Date_Bearthday), Info = ISNULL(NULL, Info), Country_id = ISNULL(1, Country_id), Type_login = ISNULL(NULL, Type_login), City_id = ISNULL(NULL, City_id) WHERE  USER_ID = 20 SELECT * FROM UserList ul WHERE ul.[User_id]=20  ";
            SqlConnection connect = new SqlConnection(connectString);
            SqlCommand command = new SqlCommand(queryString, connect);
            command = DBValueCheking.AddWithCheckValue(command,"@Mail",user.Mail);
            command = DBValueCheking.AddWithCheckValue(command, "@Name",user.Name);
            command = DBValueCheking.AddWithCheckValue(command, "@LastName", user.LastName);
            command = DBValueCheking.AddWithCheckValue(command, "@Phone",user.Phone);
            command = DBValueCheking.AddWithCheckValue(command, "@Gender_user", user.Gender);
            command = DBValueCheking.AddWithCheckValue(command, "@Date_Bearthday", user.Date_Bearthday);
            command = DBValueCheking.AddWithCheckValue(command, "@Info", user.Info);
            command = DBValueCheking.AddWithCheckValue(command, "@Country_id", user.CountryId);
            command = DBValueCheking.AddWithCheckValue(command, "@Type_login", user.TypeLogin);
            command = DBValueCheking.AddWithCheckValue(command, "@City_id", user.CityId);
            command = DBValueCheking.AddValue(command, "@User_id", user.Id);
            DataTable table = SqlAccess.CreateQuery(command, "NewProfile");
            return table;
        }
    }
}
