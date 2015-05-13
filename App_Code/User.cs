using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

/// <summary>
/// Summary description for User
/// </summary>
public class WeixinUser : ObjectHelper
{
    
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


            }
        }
        else 
        {
            _fields = dt.Rows[0];
        }

	}
    
    public int VipLevel
    {
        get
        {
            return int.Parse(_fields["vip_level"].ToString().Trim());
        }
    }

    public bool IsAdmin
    {
        get
        {
            return bool.Parse(_fields["is_admin"].ToString().Trim());
        }
    }

    public static string GetToken(string openId)
    {
        
        return "";
    }

    public static string CreateToken(string openId)
    {
        return "";
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