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