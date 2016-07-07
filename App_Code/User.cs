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
                //throw new Exception("not found");
            }
            else
            {
                JsonHelper jsonObject = new JsonHelper(json);
                string nick = "";
                try
                {
                    nick = jsonObject.GetValue("nickname");
                }
                catch
                { 
                
                }
                string headImageUrl = "";
                try
                {
                    headImageUrl = jsonObject.GetValue("headimgurl");
                }
                catch
                { 
                
                }
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
            DateTime updateInfoTime = DateTime.MinValue;
            try
            {
                updateInfoTime = DateTime.Parse(_fields["update_time"].ToString());
            }
            catch
            { 
            
            }
            if ((DateTime.Now - updateInfoTime > new TimeSpan(24, 0, 0)) || Nick.Trim().Equals("") || HeadImage.Trim().Equals(""))
            {
                UpdateUserInfo(openId);
            }
        }

    }


    public string LinkFatherUser(int sceenId)
    {
        DataTable dt = DBHelper.GetDataTable(" select * from users where qr_code_scene = " + sceenId.ToString(), Util.conStr);
        string fatherOpenId = "";
        if (dt.Rows.Count > 0)
        {
            fatherOpenId = dt.Rows[0]["open_id"].ToString().Trim();
        }
        string[,] updateParameters = new string[,] { { "father_open_id", "varchar", fatherOpenId.Trim() } };
        string[,] keyParameters = new string[,] { { "open_id", "varchar", OpenId.Trim() } };
        DBHelper.UpdateData("users", updateParameters, keyParameters, Util.conStr);
        return fatherOpenId.Trim();
    }

    public bool Subscribe
    {
        get
        {
            if (_fields["is_subscribe"].ToString().Equals("0"))
            {
                return false;
            }
            else
            {
                return true;
            }
        }
        set
        {
            int subscribe = 0;
            if (value)
            {
                subscribe = 1;
                UpdateUserInfo(OpenId);
            }
            string[,] updateParameter = new string[,] { { "is_subscribe", "int", subscribe.ToString() } };
            string[,] keyParameters = new string[,] { { "open_id", "varchar", OpenId.Trim() } };
            DBHelper.UpdateData("users", updateParameter, keyParameters, Util.conStr);
        }
    }

    public static void UpdateUserInfo(string openId)
    {
        string json = Util.GetWebContent("https://api.weixin.qq.com/cgi-bin/user/info?access_token="
            + Util.GetToken() + "&openid=" + openId + "&lang=zh_CN");
        if (json.IndexOf("errocde") >= 0)
        {
            //throw new Exception("not found");
        }
        else
        {
            JsonHelper jsonObject = new JsonHelper(json);
            string nick = "";
            try
            {
                nick = jsonObject.GetValue("nickname");
            }
            catch
            {

            }
            string headImageUrl = "";
            try
            {
                headImageUrl = jsonObject.GetValue("headimgurl");
            }
            catch
            {

            }
            string[,] updateParameters = new string[,] { { "nick", "varchar", nick }, 
                { "head_image", "varchar", headImageUrl }, 
                {"update_time", "datetime", DateTime.Now.ToString() } };
            string[,] keyParameters = new string[,] { { "open_id", "varchar", openId.Trim() } };
            DBHelper.UpdateData("users", updateParameters, keyParameters, Util.conStr);
        }
    }


    public static int RegisterFamily(string school, string major, DateTime checkinDate)
    {
        int familyId = 0;
        KeyValuePair<string, KeyValuePair<SqlDbType, object>>[] familyParameterArray
            = new KeyValuePair<string, KeyValuePair<SqlDbType, object>>[3];
        familyParameterArray[0] = new KeyValuePair<string, KeyValuePair<SqlDbType, object>>("school",
            new KeyValuePair<SqlDbType, object>(SqlDbType.VarChar, (object)school));
        familyParameterArray[1] = new KeyValuePair<string, KeyValuePair<SqlDbType, object>>("major",
            new KeyValuePair<SqlDbType, object>(SqlDbType.VarChar, (object)major));
        familyParameterArray[2] = new KeyValuePair<string, KeyValuePair<SqlDbType, object>>("checkin_date",
            new KeyValuePair<SqlDbType, object>(SqlDbType.DateTime, (object)checkinDate));
        int i = DBHelper.InsertData("families", familyParameterArray);
        if (i > 0)
        {
            DataTable dt = DBHelper.GetDataTable(" select max([id]) from families ");
            if (dt.Rows.Count > 0)
                familyId = int.Parse(dt.Rows[0][0].ToString());
            dt.Dispose();
        }
        return familyId;
    }

    public  bool RegisterFamilyMember(bool isChild, int familyId, string name)
    {
        KeyValuePair<string, KeyValuePair<SqlDbType, object>>[] memberParameterArray
            = new KeyValuePair<string,KeyValuePair<SqlDbType,object>>[3];
        memberParameterArray[0] = new KeyValuePair<string, KeyValuePair<SqlDbType, object>>("open_id",
                new KeyValuePair<SqlDbType, object>(SqlDbType.VarChar, (object)OpenId.Trim()));
        memberParameterArray[1] = new KeyValuePair<string, KeyValuePair<SqlDbType, object>>("family_id",
                new KeyValuePair<SqlDbType, object>(SqlDbType.VarChar, (object)familyId));
        memberParameterArray[2] = new KeyValuePair<string, KeyValuePair<SqlDbType, object>>("name",
                new KeyValuePair<SqlDbType, object>(SqlDbType.VarChar, (object)name));
        int i = DBHelper.InsertData((isChild ? "children" : "parents"), memberParameterArray);
        if (i > 0)
            return true;
        else
            return false;
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

    public string School
    {
        get
        {
            string school = "";
            if (FamilyId > 0)
            {
                DataTable dt = DBHelper.GetDataTable(" select * from families where [id] = " + FamilyId);
                if (dt.Rows.Count > 0)
                    school = dt.Rows[0]["school"].ToString().Trim();
                dt.Dispose();
            }
            return school;
        }
    }

    public string Major
    {
        get
        {
            string major = "";
            if (FamilyId > 0)
            {
                DataTable dt = DBHelper.GetDataTable(" select * from families where [id] = " + FamilyId);
                if (dt.Rows.Count > 0)
                    major = dt.Rows[0]["school"].ToString().Trim();
                dt.Dispose();
            }
            return major;
        }
    }

    public DateTime CheckInDate
    {
        get
        {
            DateTime checkInDate = DateTime.Parse("1900-1-1");
            if (FamilyId > 0)
            {
                DataTable dt = DBHelper.GetDataTable(" select * from families where [id] = " + FamilyId);
                if (dt.Rows.Count > 0)
                    checkInDate = DateTime.Parse(dt.Rows[0]["checkin_date"].ToString().Trim());
                dt.Dispose();
            }
            return checkInDate;
        }
    }

    public int FamilyId
    {
        get
        {
            int familyId = 0;
            string sql = " ";
            if (IsParent)
                sql = " select * from parents where open_id = '" + OpenId.Trim() + "'  ";
            else
                if (IsChild)
                    sql = " select * from children where open_id = '" + OpenId.Trim() + "'  ";
            if (!sql.Trim().Equals(""))
            {
                DataTable dt = DBHelper.GetDataTable(sql);
                if (dt.Rows.Count > 0)
                {
                    familyId = int.Parse(dt.Rows[0]["family_id"].ToString().Trim());
                }
            }
            return familyId;
        }
    }

    public string Name
    {
        get
        {
            bool isParent = IsParent;
            bool isChild = IsChild;
            if ((!isParent && !isChild) || ( isParent && isChild ))
                return "";
            else
            {
                string sql = " select * from " + (isParent ? "parents" : "children") + "  where open_id = '" + OpenId.Trim() + "'  ";
                DataTable dt = DBHelper.GetDataTable(sql);
                string name = "";
                if (dt.Rows.Count > 0)
                    name = dt.Rows[0]["name"].ToString().Trim();
                dt.Dispose();
                return name.Trim();
            }
        }
    }

    public bool IsChild
    {
        get
        {
            DataTable dt = DBHelper.GetDataTable(" select * from children where open_id = '" + OpenId.Trim() + "'  ");
            bool isChild = true;
            if (dt.Rows.Count == 0)
                isChild = false;
            dt.Dispose();
            return isChild;
        }
    }

    public bool IsParent
    {
        get
        {
            DataTable dt = DBHelper.GetDataTable(" select * from parents where open_id = '" + OpenId.Trim() + "'  ");
            bool isParent = true;
            if (dt.Rows.Count == 0)
                isParent = false;
            dt.Dispose();
            return isParent;
        }
    }

    public bool HaveRegisted
    {
        get
        {
            return (IsChild || IsParent);
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

    public int QrCodeSceneId
    {
        get
        {
            int currentSceneId = int.Parse(_fields["qr_code_scene"].ToString().Trim());
            if (currentSceneId == 0)
            {
                currentSceneId = QrCode.CreateScene();
                string[,] updateParameter = new string[,] { { "qr_code_scene", "int", currentSceneId.ToString()} };
                string[,] keyParameter = new string[,] { { "open_id", "varchar", OpenId.Trim() } };
                DBHelper.UpdateData("users", updateParameter, keyParameter, Util.conStr.Trim());
                return currentSceneId;

            }
            else
            {
                return currentSceneId;
            }

        }
    }

    public string FatherOpenId
    {
        get
        {
            return _fields["father_open_id"].ToString().Trim();
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
         + token.Replace("'", "").Trim() + "'  and expire_date <= getdate() and valid = 1 order by crt desc ",
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