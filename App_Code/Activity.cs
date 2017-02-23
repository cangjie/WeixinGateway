using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

/// <summary>
/// Summary description for Activity
/// </summary>
public class Activity
{
    public string cardCode = "";

    public Card card;

    public Activity()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public Activity(string code)
    {
        cardCode = code;
        card = new Card(cardCode);
        if (!card._fields["type"].ToString().Equals("活动"))
        {
            throw new Exception("This card is not for activity.");
        }
    }



    public OnlineOrder AssociateOnlineOrder
    {
        get
        {
            DataTable dt = DBHelper.GetDataTable(" select [id] from order_online where type='活动' and pay_state = 1 and code = '" + cardCode.Trim() + "' ");
            int orderId = int.Parse(dt.Rows[0][0].ToString());
            dt.Dispose();
            return new OnlineOrder(orderId);
        }
    }

    public WeixinUser Owner
    {
        get
        {
            return new WeixinUser(AssociateOnlineOrder._fields["open_id"].ToString());
        }
    }

    public DataTable RegistrationList
    {
        get
        {
            
            DataTable dt = new DataTable();
            dt.Columns.Add("活动名称");
            dt.Columns.Add("姓名");
            dt.Columns.Add("手机");
            dt.Columns.Add("身份证号");
            dt.Columns.Add("是否租板");
            dt.Columns.Add("身高");
            dt.Columns.Add("鞋码");

            string regJson = card.Memo.Trim();
            Dictionary<string, object>[] regListArr = Util.GetObjectArrayFromJsonByKey(regJson, "regist_person");
            foreach (Dictionary<string, object> reg in regListArr)
            {
                DataRow dr = dt.NewRow();
                dr[0] = AssociateOnlineOrder.OrderDetails[0].productName.Trim();
                dr[1] = reg["name"].ToString().Trim();
                dr[2] = reg["cell_number"].ToString().Trim();
                dr[3] = reg["idcard"].ToString().Trim();
                dr[4] = (reg["rent"].ToString().Equals("0") ? "自带" : "租板");
                dr[5] = (reg["rent"].ToString().Equals("0") ? "--" : reg["length"].ToString().Trim());
                dr[6] = (reg["rent"].ToString().Equals("0") ? "--" : reg["boot_size"].ToString().Trim());
                dt.Rows.Add(dr);
            }
        

            return dt;
        }
    }

    public static DataTable GetRegistrationList(int productId)
    {
        Product product = new Product(productId);
        OnlineOrder[] orderArr = OnlineOrder.GetActivityOrders(productId);
        DataTable dt = new DataTable();
        dt.Columns.Add("活动名称");
        dt.Columns.Add("姓名");
        dt.Columns.Add("手机");
        dt.Columns.Add("身份证号");
        dt.Columns.Add("是否租板");
        dt.Columns.Add("身高");
        dt.Columns.Add("鞋码");
        foreach (OnlineOrder order in orderArr)
        {
            Card card = new Card(order._fields["code"].ToString());
            string regJson = card.Memo.Trim();
            Dictionary<string, object>[] regListArr = Util.GetObjectArrayFromJsonByKey(regJson, "regist_person");
            foreach (Dictionary<string, object> reg in regListArr)
            {
                DataRow dr = dt.NewRow();
                dr[0] = product._fields["name"].ToString();
                dr[1] = reg["name"].ToString().Trim();
                dr[2] = reg["cell_number"].ToString().Trim();
                dr[3] = reg["idcard"].ToString().Trim();
                dr[4] = (reg["rent"].ToString().Equals("0") ? "自带" : "租板");
                dr[5] = (reg["rent"].ToString().Equals("0") ? "--" : reg["length"].ToString().Trim());
                dr[6] = (reg["rent"].ToString().Equals("0") ? "--" : reg["boot_size"].ToString().Trim());
                dt.Rows.Add(dr);
            }
        }

        return dt;
    }
}