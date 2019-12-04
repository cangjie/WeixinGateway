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
    public OnlineOrderDetail associateOnlineOrderDetail;

    private string cardCode = "";

    public OnlineSkiPass skiPass;

    public Course()
    {
        //
        // TODO: Add constructor logic here
        //
    }


    public OnlineOrderDetail AssociateOnlineOrderDetail
    {
        get
        {
            if (skiPass == null)
            {
                skiPass = new OnlineSkiPass(_fields["code"].ToString().Trim());
            }
            if (associateOnlineOrderDetail == null)
            {
                associateOnlineOrderDetail = skiPass.associateOnlineOrderDetail;
            }
            return associateOnlineOrderDetail;
        }
    }

    public string CardCode
    {
        get
        {
            if (skiPass == null)
            {
                skiPass = new OnlineSkiPass(_fields["code"].ToString().Trim());
            }
            if (cardCode.Trim().Equals(""))
            {
                cardCode = skiPass.CardCode;
            }
            return cardCode;
        }
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