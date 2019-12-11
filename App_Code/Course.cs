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


    public OnlineSkiPass skiPass;

    public Course()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public Course(string code)
    {
        cardCode = code;
        DataTable dtOrder = DBHelper.GetDataTable(" select [id] from order_online where type='雪票' and code = '" + code.Trim() + "' ");
        associateOnlineOrder = new OnlineOrder(int.Parse(dtOrder.Rows[0][0].ToString()));
        associateOnlineOrderDetail = associateOnlineOrder.OrderDetails[0];
        productName = associateOnlineOrderDetail.productName.Trim();
        count = associateOnlineOrderDetail.count;
        associateCard = new Card(code);

        owner = new WeixinUser(associateOnlineOrder._fields["open_id"].ToString());

        if (associateCard._fields["type"].Equals("雪票"))
        {
            if (!associateCard._fields["used"].ToString().Equals("0"))
            {
                used = true;
                try
                {
                    useDate = DateTime.Parse(associateCard._fields["use_date"].ToString());
                }
                catch
                {

                }
            }

        }
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

    public string Resort
    {
        get
        {
            return AssociateOnlineOrder._fields["shop"].ToString().Trim().Trim();
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