using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
/// <summary>
/// Summary description for Class
/// </summary>
public class Class:ObjectHelper
{


	public Class()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    public Class(int id)
    {
        tableName = "classes";
    }

    public bool Regist(string openId)
    {
        bool ret = true;
        if (TotalPersonNumber > RegistedPersonNumber)
        {
            SqlConnection conn = new SqlConnection(Util.conStr);
            SqlCommand cmd = new SqlCommand(" insert into class_regist (class_id,weixin_open_id) values(" + ID.ToString() + ",'"
                + openId.Trim() + "'  ) ", conn);
            conn.Open();
            int i = cmd.ExecuteNonQuery();
            conn.Close();
            cmd.Dispose();
            conn.Dispose();
            if (i <= 0)
                ret = false;
        }
        else
        {
            ret = false;
        }
        return ret;
    }

    public string[] GetRegistedWeixinOpenId()
    {
        string sql = " select * from class_regist where class_id = " + ID.ToString();
        SqlDataAdapter da = new SqlDataAdapter(sql, Util.conStr);
        DataTable dt = new DataTable();
        da.Fill(dt);
        da.Dispose();
        string[] openIdArr = new string[dt.Rows.Count];
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            openIdArr[i] = dt.Rows[i]["weixin_open_id"].ToString();
        }
        dt.Dispose();
        return openIdArr;
    }

    public bool UnRegist(string openId)
    {
        bool ret = true;
        SqlConnection conn = new SqlConnection(Util.conStr);
        SqlCommand cmd = new SqlCommand(" delete class_regist where class_id = " + ID.ToString() + " and weixin_open_id = '" + openId + "' ",conn);
        conn.Open();
        int i = cmd.ExecuteNonQuery();
        conn.Close();
        cmd.Dispose();
        conn.Dispose();
        if (i <= 0)
            ret = false;
        return ret;
    }

    public int ID
    {
        get
        {
            return int.Parse(_fields["id"].ToString().Trim());
        }
    }

    public int TotalPersonNumber
    {
        get
        {
            return int.Parse(_fields["person_num"].ToString());
        }
    }

    public int RegistedPersonNumber
    {
        get
        {
            return GetRegistedWeixinOpenId().Length;
        }
    }
}