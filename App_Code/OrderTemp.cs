﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
/// <summary>
/// Summary description for OrderTemp
/// </summary>
public class OrderTemp
{
    public DataRow _fields;
    public OrderTemp()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public OrderTemp(int id)
    {
        DataTable dt = DBHelper.GetDataTable(" select * from order_online_temp where [id] =  " + id.ToString());
        _fields = dt.Rows[0];
    }


    public int PlaceOnlineOrder(string openId)
    {
        try
        {
            int.Parse(_fields["online_order_id"].ToString());
            return 0;
        }
        catch
        {
            
        }
        OnlineOrder newOrder = new OnlineOrder();
        WeixinUser user = new WeixinUser(openId);
        string[,] insertParam = { {"type", "varchar", "店销" }, { "open_id", "varchar", openId.Trim() },
        {"cell_number", "varchar", user.CellNumber.Trim() }, {"name", "varchar", user.Nick.Trim() }, 
        {"pay_method", "varchar", "haojin" },{ "pay_state", "int", "1" },
        {"order_price", "float", _fields["market_price"].ToString() }, 
        {"order_real_pay_price", "float", _fields["real_paid_price"].ToString() }, {"memo", "varchar", _fields["memo"].ToString().Trim() },
        {"pay_time", "datetime", DateTime.Now.ToString() } };
        int i = DBHelper.InsertData("order_online", insertParam);
        if (i == 1)
        {
            i = DBHelper.GetMaxId("order_online");
        }
        string[,] updateParam = { { "online_order_id", "int", i.ToString() } };
        string[,] keyParam = { {"id", "int", _fields["id"].ToString() } };
        DBHelper.UpdateData("order_online_temp", updateParam, keyParam, Util.conStr);
        return i;
    }
    
    public void FinishOrder()
    {
        string[,] updateParam = { {"is_paid", "int", "1" }, {"pay_date_time", "datetime", DateTime.Now.ToString()} };
        string[,] keyParam = { { "id", "int", _fields["id"].ToString() } };
        DBHelper.UpdateData("order_online_temp", updateParam, keyParam, Util.conStr);
    }

    public static int AddNewOrderTemp(double marketPrice, double salePrice, double ticketAmount, string memo, string openId)
    {
        double realPayPrice = salePrice - ticketAmount;
        double scoreRate = GetScoreRate(realPayPrice, marketPrice);
        int generateScore = (int)(realPayPrice * scoreRate);
        string[,] insertParam = { { "admin_open_id", "varchar", openId }, {"market_price", "float", Math.Round(marketPrice,2).ToString() },
        {"sale_price", "float", Math.Round(salePrice, 2).ToString() }, {"real_paid_price", "float", Math.Round(realPayPrice, 2).ToString() },
        {"ticket_amount", "float", Math.Round(ticketAmount, 2).ToString() }, {"score_rate", "float", Math.Round(scoreRate, 2).ToString() }, 
        {"generate_score", "int", generateScore.ToString() }, {"memo", "varchar", memo.Trim() }, 
        {"is_paid", "int", "1" }, {"pay_date_time", "datetime", DateTime.Now.ToString() } };
        int i = DBHelper.InsertData("order_online_temp", insertParam);
        if (i == 1)
        {
            DataTable dt = DBHelper.GetDataTable(" select max([id]) from order_online_temp ");
            i = int.Parse(dt.Rows[0][0].ToString());
            dt.Dispose();
        }
        return i;
    }

    public static OrderTemp GetFinishedOrder(int orderId)
    {
        OrderTemp tempOrder = new OrderTemp();
        DataTable dt = DBHelper.GetDataTable(" select * from order_online_temp where online_order_id = "
            + orderId.ToString() + " order by [id] desc");
        if (dt.Rows.Count > 0)
        {
            tempOrder = new OrderTemp(int.Parse(dt.Rows[0]["id"].ToString()));
        }
        dt.Dispose();
        return tempOrder;
    }

    public static double GetScoreRate(double realPayPrice, double marketPrice)
    {
        double disCountRate = realPayPrice / marketPrice;
        double rate = 0;
        if (disCountRate == 1)
            rate = 1;
        else if (disCountRate >= 0.95)
            rate = 0.925;
        else if (disCountRate >= 0.9)
            rate = 0.85;
        else if (disCountRate >= 0.85)
            rate = 0.775;
        else if (disCountRate >= 0.8)
            rate = 0.7;
        else if (disCountRate >= 0.75)
            rate = 0.625;
        else if (disCountRate >= 0.7)
            rate = 0.55;
        else if (disCountRate >= 0.65)
            rate = 0.475;
        else if (disCountRate >= 0.6)
            rate = 0.4;
        else if (disCountRate >= 0.55)
            rate = 0.325;
        else if (disCountRate >= 0.5)
            rate = 0.25;
        else if (disCountRate >= 0.45)
            rate = 0.175;
        else if (disCountRate >= 0.4)
            rate = 0.1;
        else
            rate = 0;
        return rate;
    }
}