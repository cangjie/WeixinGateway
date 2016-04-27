using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Collections;

/// <summary>
/// Summary description for UserAction
/// </summary>
public class UserAction
{

    public DataRow _fileds;

	public UserAction()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    public string Name
    {
        get
        {
            return _fileds["action_name"].ToString().Trim();
        }
    }

    public string OpenId
    {
        get
        {
            return _fileds["open_id"].ToString().Trim();
        }
    }

    public int ObjectId
    {
        get
        {
            return int.Parse(_fileds["action_object"].ToString().Trim());
        }
    }

    public string ObjectOpenId
    {
        get
        {
            return _fileds["object_open_id"].ToString().Trim();
        }
    }

    public DateTime ActionDate
    {
        get
        {
            return DateTime.Parse(_fileds["action_time"].ToString());
        }
    }


    public static UserAction[] GetOneUserValidAction(string openId)
    {
        DataTable dtDuplicate = DBHelper.GetDataTable(" select * from user_action where open_id = '" + openId.Trim().Replace("'", "") + "' order by [id]  ");
        ArrayList unduplicateActionArray = new ArrayList();
        foreach (DataRow dr in dtDuplicate.Rows)
        {
            UserAction userAction = new UserAction();
            userAction._fileds = dr;
            if (!CheckActionAlreadyInList(unduplicateActionArray, userAction))
            {
                unduplicateActionArray.Add(userAction);
            }
        }
        UserAction[] totalActionArray = new UserAction[unduplicateActionArray.Count];
        for (int i = 0; i < totalActionArray.Length; i++)
        {
            totalActionArray[i] = (UserAction)unduplicateActionArray[i];
        }
        return totalActionArray;
    
    }

    protected static bool CheckActionAlreadyInList(ArrayList actionArray, UserAction userAction)
    {
        bool isExists = false;
        foreach (object currentActionObject in actionArray)
        {
            UserAction currentAction = (UserAction)currentActionObject;
            if (!currentAction.OpenId.Equals(userAction.OpenId.Trim()))
            {
                isExists = true;
            }
            else
            {
                switch (userAction.Name.Trim().ToLower())
                {
                    case "subscribe":
                        if (currentAction.ObjectOpenId.Trim().Equals(userAction.ObjectOpenId.Trim()))
                        {
                            isExists = true;
                        }
                        break;
                    case "unsubscribe":
                        WeixinUser user = new WeixinUser(userAction.OpenId.Trim());
                        if (!user.Subscribe)
                        {
                            if (currentAction.ObjectOpenId.Trim().Equals(userAction.ObjectOpenId.Trim()))
                            {
                                isExists = true;
                            }
                        }
                        break;
                    case "forward":
                        if (currentAction.ObjectId == userAction.ObjectId
                            && currentAction.ObjectOpenId.Trim().Equals(currentAction.ObjectOpenId.Trim()))
                        {
                            isExists = true;
                        }
                        break;
                    case "sharemonent":
                        if (currentAction.ObjectId == userAction.ObjectId)
                        {
                            isExists = true;
                        }
                        break;
                    case "read":
                        if (currentAction.ObjectId == userAction.ObjectId
                            && currentAction.ObjectOpenId.Trim().Equals(userAction.ObjectOpenId.Trim()))
                        {
                            isExists = true;
                        }
                        break;
                    default:
                        isExists = true;
                        break;
                }
            }
            if (isExists)
                break;

        }
        return isExists;
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