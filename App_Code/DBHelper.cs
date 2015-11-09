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

    public static int UpdateData(string tableName, 
        KeyValuePair<string, KeyValuePair<SqlDbType, object>>[] updateParameters,
        KeyValuePair<string, KeyValuePair<SqlDbType, object>>[] keyParameters)
    {
        SqlCommand cmd = new SqlCommand();

        string setClause = "";
        foreach (KeyValuePair<string, KeyValuePair<SqlDbType, object>> parameter in updateParameters)
        {
            setClause = setClause + ", " + parameter.Key.Trim() + "  = @" + parameter.Key.Trim() + "  ";
            cmd.Parameters.Add("@" + parameter.Key.Trim(), parameter.Value.Key);
            cmd.Parameters["@" + parameter.Key.Trim()].Value = parameter.Value.Value;
        }
        if (setClause.StartsWith(","))
            setClause = setClause.Remove(0, 1);

        string whereClause = "";
        foreach (KeyValuePair<string, KeyValuePair<SqlDbType, object>> parameter in keyParameters)
        {
            whereClause = whereClause + "and " + parameter.Key.Trim() + "  = @" + parameter.Key.Trim() + "  ";
            cmd.Parameters.Add("@" + parameter.Key.Trim(), parameter.Value.Key);
            cmd.Parameters["@" + parameter.Key.Trim()].Value = parameter.Value.Value;
        }
        if (whereClause.StartsWith("and"))
            whereClause = whereClause.Remove(0, 3);

        cmd.CommandText = " update " + tableName.Trim() + "  set " + setClause.Trim() + "  where " + whereClause.Trim();

        SqlConnection conn = new SqlConnection(Util.conStr.Trim());
        cmd.Connection = conn;

        conn.Open();
        int i = cmd.ExecuteNonQuery();
        conn.Close();

        cmd.Parameters.Clear();
        cmd.Dispose();
        conn.Dispose();

        return i;
    }

    public static int DeleteData(string tableName, KeyValuePair<string, KeyValuePair<SqlDbType, object>>[] parameters)
    {
        if (parameters.Length == 0)
            return 0;
        SqlConnection conn = new SqlConnection(Util.conStr.Trim());
        SqlCommand cmd = new SqlCommand();
        string whereClause = "";
        foreach (KeyValuePair<string, KeyValuePair<SqlDbType, object>> parameter in parameters)
        {
            whereClause = whereClause + "and " + parameter.Key.Trim() + "  = @" + parameter.Key.Trim() + "  ";
            cmd.Parameters.Add("@" + parameter.Key.Trim(), parameter.Value.Key);
            cmd.Parameters["@" + parameter.Key.Trim()].Value = parameter.Value.Value;
        }
        if (whereClause.StartsWith("and"))
            whereClause = whereClause.Remove(0, 3);

        cmd.CommandText = " delete " + tableName.Trim() + " where  " + whereClause;
        cmd.Connection = conn;
        conn.Open();
        int i = cmd.ExecuteNonQuery();
        conn.Close();
        cmd.Dispose();
        conn.Dispose();
        return i;
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