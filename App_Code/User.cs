using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

/// <summary>
/// Summary description for User
/// </summary>
public class User
{
	public User()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    public static string GetToken(string openId)
    {
        
        return "";
    }

    public static string CreateToken(string openId)
    {
        return "";
    }

    public static bool ValidateToken(string token)
    { 
       DataTable dt = DBHelper.GetDataTable(" select * from tokens where token = '" 
        + token.Replace("'","").Trim() + "'  and expire_date <= getdate() and valid = 1 order by crt desc ", 
        new KeyValuePair<string, KeyValuePair<SqlDbType, object>>[0]);

        bool ret = false;

        foreach (DataRow dr in dt.Rows)
        {
            if (dr["valid"].ToString().Equals("1")
                && DateTime.Parse(dr["expire_date"].ToString()) < DateTime.Now)
            {
                ret = true;
                break;
            }
        }
        return true;
    }


}