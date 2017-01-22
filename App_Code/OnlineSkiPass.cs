using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

/// <summary>
/// Summary description for OnlineSkiPass
/// </summary>
public class OnlineSkiPass
{
    public string cardCode = "";
    public string productName = "";
    public WeixinUser owner;
    public int count = 0;
    public bool used = false;
    public DateTime useDate;
    public OnlineOrder associateOnlineOrder;
    public OnlineOrderDetail associateOnlineOrderDetail;
    public Card associateCard;

    public OnlineSkiPass(string code)
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

    public bool Rent
    {
        get
        {
            bool ret = false;
            foreach (OnlineOrderDetail detail in associateOnlineOrder.OrderDetails)
            {
                if (detail.productName.IndexOf("押金") >= 0)
                {
                    ret = true;
                }
            }
            return ret;
        }
    }

    public DateTime AppointDate
    {
        get
        {
            try
            {
                return DateTime.Parse(Util.GetSimpleJsonValueByKey(associateOnlineOrder._fields["memo"].ToString(), "use_date"));
            }
            catch
            {
                return DateTime.Parse(DateTime.Parse(associateOnlineOrder._fields["crt"].ToString()).AddDays(1).ToShortDateString());
            }
            
        }
    }

    public static OnlineSkiPass[] GetOnlieSkiPassByOwnerOpenId(string openId)
    {
        DataTable dt = DBHelper.GetDataTable(" select * from order_online where type = '雪票' and code <> '' and code is not null and open_id = '"
            + openId.Trim() + "'  and pay_state = 1 order by [id] desc ");
        OnlineSkiPass[] passArr = new OnlineSkiPass[dt.Rows.Count];
        for (int i = 0; i < passArr.Length; i++)
        {
            passArr[i] = new OnlineSkiPass(dt.Rows[i]["code"].ToString());
        }
        dt.Dispose();
        return passArr;
    }

    public static OnlineSkiPass[] GetUnusedOnlineSkiPass()
    {
        DataTable dt = DBHelper.GetDataTable(" select code from order_online left join card on card_no = code where   card.type = '雪票' and code <> '' and code is not null   and pay_state = 1 and used = 0  order by [id] desc ");
        OnlineSkiPass[] passArr = new OnlineSkiPass[dt.Rows.Count];
        for (int i = 0; i < passArr.Length; i++)
        {
            passArr[i] = new OnlineSkiPass(dt.Rows[i]["code"].ToString());
        }
        dt.Dispose();
        return passArr;
    }

    public static OnlineSkiPass[] GetLastWeekOnlineSkiPass()
    {
        DataTable dt = DBHelper.GetDataTable(" select code from order_online left join card on card_no = code where   card.type = '雪票' and code <> '' and code is not null   and pay_state = 1   and card.crt >= '" + DateTime.Now.AddDays(-30).ToShortDateString() + "' order by [id] desc ");
        OnlineSkiPass[] passArr = new OnlineSkiPass[dt.Rows.Count];
        for (int i = 0; i < passArr.Length; i++)
        {
            passArr[i] = new OnlineSkiPass(dt.Rows[i]["code"].ToString());
        }
        dt.Dispose();
        return passArr;
    }


}