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


	

    public Class(int id)
    {
        tableName = "classes";

        DataTable dt = DBHelper.GetDataTable(" select * from classes where [id] = " + id.ToString());

        if (dt.Rows.Count > 0)
        {
            _fields = dt.Rows[0];
        }
        else
        {
            throw new Exception("not found");
        }

    }

    public Class()
    {
        tableName = "classes";
    }

    public bool UnRegist(string openId)
    {
        KeyValuePair<string, KeyValuePair<SqlDbType, object>>[] parameters = new KeyValuePair<string, KeyValuePair<SqlDbType, object>>[2];
        parameters[0] = new KeyValuePair<string, KeyValuePair<SqlDbType, object>>("class_id",
            new KeyValuePair<SqlDbType, object>(SqlDbType.Int, _fields["id"].ToString().Trim()));
        parameters[1] = new KeyValuePair<string, KeyValuePair<SqlDbType, object>>("weixin_open_id",
            new KeyValuePair<SqlDbType, object>(SqlDbType.VarChar, openId));
        int i = DBHelper.DeleteData("class_regist", parameters);
        if (i == 1)
            return true;
        else
            return false;
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

    public DateTime BeginTime
    {
        get
        {
            return DateTime.Parse(_fields["begin_time"].ToString().Trim());
        }
    }

    public static Class[] GetClasses(DateTime start, DateTime end)
    {
        KeyValuePair<string, KeyValuePair<SqlDbType, object>>[] parameters
            = new KeyValuePair<string, KeyValuePair<SqlDbType, object>>[2];
        parameters[0] = new KeyValuePair<string, KeyValuePair<SqlDbType, object>>("@start",
            new KeyValuePair<SqlDbType, object>(SqlDbType.DateTime, start));
        parameters[1] = new KeyValuePair<string, KeyValuePair<SqlDbType, object>>("@end",
            new KeyValuePair<SqlDbType,object>(SqlDbType.DateTime, end));
        DataTable dt = DBHelper.GetDataTable(" select * from classes where begin_time > @start and begin_time < @end ", parameters);
        Class[] classArray = new Class[dt.Rows.Count];
        for(int i = 0 ; i < classArray.Length ; i++)
        {
            classArray[i] = new Class();
            classArray[i]._fields = dt.Rows[i];
        }
        return classArray;
    }

}