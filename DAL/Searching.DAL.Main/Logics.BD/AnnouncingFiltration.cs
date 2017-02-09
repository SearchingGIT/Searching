using Searching.DAL.Main.Helper;
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
    // Класс, в котором функции фильтра Объявлений. 
  public  static  class AnnouncingFiltration
    {
        public static DataTable GetCategories()
        {
            string queryString = "SELECT * FROM Categories";
            DataTable table = SqlAccess.CreateCommandQuerySelect(queryString, "CategoryList");
            return table;
        }
        //int? country,int? city,int? areas,char? Gender_user,int? Date_Bearthday
        public static DataTable GetAnnouncing(AnnouncingFilter filter)
        {
            string connectionString = SqlAccess.GetConnectionString();
            SqlConnection connect = new SqlConnection(connectionString);
            string query = "SELECT a.Info_Announcing,a.DT_Announcing,a.User_id,a.Announcing_id ,a.Name_Announcing ,u.Name,u.LastName, ROW_NUMBER() OVER(ORDER BY a.Announcing_id) AS Row_id FROM Announcing a JOIN Cities c ON  c.City_id = a.City_id JOIN [UserList] u ON  u.[User_id] = a.[User_id] WHERE  a.City_id = ISNULL(@City_id, a.City_id)  AND (@Areas_id IS NULL OR a.Areas_id = @Areas_id) AND a.Category_id = ISNULL(@Category_id, a.Category_id)  AND u.Gender_user = ISNULL(@Gender_user, u.Gender_user) AND u.Date_Birthday BETWEEN ISNULL(@MinDateBirthday, u.Date_Birthday) AND ISNULL(@MaxDateBirthday, u.Date_Birthday)  AND a.Dt_Announcing >= ISNULL(@Dt_Announcing, a.Dt_Announcing)";
            query = QueryPaging.CreareObjectList(query);
            query = QueryPaging.CreatePaging(query);
            SqlCommand command = new SqlCommand(query, connect);
            command = DBValueCheking.AddWithCheckValue(command, "@Category_id", filter.CategoryId);
            command = DBValueCheking.AddWithCheckValue(command, "@City_id", filter.CityId);
            command = DBValueCheking.AddWithCheckValue(command, "@Areas_id", filter.AreaId);
            command = DBValueCheking.AddWithCheckValue(command, "@Gender_user", filter.UserGender);
            command = DBValueCheking.AddWithCheckValue(command, "@MinDateBirthday", filter.MinDateBirthday);
            command = DBValueCheking.AddWithCheckValue(command, "@MaxDateBirthday", filter.MaxDateBirthday);
            command = DBValueCheking.AddWithCheckValue(command,"@Dt_Announcing",filter.AnnouncingDate);
            command = DBValueCheking.AddValue(command, "@nPage", filter.NPage);
            command = DBValueCheking.AddValue(command, "@sizePage", filter.SizePage);
            //try
            //{
            //    connect.Open();
            //    command.ExecuteNonQuery();
            //}
            //catch (Exception ex)
            //{
            //    Logger.CreateLog(ex);
            //    throw ex;
            //}
            //finally
            //{
            //    connect.Close();
            //}
            var table = SqlAccess.CreateQuery(command,"AnnouncingList");
            return table;
        }

        
        public static DataTable GetAnnouncingFull(int announcingId)
        {
            string connectString = SqlAccess.GetConnectionString();
            string queryString = "SELECT a.Announcing_id, a.Name_Announcing, a.Phone_Announcing, a.Date_Announcing,ul.Name,ul.LastName,c.City_name, a.Info_Announcing FROM Announcing a JOIN UserList ul ON ul.[User_id] = a.[User_id] JOIN Cities c ON c.City_id = a.City_id WHERE a.Announcing_id= @Announcing_id";
            SqlConnection connect = new SqlConnection(connectString);
            SqlCommand command = new SqlCommand(queryString, connect);
            command = DBValueCheking.AddValue(command, "@Announcing_id", announcingId);
            try
            {
                connect.Open();
                command.ExecuteNonQuery();
            }
            catch(Exception ex)
            {
                Logger.CreateLog(ex);
               // throw ex;
            }
            finally
            {
                connect.Close();
            }
            DataTable table = SqlAccess.CreateQuery(command, "AnnouncingFull");
            return table;
        }
    }
}
