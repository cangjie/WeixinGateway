﻿using System;
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
                    {"order_real_pay_price", "float", OrderPrice.ToString() } };
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
            return "雪票";
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
            double price = 0;
            foreach (OnlineOrderDetail detail in OrderDetails)
            {
                price = price + detail.summary;
            }
            return price;
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
            string code = Card.GenerateCardNo(9, 0, "雪票");
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


}