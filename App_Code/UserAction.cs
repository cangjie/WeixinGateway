using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

/// <summary>
/// Summary description for UserAction
/// </summary>
public class UserAction
{
	public UserAction()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    public static int AddUserAction(string openId, string actionObjectId, string objectOpenId, int sceneId, string actionName)
    {
        string[,] insertParameters = new string[,] {
            {"open_id", "varchar", openId.Trim()},
            {"action_name", "varchar", actionName.Trim()},
            {"action_object", "varchar", actionObjectId.Trim()},
            {"object_open_id", "varchar", objectOpenId.Trim()},
            {"action_sceneid", "varchar", sceneId.ToString().Trim()}
        };
        int i = DBHelper.InsertData("user_action", insertParameters);
        if (i == 1)
        {
            DataTable dt = DBHelper.GetDataTable(" select max([id]) from user_action ");
            if (dt.Rows.Count == 1)
            {
                i = int.Parse(dt.Rows[0][0].ToString());
            }
            dt.Dispose();
        }
        return i;
    }
}