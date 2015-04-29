using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;

/// <summary>
/// Summary description for ObjectHelper
/// </summary>
public class ObjectHelper
{

    public string tableName = "";

    public DataRow _fields;

	public ObjectHelper()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    public ObjectHelper(int id)
    {
        SqlDataAdapter da = new SqlDataAdapter(" select * from  " + tableName + " where [id] = " + id.ToString(), Util.conStr);
        DataTable dt = new DataTable();
        da.Fill(dt);
        da.Dispose();
        if (dt.Rows.Count > 0)
        {
            _fields = dt.Rows[0];
        }
        else
        {
            throw new Exception("Can't find such a record.");
        }

    }
}