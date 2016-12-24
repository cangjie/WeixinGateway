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


}