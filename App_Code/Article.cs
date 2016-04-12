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

	public Article()
	{
		//
		// TODO: Add constructor logic here
		//
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
    }

    public DateTime CreateDate
    {
        get
        {
            return DateTime.Parse(_fields["create_date"].ToString());
        }
    }

    public static int AddArticle(string tile, string content)
    {
        string[,] insertData = new string[,] { { "title", "varchar", tile.Trim() }, { "content", "text", content.Trim() } };
        return DBHelper.InsertData("article", insertData, Util.conStr);
        //DBHelper.InsertData("article", ;
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
}