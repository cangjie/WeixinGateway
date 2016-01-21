using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;

/// <summary>
/// Summary description for User
/// </summary>
public class WeixinUser : ObjectHelper
{
    public WeixinUser()
    {
        tableName = "users";
        primaryKeyName = "open_id";
        //primaryKeyValue = openId.Trim();
    }


	public WeixinUser(string openId)
	{
        tableName = "users";
        primaryKeyName = "open_id";
        primaryKeyValue = openId.Trim();
        DataTable dt = DBHelper.GetDataTable(" select * from users where open_id = '" + openId.Trim() + "' ");
        if (dt.Rows.Count == 0)
        {
            //throw new Exception("not found");
            string json = Util.GetWebContent("https://api.weixin.qq.com/cgi-bin/user/info?access_token="
            + Util.GetToken() + "&openid=" + openId + "&lang=zh_CN");
            if (json.IndexOf("errocde") >= 0)
            {
                throw new Exception("not found");
            }
            else
            {
                JsonHelper jsonObject = new JsonHelper(json);
                string nick = jsonObject.GetValue("nickname");
                string headImageUrl = jsonObject.GetValue("headimgurl");

                KeyValuePair<string, KeyValuePair<SqlDbType, object>>[] parameters = new KeyValuePair<string, KeyValuePair<SqlDbType, object>>[5];
                parameters[0] = new KeyValuePair<string, KeyValuePair<SqlDbType, object>>(
                    "open_id", new KeyValuePair<SqlDbType, object>(SqlDbType.VarChar, (object)openId));
                parameters[1] = new KeyValuePair<string, KeyValuePair<SqlDbType, object>>(
                    "nick", new KeyValuePair<SqlDbType, object>(SqlDbType.VarChar, (object)nick.Trim()));
                parameters[2] = new KeyValuePair<string, KeyValuePair<SqlDbType, object>>(
                    "head_image", new KeyValuePair<SqlDbType, object>(SqlDbType.VarChar, (object)headImageUrl.Trim()));
                parameters[3] = new KeyValuePair<string, KeyValuePair<SqlDbType, object>>(
                    "vip_level", new KeyValuePair<SqlDbType, object>(SqlDbType.VarChar, (object)0));
                parameters[4] = new KeyValuePair<string, KeyValuePair<SqlDbType, object>>(
                    "is_admin", new KeyValuePair<SqlDbType, object>(SqlDbType.VarChar, (object)0));

                int i = DBHelper.InsertData(tableName, parameters);

                if (i == 0)
                    throw new Exception("not inserted");
                else
                {
                    dt.Dispose();
                    dt = DBHelper.GetDataTable(" select * from users where open_id = '" + openId.Trim() + "' ");
                    _fields = dt.Rows[0];
                }


            }
        }
        else 
        {
            _fields = dt.Rows[0];
        }

	}

    public string OpenId
    {
        get
        {
            return _fields["open_id"].ToString().Trim();
        }
    }
    
    public int VipLevel
    {
        get
        {
            return int.Parse(_fields["vip_level"].ToString().Trim());
        }
        set
        {
            KeyValuePair<string, KeyValuePair<SqlDbType, object>> vipLevel
                = new KeyValuePair<string, KeyValuePair<SqlDbType, object>>("vip_level",
                    new KeyValuePair<SqlDbType, object>(SqlDbType.Int, (object)value));
            KeyValuePair<string, KeyValuePair<SqlDbType, object>>[] updateDataArr
                = new KeyValuePair<string, KeyValuePair<SqlDbType, object>>[] { vipLevel };
            KeyValuePair<string, KeyValuePair<SqlDbType, object>>[] keyDataArr
                = new KeyValuePair<string, KeyValuePair<SqlDbType, object>>[] {
                    new KeyValuePair<string , KeyValuePair<SqlDbType, object>>( "open_id",
                        new KeyValuePair<SqlDbType,object>(SqlDbType.VarChar, _fields["open_id"]))};
            int i = DBHelper.UpdateData(tableName.Trim(), updateDataArr, keyDataArr);
            if (i == 0)
                throw new Exception("update failed");
        }
    }

    public bool IsAdmin
    {
        get
        {
            if (_fields["is_admin"].ToString().Trim().Equals("1"))
                return true;
            else
                return false;
            //return bool.Parse(_fields["is_admin"].ToString().Trim());
        }
    }

    public string HeadImage
    {
        get
        {
            return _fields["head_image"].ToString().Trim();
        }
    }

    public string Nick
    {
        get
        {
            return _fields["nick"].ToString().Trim();
        }
    }

    public static WeixinUser[] GetAllUsers()
    {
        DataTable dt = DBHelper.GetDataTable(" select * from users order by crt desc ");
        WeixinUser[] usersArr = new WeixinUser[dt.Rows.Count];
        for (int i = 0; i < usersArr.Length; i++)
        {
            usersArr[i] = new WeixinUser();
            usersArr[i]._fields = dt.Rows[i];
        }
        return usersArr;
    }

    public static string CheckToken(string token)
    {
        DataTable dt = DBHelper.GetDataTable(" select * from m_token where expire > getdate() and isvalid = 1 and token = '" + token.Trim().Replace("'", "").Trim() + "'  ");
        string ret = "";
        if (dt.Rows.Count > 0)
            ret = dt.Rows[0]["open_id"].ToString().Trim();
        dt.Dispose();
        return ret;
    }

    public static string CreateToken(string openId, DateTime expireDate)
    {
        string stringWillBeToken = openId.Trim() + Util.GetLongTimeStamp(DateTime.Now)
            + Util.GetLongTimeStamp(expireDate)
            + (new Random()).Next(10000).ToString().PadLeft(4, '0');
        string token = Util.GetMd5(stringWillBeToken) + Util.GetSHA1(stringWillBeToken);

        SqlConnection conn = new SqlConnection(Util.conStr);
        SqlCommand cmd = new SqlCommand(" update m_token set isvalid = 0 where open_id = '" + openId.Trim() + "'  ", conn);
        conn.Open();
        cmd.ExecuteNonQuery();
        cmd.CommandText = " insert m_token (token,isvalid,expire,open_id) values  ('" + token.Trim() + "' "
            + " , 1 , '" + expireDate.ToString() + "' , '" + openId.Trim() + "' ) ";
        cmd.ExecuteNonQuery();
        conn.Close();
        cmd.Dispose();
        conn.Dispose();
        return token;
    }

    public static string GetOpenIdByToken(string token)
    { 
       DataTable dt = DBHelper.GetDataTable(" select * from tokens where token = '" 
        + token.Replace("'","").Trim() + "'  and expire_date <= getdate() and valid = 1 order by crt desc ", 
        new KeyValuePair<string, KeyValuePair<SqlDbType, object>>[0]);

        //bool ret = false;
       string openId = "";

        foreach (DataRow dr in dt.Rows)
        {
            if (dr["valid"].ToString().Equals("1")
                && DateTime.Parse(dr["expire_date"].ToString()) < DateTime.Now)
            {
                //ret = true;
                openId = dr["weixin_open_id"].ToString().Trim();
                break;
            }
        }
        return openId.Trim();
        //return true;
    }


}