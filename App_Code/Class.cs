using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Threading;
/// <summary>
/// Summary description for Class
/// </summary>
public class Class:ObjectHelper
{

    //public static Thread classRemindThread;
	

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

    public bool CanCancel
    {
        get
        {
            if (DateTime.Now < DateTime.Parse(_fields["cancel_time"].ToString()))
            {
                return true;
            }
            else
            {
                return false;
            }
        }
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
            int i = 0;
            try
            {
                i = cmd.ExecuteNonQuery();
            }
            catch
            { 
            
            }
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

    public bool Regist(string openId, int num)
    {
        bool ret = true;
        if (TotalPersonNumber >= RegistedPersonNumber + num )
        {
            SqlConnection conn = new SqlConnection(Util.conStr);
            SqlCommand cmd = new SqlCommand(" insert into class_regist (class_id,weixin_open_id,num) values(" + ID.ToString() + ",'"
                + openId.Trim() + "' , " + num.ToString().Trim() + " ) ", conn);
            conn.Open();
            int i = 0;
            try
            {
                i = cmd.ExecuteNonQuery();
            }
            catch
            {

            }
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

    public DataTable GetRegistedTable()
    {
        DataTable dt = DBHelper.GetDataTable(" select weixin_open_id , num , crt from  class_regist where class_id = " + ID.ToString() + "  order by crt " );
        return dt;
    }

    public bool IsJoin(string opneId)
    {
        bool joined = false;
        foreach (string s in GetRegistedWeixinOpenId())
        {
            if (s.Trim().Equals(opneId))
            {
                joined = true;
                break;
            }
        }
        return joined;
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
            int ret = 0;
            DataTable dt = DBHelper.GetDataTable(" select sum(num) from class_regist where class_id = " + ID.ToString());
            if (dt.Rows.Count > 0 && !dt.Rows[0][0].ToString().Equals(""))
                ret = int.Parse(dt.Rows[0][0].ToString());
            return ret;

            //return GetRegistedWeixinOpenId().Length;
        }
    }

   
    public string Title
    {
        get
        {
            return _fields["title"].ToString().Trim();
        }
    }

    public string Teacher
    {
        get
        {
            return _fields["teacher"].ToString().Trim();
        }
    }

    public DateTime BeginTime
    {
        get
        {
            return DateTime.Parse(_fields["begin_time"].ToString().Trim());
        }
        set
        {
            KeyValuePair<string, KeyValuePair<SqlDbType, object>>[] paramDataUpdateArr 
                = new KeyValuePair<string,KeyValuePair<SqlDbType,object>>[1]
                {new KeyValuePair<string, KeyValuePair<SqlDbType, object>>("begin_time",
                    new KeyValuePair<SqlDbType, object>(SqlDbType.DateTime, (object)value))};
            KeyValuePair<string, KeyValuePair<SqlDbType, object>>[] paramPrimaryKey 
                = new KeyValuePair<string,KeyValuePair<SqlDbType,object>>[1]
                {new KeyValuePair<string, KeyValuePair<SqlDbType, object>>("id",
                    new KeyValuePair<SqlDbType, object>(SqlDbType.Int, _fields["id"]))};
            int i = DBHelper.UpdateData(tableName,paramDataUpdateArr,paramPrimaryKey);
            if (i <= 0)
                throw new Exception("Can't Updated");
                
        }
    }

    public string Memo
    {
        get
        {
            return _fields["memo"].ToString().Trim();
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
        DataTable dt = DBHelper.GetDataTable(" select * from classes where begin_time > @start and begin_time < @end  order by begin_time ", parameters);
        Class[] classArray = new Class[dt.Rows.Count];
        for(int i = 0 ; i < classArray.Length ; i++)
        {
            classArray[i] = new Class();
            classArray[i]._fields = dt.Rows[i];
        }
        return classArray;
    }

}