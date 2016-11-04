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
    public Point()
    {
        //
        // TODO: Add constructor logic here
        //
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
        DataTable dt = DBHelper.GetDataTable(" select * from points_imported where number = '" + number.Replace("'","") + "'  ");
        foreach (DataRow dr in dt.Rows)
        {
            Point.AddNew(openId, int.Parse(dr["points"].ToString()), DateTime.Parse("2016-12-1"), "16~17雪季前导入");
        }
    }
}