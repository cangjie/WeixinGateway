using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
/// <summary>
/// Summary description for Course
/// </summary>
public class Course: OnlineSkiPass
{
    public Course()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public static Course[] GetOnlieCourseByOwnerOpenId(string openId)
    {
        DataTable dt = DBHelper.GetDataTable(" select * from order_online "
            + " left join [card] on card_no = code and [card].[type] = '课程'  "
            + " where  card_no is not null and open_id = '"
            + openId.Trim() + "'  and pay_state = 1 "
            + " order by [id] desc ");
        Course[] passArr = new Course[dt.Rows.Count];
        for (int i = 0; i < passArr.Length; i++)
        {
            passArr[i] = new Course();
            passArr[i]._fields = dt.Rows[i];
        }
        //dt.Dispose();
        return passArr;
    }
}