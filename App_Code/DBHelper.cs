using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;

/// <summary>
/// Summary description for DBHelper
/// </summary>
public class DBHelper
{
	public DBHelper()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    public static int InsertData(string tableName, KeyValuePair<string, KeyValuePair<SqlDbType, object>>[] parameters)
    {
        SqlConnection conn = new SqlConnection(Util.conStr.Trim());
        SqlCommand cmd = new SqlCommand();
        string fieldClause = "";
        string valuesClause = "";
        foreach (KeyValuePair<string, KeyValuePair<SqlDbType, object>> param in parameters)
        {
            fieldClause = fieldClause + "," + param.Key.Trim();
            valuesClause = valuesClause + ",@" + param.Key.Trim();
            cmd.Parameters.Add("@" + param.Key.Trim(), param.Value.Key);
            cmd.Parameters["@" + param.Key.Trim()].Value = param.Value.Value;
        }
        fieldClause = fieldClause.Remove(0, 1);
        valuesClause = valuesClause.Remove(0, 1);
        string sql = " insert into " + tableName.Trim() + "  ( "
            + fieldClause + " )  values (" + valuesClause + " )  ";
        cmd.Connection = conn;
        cmd.CommandText = sql;
        conn.Open();
        int i = cmd.ExecuteNonQuery();
        conn.Close();
        cmd.Parameters.Clear();
        cmd.Dispose();
        conn.Dispose();
        return i;
    }


    public static DataTable GetDataTable(string sql)
    {
        DataTable dt = new DataTable();

        SqlDataAdapter da = new SqlDataAdapter(sql, Util.conStr);
        da.Fill(dt);
        da.Dispose();
        return dt;
    }

    public static DataTable GetDataTable(string sql, KeyValuePair<string, KeyValuePair<SqlDbType, object>>[] paramArr)
    {
        DataTable dt = new DataTable();
        
        SqlDataAdapter da = new SqlDataAdapter(sql, Util.conStr);
        foreach (KeyValuePair<string, KeyValuePair<SqlDbType, object>> param in paramArr)
        {
            da.SelectCommand.Parameters.Add(param.Key.Trim(), param.Value.Key);
            da.SelectCommand.Parameters[param.Key.Trim()].Value = param.Value.Value;
        }
        da.Fill(dt);
        da.SelectCommand.Parameters.Clear();
        da.Dispose();
        return dt;
    }

}