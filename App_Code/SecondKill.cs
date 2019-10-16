using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Collections;

/// <summary>
/// Summary description for SecondKill
/// </summary>
public class SecondKill
{
    public struct SecondKillRecord
    {
        public string openId;
        public long killTimestamp;
        public int orderId;
        public bool isPaid;
    }

    public int id;
    public string name = "";
   
    public DateTime rackStartDate;
    public DateTime rackEndDate;
    public DateTime activityStartTime;
    public DateTime activityEndTime;
    public int inStockNum = 0;
    public int killNum = 0;
    public double activityPrice = 0;
    public double killingPrice = 0;
    public DataRow _fields;

    public Queue<SecondKillRecord> secondKillRecordList = new Queue<SecondKillRecord>();

    public SecondKill()
    {

    }

    public SecondKill(int id)
    {
        DataTable dt = DBHelper.GetDataTable(" select * from product left join product_second_kill on [id] = product_id "
            + " where [type] = '秒杀' and [id] = " + id.ToString());
        if (dt.Rows.Count == 1)
        {
            _fields = dt.Rows[0];
            this.id = id;
            name = _fields["name"].ToString().Trim();
            rackStartDate = DateTime.Parse(_fields["start_date"].ToString().Trim());
            rackEndDate = DateTime.Parse(_fields["end_date"].ToString().Trim());
            activityStartTime = DateTime.Parse(_fields["activity_start_time"].ToString().Trim());
            activityEndTime = DateTime.Parse(_fields["activity_end_time"].ToString().Trim());
            inStockNum = int.Parse(_fields["stock_num"].ToString().Trim());
            killNum = int.Parse(_fields["activity_count"].ToString().Trim());
            activityPrice = double.Parse(_fields["sale_price"].ToString().Trim());
            killingPrice = double.Parse(_fields["kill_price"].ToString().Trim());
        }
        else
        {
            throw new Exception("not found.");
        }
    }

    public bool Kill(string openId)
    {
        long nowExactTimeStamp = Util.GetExactTimeStamp(DateTime.Now);
        if (nowExactTimeStamp < ActivityStartExactTimeStamp || nowExactTimeStamp > ActivityEndExactTimeStamp)
        {
            return false;
        }
        if (secondKillRecordList.Count < killNum)
        {
            bool exists = false;
            foreach (SecondKillRecord r in secondKillRecordList)
            {
                if (r.openId.Trim().Equals(openId.Trim()))
                {
                    exists = true;
                    break;
                }
            }
            if (exists)
            {
                return false;
            }
            SecondKillRecord killRecord = new SecondKillRecord();
            killRecord.openId = openId;
            killRecord.killTimestamp = Util.GetExactTimeStamp(DateTime.Now);
            killRecord.isPaid = false;
            killRecord.orderId = 0;
            secondKillRecordList.Enqueue(killRecord);
            return true;
        }
        else
        {
            return false;
        }
    }

    public int PlaceOnlineOrder(string openId)
    {
        bool hasOrdered = false;
        bool overOrdered = false;
        DataTable dt = DBHelper.GetDataTable(" select * from order_online_detail left join order_online on order_online.[id] = order_online_detail.order_online_id "
                + " where product_id = " + id.ToString() + " ");
        if (dt.Rows.Count >= inStockNum)
        {
            overOrdered = true;
        }
        else
        {
            return -2;
        }
        if (!overOrdered)
        {
            foreach (DataRow dr in dt.Rows)
            {
                if (dr["open_id"].ToString().Trim().Equals(openId.Trim()))
                {
                    hasOrdered = true;
                    break;
                }
                else
                {
                    return -1;
                }
            }
        }
        dt.Dispose();
        if (!overOrdered && !hasOrdered)
        {
            OnlineOrder order = new OnlineOrder();
            OnlineOrderDetail detail = new OnlineOrderDetail();
            detail.productId = id;
            detail.productName = name.Trim();
            detail.price = activityPrice;
            detail.count = 1;
            order.AddADetail(detail);
            order.Type = "秒杀";
            order.shop = "崇礼";
            int orderId = order.Place(openId.Trim());
            return orderId;
        }
        return 0;
    }

    public int PlaceOnlineSecondKillOrder(string openId)
    {
        bool existsInCache = false;
        bool hasOrdered = false;
        bool overOrdered = false;
        foreach (SecondKillRecord sr in secondKillRecordList)
        {
            if (sr.openId.Trim().Equals(openId.Trim()))
            {
                existsInCache = true;
                break;
            }
        }
        if (existsInCache)
        {
            DataTable dt = DBHelper.GetDataTable(" select * from order_online_detail left join order_online on order_online.[id] = order_online_detail.order_online_id "
                + " where product_id = " + id.ToString() + " and pay_state <> -1 ");
            if (dt.Rows.Count >= killNum)
            {
                //hasOrdered = true;
                overOrdered = true;
            }
            if (!overOrdered)
            {
                foreach (DataRow dr in dt.Rows)
                {
                    if (dr["open_id"].ToString().Trim().Equals(openId.Trim()))
                    {
                        hasOrdered = true;
                        break;
                    }
                    else
                    {
                        return -1;
                    }
                }
            }
            dt.Dispose();
            if (overOrdered)
            {
                return -2;
            }
        }
        else
        {
            return -3;
        }
        if (existsInCache && !hasOrdered && !overOrdered)
        {
            OnlineOrder order = new OnlineOrder();
            OnlineOrderDetail detail = new OnlineOrderDetail();
            detail.productId = id;
            detail.productName = name.Trim();
            detail.price = killingPrice;
            detail.count = 1;
            order.AddADetail(detail);
            order.Type = "秒杀";
            order.shop = "崇礼";
            int orderId = order.Place(openId.Trim());
            return orderId;
        }
        return 0;
    }



    public long ActivityStartExactTimeStamp
    {
        get
        {
            return Util.GetExactTimeStamp(activityStartTime);
        }
    }

    public long ActivityEndExactTimeStamp
    {
        get
        {
            return Util.GetExactTimeStamp(activityEndTime);
        }
    }

    public bool CanKill
    {
        get
        {
            return (secondKillRecordList.Count < killNum);
        }
    }

    //public bool 

    
}