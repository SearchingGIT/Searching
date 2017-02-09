using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Searching.DAL.Main
{
   public static class SqlAccess
    {
        public static void CreateCommandNonQuery(SqlCommand command)
        { 
                command.ExecuteNonQuery();
            
        }

        public static DataTable CreateCommandQuerySelect(string queryString, string tableName)
        {

            string connectionString = GetConnectionString();
            DataSet dataSet = new DataSet("Searching");
            DataTable table = new DataTable(tableName);
            using (SqlConnection connection = new SqlConnection(
                       connectionString))
            {
                SqlCommand command = new SqlCommand(queryString, connection);

                // Open the connection.
                command.Connection.Open();
                SqlDataAdapter adapter = new SqlDataAdapter(command);

                // Fill the DataTable.
                adapter.Fill(table);

                //Add Table to DataSet
                dataSet.Tables.Add(table);

                // Close the connection.
                connection.Close();
            }
            return table;
        }

            public static DataTable CreateQuery(SqlCommand command, string TableName)
        {
            string connectionString = GetConnectionString();
            DataSet dataSet = new DataSet("Searching");
            DataTable table = new DataTable(TableName);
            using(SqlConnection connection = new SqlConnection(connectionString)) {
                try
                {
                    command.Connection.Open();

                    SqlDataAdapter adapter = new SqlDataAdapter(command);
                    adapter.Fill(table);
                    dataSet.Tables.Add(table);
                }
                catch(Exception ex)
                {
                    Logger.CreateLog(ex);
                }
                finally { 
                command.Connection.Close();
                }
            }
            return table;
        }
        public static DataTable CreateQueryWithTran(SqlCommand command, string TableName)
        {
            string connectionString = GetConnectionString();
            DataSet dataSet = new DataSet("Searching");
            DataTable table = new DataTable(TableName);
            using (SqlConnection connect = new SqlConnection(connectionString))
            {
                connect.Open();
                SqlTransaction tran = connect.BeginTransaction();
                try
                {
                    SqlDataAdapter adapter = new SqlDataAdapter(command);
                    adapter.Fill(table);
                    dataSet.Tables.Add(table);
                    tran.Commit();
                }
                catch (Exception ex)
                {
                    Logger.CreateLog(ex);
                    tran.Rollback();
                }
                finally
                {
                    connect.Close();
                }
            }
            return table;
        }

        static public string GetConnectionString()
        {
            return "Persist Security Info = False; Integrated Security = false; Initial Catalog = Searching; server = 192.168.100.101 ;User ID = sa; Password = Lfvfu432";
            //return "Data Source=190.190.100.101; Network Library=DBMSSOCN; Initial Catalog = Searching; User ID = sa; Password = 111111;";
        }
    }



        
    }

