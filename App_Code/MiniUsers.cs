using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for MiniUsers
/// </summary>
public class MiniUsers
{
    public DataRow _fields;

    public MiniUsers()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public MiniUsers(string openId)
    {
        DataTable dt = DBHelper.GetDataTable(" select * from mini_users where open_id = '" + openId.Trim() + "' ");
        if (dt.Rows.Count > 0)
        {
            _fields = dt.Rows[0];
        }
        else
        {

            throw new Exception("Key " + openId.Trim() + " Not Found!");
        }
    }

    public string role
    {
        get
        {
            if (_fields["is_admin"].ToString().Equals("1"))
            {
                return "staff";
            }
            else
            {
                return "customer";
            }
        }
    }

    public string OpenId
    {
        get
        {
            return _fields["open_id"].ToString().Trim();
        }
    }

    public string OfficialAccountOpenId
    {
        get
        {
            string openId = "";
            DataTable dt = DBHelper.GetDataTable(" select * from unionids where source = 'snowmeet_official_account_new' and union_id = '" + _fields["union_id"].ToString().Trim() + "' ");
            if (dt.Rows.Count > 0)
            {
                openId = dt.Rows[0]["open_id"].ToString();
            }
            return openId;
        }
    }

    public string OfficialAccountOpenIdOld
    {
        get
        {
            string openId = "";
            DataTable dt = DBHelper.GetDataTable(" select * from unionids where source = 'snowmeet_official_account' and union_id = '" + _fields["union_id"].ToString().Trim() + "' ");
            if (dt.Rows.Count > 0)
            {
                openId = dt.Rows[0]["open_id"].ToString();
            }
            return openId;
        }
    }

    public string CellNumber
    {
        get
        {
            return _fields["cell_number"].ToString().Trim();
        }
    }
    public static string CheckSessionKey(string sessionKey)
    {
        string openId = "";
        DataTable dt = DBHelper.GetDataTable(" select * from mini_session where session_key = '" + sessionKey.Trim() + "' order by create_date desc ");
        if (dt.Rows.Count == 1)
        {
            openId = dt.Rows[0]["open_id"].ToString().Trim();
        }
        dt.Dispose();
        return openId.Trim();
    }
    
}