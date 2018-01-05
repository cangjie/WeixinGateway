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


    public static bool ImportPointsByNumber(string number)
    {
        string openId = "";
        string[] openIdArr = WeixinUser.GetOpenIdByCellNumber(number);
        if (openIdArr.Length == 0)
            return false;
        else if (openIdArr[0].Trim().Equals(""))
            return false;
        else
            openId = openIdArr[0];
        int points = GetOldPoints(number);

        if (points > 0)
        {
            Point[] pointArr = Point.GetUserBalance(openId.Trim());
            bool exists = false;
            foreach (Point point in pointArr)
            {
                if (point.Points == points && point.TransactDate == DateTime.Parse("2018-1-1"))
                {
                    exists = true;
                    break;
                }
            }
            if (exists)
            {
                return false;
            }
            else
            {
                int i = Point.AddNew(openId, points, DateTime.Parse("2018-1-1"), "17~18雪季前导入");
                if (i == 1)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
        }
        else
        {
            return false;
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

    public static int GetOldPoints(string number)
    {
        int points = 0;
        DataTable dt = DBHelper.GetDataTable(" select * from new_dragon_balll where [电话] = '" + number.Trim() + "' ");
        for (int j = 0;  j < dt.Rows.Count; j++)
        {
            for (int i = 1; i < dt.Columns.Count; i++)
            {
                try
                {
                    int tmp = int.Parse(dt.Rows[j][i].ToString().Trim());
                    if (i <= 17)
                    {
                        points = points + tmp;
                    }
                    else
                    {
                        points = points - tmp;
                    }
                }
                catch
                {

                }
            }
        }
        dt.Dispose();
        return points;
    }

}