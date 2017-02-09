using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace Searching.DAL.Main
{
    public class DBValueCheking
    {
        public static SqlCommand AddWithCheckValue(SqlCommand command,string name,object volume)
        {
            if (volume == null)
            { command.Parameters.AddWithValue(name, DBNull.Value); }
            else
            { command.Parameters.AddWithValue(name, volume); }
            return command;

        }
        public static SqlCommand AddValue(SqlCommand command,string name,object volume)
        {
            command.Parameters.AddWithValue(name, volume);
            return command;
        }
 
        public static SqlParameter AddSqlParamInput (string paramName, SqlDbType type, object value )
        {
            SqlParameter param = new SqlParameter();
            param.ParameterName = paramName;
            param.SqlDbType = type;
            param.Value = value;
            param.Direction = ParameterDirection.Input;
            return param;
        }

        public static SqlParameter AddSqlParamOutput(string paramName,SqlDbType type,int size)
        {
            SqlParameter param = new SqlParameter();
            param.ParameterName = paramName;
            param.SqlDbType = type;
            param.Size =size ;
            param.Direction = ParameterDirection.Output;
            return param;
        }
        
    }
}