using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

/// <summary>
/// Summary description for OnlineOrder
/// </summary>
public class OnlineOrder
{
    public DataRow _fields;

    public OnlineOrderDetail[] orderDetails = new OnlineOrderDetail[0];

    private string memo = "";

    private string type = "雪票";

    public OnlineOrder()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public OnlineOrder(int orderId)
    {
        DataTable dt = DBHelper.GetDataTable(" select * from order_online where [id] = " + orderId.ToString());
        _fields = dt.Rows[0];

    }

    public int Place(string openId)
    {
        if (_fields == null)
        {
            WeixinUser user = new WeixinUser(openId.Trim());
            if (user != null && !user.CellNumber.Trim().Equals("") )
            {
                string[,] insertParam = { {"type", "varchar", Type.Trim() },
                    {"open_id", "varchar", openId.Trim() },
                    {"cell_number", "varchar", user.CellNumber.Trim() },
                    {"name", "varchar", user.Nick.Trim() },
                    {"pay_method", "varchar", PayMethod.Trim() },
                    {"order_price", "float", OrderPrice.ToString() },
                    {"order_real_pay_price", "float", OrderPrice.ToString() },
                    {"memo", "varchar", memo.Trim() } };
                int i = DBHelper.InsertData("order_online", insertParam);
                if (i == 1)
                {
                    DataTable dt = DBHelper.GetDataTable(" select top 1 *  from order_online order by [id] desc");
                    int maxId = int.Parse(dt.Rows[0][0].ToString());
                    _fields = dt.Rows[0];

                    foreach (OnlineOrderDetail detail in orderDetails)
                    {
                        detail.AddNew(maxId);
                    }
                    return maxId;
                }
            }
        }
        return 0;
    }



    public void AddADetail(OnlineOrderDetail onlineOrderDetail)
    {
        if (_fields == null)
        {
            OnlineOrderDetail[] newOrderDetails = new OnlineOrderDetail[orderDetails.Length + 1];
            for (int i = 0; i < newOrderDetails.Length; i++)
            {
                if (i == newOrderDetails.Length - 1)
                {
                    newOrderDetails[i] = onlineOrderDetail;
                }
                else
                {
                    newOrderDetails[i] = orderDetails[i];
                }
            }
            orderDetails = newOrderDetails;
        }
    }

    public bool HaveFinishedShopSaleOrder()
    {
        OrderTemp tempOrder = OrderTemp.GetFinishedOrder(int.Parse(_fields["id"].ToString()));
        bool ret = true;
        if (tempOrder._fields["is_paid"].ToString().Equals("0"))
        {
            tempOrder.FinishOrder();
            ret = false;
        }
        return ret;
    }

    public OnlineOrderDetail[] OrderDetails
    {
        get
        {
            if (_fields == null)
                return orderDetails;
            else
                return OnlineOrderDetail.GetOnlineOrderDetails(int.Parse(_fields["id"].ToString().Trim()));
        }
    }

    public string Type
    {
        get
        {
            if (_fields != null)
            {
                return _fields["type"].ToString().Trim();
            }
            else
                return type;
        }
        set
        {
            type = value;
        }
    }

    public string PayMethod
    {
        get
        {
            return "haojin";
        }
    }

    public double OrderPrice
    {
        get
        {
            if (Type.Trim().Equals("雪票") || Type.Trim().Equals("活动"))
            {
                double price = 0;
                foreach (OnlineOrderDetail detail in OrderDetails)
                {
                    price = price + detail.summary;
                }
                return price;
            }
            else
            {
                return double.Parse(_fields["order_real_pay_price"].ToString());
            }
            
        }
    }

    public string Memo
    {
        get
        {
            if (_fields == null)
                return memo;
            else
                return _fields["memo"].ToString();
        }
        set
        {
            memo = value.Trim();
        }
    }

    public void SetOrderPaySuccess(DateTime successTime)
    {
        if (_fields["pay_state"].ToString().Equals("0"))
        {
            string[,] updateParam = { { "pay_state", "int", "1" }, { "pay_time", "datetime", successTime.ToString() } };
            string[,] keyParam = { { "id", "int", _fields["id"].ToString() } };
            DBHelper.UpdateData("order_online", updateParam, keyParam, Util.conStr.Trim());
        }
    }

    public string CreateSkiPass()
    {
        if (_fields["code"] == null || _fields["code"].ToString().Trim().Equals(""))
        {
            string code = Card.GenerateCardNo(9, 0, _fields["type"].ToString().Trim());
            string[,] updateParam = { { "code", "varchar", code } };
            string[,] keyParam = { { "id", "int", _fields["id"].ToString() } };
            DBHelper.UpdateData("order_online", updateParam, keyParam, Util.conStr.Trim());
            return code;
        }
        else
        {
            return "";
        }
        
    }

    public string CreateActivityPass()
    {
        string code = CreateSkiPass();
        Card card = new Card(code);
        string activityRegistJson = "";
        for (int i = 0; i < OrderDetails.Length; i++)
        {
            if (i == 0)
            {
                activityRegistJson = OrderDetails[i].memo.Trim();
            }
            else
            {
                activityRegistJson = activityRegistJson + ", " + OrderDetails[i].memo.Trim();
            }
        }
        activityRegistJson = "{\"regist_person\": [" + activityRegistJson + "]}";
        card.Memo = activityRegistJson;
        return code;
    }


}