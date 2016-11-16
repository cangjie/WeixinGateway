using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

/// <summary>
/// Summary description for Point
/// </summary>
public class Point
{

    public DataRow _fields;

    public Point()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public int Points
    {
        get
        {
            return int.Parse(_fields["points"].ToString());
        }
    }

    public DateTime TransactDate
    {
        get
        {
            return DateTime.Parse(_fields["transact_date"].ToString());
        }
    }

    public static int AddNew(string openId, int points, DateTime transDate, string memo)
    {
        string[,] insertParameters = {{"user_open_id", "varchar", openId.Trim() },
            {"points", "int", points.ToString() },
            { "memo", "varchar", memo.Trim()},
            { "transact_date", "datetime", transDate.ToString()}};
        int i = DBHelper.InsertData("user_point_balance", insertParameters);
        if (i == 1)
        {
            DataTable dt = DBHelper.GetDataTable(" select max([id]) from user_point_balance ");
            i = int.Parse(dt.Rows[0][0].ToString());
            dt.Dispose();
        }
        else
        {
            throw new Exception("add new point balance error.");
        }
        return i;
    }

    public static void ImportPointsByNumber(string number)
    {
        string openId = "";
        string[] openIdArr = WeixinUser.GetOpenIdByCellNumber(number);
        if (openIdArr.Length == 0)
            return;
        else if (openIdArr[0].Trim().Equals(""))
            return;
        else
            openId = openIdArr[0];
        DataTable dt = DBHelper.GetDataTable(" select * from points_imported where deal = 0 and number = '" + number.Replace("'","") + "'  ");
        foreach (DataRow dr in dt.Rows)
        {
            int i = Point.AddNew(openId, int.Parse(dr["points"].ToString()), DateTime.Parse("2016-12-1"), "16~17雪季前导入");
            string[,] updateParameter = { { "deal", "int", i.ToString() } };
            string[,] keyParameter = { { "id", "int", dr["id"].ToString() } };
            int j = DBHelper.UpdateData("points_imported", updateParameter, keyParameter, Util.conStr);
            if (j == 0)
            {
                string[,] deleteKeyParameter = { { "id", "int", i.ToString() } };
                DBHelper.DeleteData("user_point_balace", deleteKeyParameter, Util.conStr);
            }
        }
    }

    public static Point[] GetUserBalance(string openId)
    {
        DataTable dt = DBHelper.GetDataTable(" select * from user_point_balance where user_open_id = '" + openId.Trim().Replace("'", "") 
            + "' order by transact_date desc  ");
        Point[] pointArray = new Point[dt.Rows.Count];
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            pointArray[i] = new Point();
            pointArray[i]._fields = dt.Rows[i];
        }
        return pointArray;

    }

}