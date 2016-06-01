using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;

/// <summary>
/// Summary description for Article
/// </summary>
public class Article
{
    public DataRow _fields;

    public string[] forwardUserOpenIdArray;
    public string[] shareMomentOpenIdArray;

	public Article()
	{
		//
		// TODO: Add constructor logic here
		//
        
	}

    public Article(int id)
    {
        DataTable dt = DBHelper.GetDataTable(" select * from article where [id] = " + id.ToString());
        if (dt.Rows.Count == 1)
        {
            _fields = dt.Rows[0];
        }

        Init();

    }

    public void Init()
    {
        DataTable dtShareOpenId = DBHelper.GetDataTable(" select distinct open_id from user_action where action_name = 'forward' and action_object = " + ID.ToString());
        DataTable dtForwardOpenId = DBHelper.GetDataTable(" select distinct open_id from user_action where action_name = 'sharemoment' and action_object = " + ID.ToString());
        forwardUserOpenIdArray = new string[dtForwardOpenId.Rows.Count];
        shareMomentOpenIdArray = new string[dtShareOpenId.Rows.Count];
        for (int i = 0; i < dtShareOpenId.Rows.Count; i++)
        {
            shareMomentOpenIdArray[i] = dtShareOpenId.Rows[i][0].ToString().Trim();
        }
        for (int i = 0; i < dtForwardOpenId.Rows.Count; i++)
        {
            forwardUserOpenIdArray[i] = dtForwardOpenId.Rows[i][0].ToString().Trim();
        }
    }

    public bool IfUserSharedMoment(string openId)
    {
        bool ret = false;
        foreach (string s in shareMomentOpenIdArray)
        { 
            if (s.Trim().Equals(openId.Trim()))
            {
                ret = true;
                break;
            }
        }
        return ret;
    }

    public bool IfUserForward(string openId)
    {
        bool ret = false;
        foreach (string s in forwardUserOpenIdArray)
        {
            if (s.Trim().Equals(openId.Trim()))
            {
                ret = true;
                break;
            }
        }
        return ret;
    }



    public int ID
    {
        get
        {
            return int.Parse(_fields["id"].ToString().Trim());
        }
    }

    public string Title
    {
        get
        {
            return _fields["title"].ToString().Trim();
        }
        set
        {
            string[,] updateParameter = new string[,] { { "title", "varchar", value.Trim() } };
            string[,] keyParameter = new string[,] { { "id", "int", ID.ToString() } };
            DBHelper.UpdateData("article", updateParameter, keyParameter, Util.conStr.Trim());
        }
    }

    public string Content
    {
        get
        {
            return _fields["content"].ToString().Trim();
        }
        set
        {
            string[,] updateParameter = new string[,] { { "content", "varchar", value.Trim() } };
            string[,] keyParameter = new string[,] { { "id", "int", ID.ToString() } };
            DBHelper.UpdateData("article", updateParameter, keyParameter, Util.conStr.Trim());
        }
    }

    public string Image
    {
        get
        {
            if (_fields["image"].ToString().Trim().Equals(""))
            {
                return "http://" + System.Configuration.ConfigurationSettings.AppSettings["domain_name"].Trim()
                    + "/images/getheadimg.jpeg";
            }
            else
            {
                return "http://" + System.Configuration.ConfigurationSettings.AppSettings["domain_name"].Trim()
                    + "/" + _fields["image"].ToString().Trim();
            }
        }
        set
        {
            string[,] updateParameter = new string[,] { { "image", "varchar", value.Trim() } };
            string[,] keyParameter = new string[,] { { "id", "int", ID.ToString() } };
            DBHelper.UpdateData("article", updateParameter, keyParameter, Util.conStr.Trim());
        }
    }

    public DateTime CreateDate
    {
        get
        {
            return DateTime.Parse(_fields["create_date"].ToString());
        }
    }

    public string Json
    {
        get
        {
            string json = "{\"article_id\" : " + ID.ToString() + "  ,  \"article_title\" : \"" + Title.Trim() + "\" }";
            return json;
        }
    }

    public static int AddArticle(string tile, string content)
    {
        string[,] insertData = new string[,] { { "title", "varchar", tile.Trim() }, { "content", "text", content.Trim() } };
        DBHelper.InsertData("article", insertData, Util.conStr);
        DataTable dt = DBHelper.GetDataTable(" select max([id]) from article  ");
        int i = 0;
        if (dt.Rows.Count == 1)
        {
            i = int.Parse(dt.Rows[0][0].ToString().Trim());
        }
        dt.Dispose();
        return i;
    }

    public static Article[] GetList()
    {
        SqlDataAdapter da = new SqlDataAdapter(" select * from article order by [id] desc ", Util.conStr);
        DataTable dt = new DataTable();
        da.Fill(dt);
        da.Dispose();
        Article[] articleArray = new Article[dt.Rows.Count];
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            articleArray[i] = new Article();
            articleArray[i]._fields = dt.Rows[i];
        }
        return articleArray;
    }

    public static DataTable GetActionTable(int articleId, string ownerOpenId, string actionType)
    {
        DataTable dt = new DataTable();
        dt.Columns.Add("open_id");
        dt.Columns.Add("date");
        DataTable dtUserAction = DBHelper.GetDataTable(" select * from user_action where action_name = '" + actionType.Trim().Replace("'", "")
            + "'  and action_object = " + articleId.ToString() + "  and object_open_id = '" + ownerOpenId.Trim().Replace("'", "") + "'  order by [id]  ");
        foreach (DataRow drUserAction in dtUserAction.Rows)
        {
            string openId = drUserAction["open_id"].ToString().Trim();
            DateTime actionDate = DateTime.Parse(drUserAction["action_time"].ToString().Trim());
            DataRow[] drTmpArr = dt.Select(" open_id = '" + openId + "' ");
            if (drTmpArr.Length == 0)
            {
                DataRow drNew = dt.NewRow();
                drNew["open_id"] = openId.Trim();
                drNew["date"] = DateTime.Parse(actionDate.Year.ToString() + "-" + actionDate.Month.ToString() + "-" + actionDate.Day.ToString());
                dt.Rows.Add(drNew);
            }
        }
        return dt;
    }

}