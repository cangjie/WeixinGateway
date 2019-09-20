using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

/// <summary>
/// Summary description for ResortTicket
/// </summary>
public class ResortTicket
{
    public DataRow _fields;

    public int id = 0;

    public ResortTicket()
    {

    }

    public ResortTicket(int id)
    {
        //
        // TODO: Add constructor logic here
        //
        DataTable dt = DBHelper.GetDataTable(" select * from product left join product_resort_ticket on product.[id] = product_id and product.[type] = '雪票' where product.[id] = " + id.ToString());
        if (dt.Rows.Count == 1)
        {
            _fields = dt.Rows[0];
            this.id = id;
        }
    }

    public int stockNum
    {
        get
        {
            return int.Parse(_fields["stock_num"].ToString().Trim());
        }
    }

    public bool inStock
    {
        get
        {
            if (stockNum == -1 || stockNum > 0)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
    }

    public DateTime startDate
    {
        get
        {
            return DateTime.Parse(_fields["start_date"].ToString());
        }
    }

    public DateTime endDate
    {
        get
        {
            return DateTime.Parse(_fields["end_date"].ToString());
        }
    }

    public bool isHide
    {
        get
        {
            if (int.Parse(_fields["hidden"].ToString().Trim()) == 0)
            {
                return false;
            }
            else
            {
                return true;
            }
        }
    }

    public bool isOnline
    {
        get
        {
            if (DateTime.Now.Date >= startDate && DateTime.Now.Date <= endDate)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
    }

    public bool IsAvailableDay(DateTime currentDate)
    {
        string[] dayDescItems = _fields["available_days"].ToString().Trim().Split(',');
        if (dayDescItems.Length == 0)
        {
            return true;
        }
        foreach (string day in dayDescItems)
        {
            if (day.Trim().Equals("周六"))
            {
                if (currentDate.DayOfWeek == DayOfWeek.Saturday)
                {
                    return true;
                }
            }
            if (day.Trim().Equals("周日"))
            {
                if (currentDate.DayOfWeek == DayOfWeek.Sunday)
                {
                    return true;
                }
            }
            if (day.IndexOf("--") >= 0)
            {
                try
                {
                    DateTime startDate = DateTime.Parse(day.Replace("--", "#").Split('#')[0].Trim());
                    DateTime endDate  = DateTime.Parse(day.Replace("--", "#").Split('#')[1].Trim());
                    if (currentDate.Date >= startDate && currentDate.Date <= endDate)
                    {
                        return true;
                    }
                }
                catch
                {

                }
            }
            try
            {
                if (currentDate.Date == DateTime.Parse(day.Trim()))
                {
                    return true;
                }
            }
            catch
            {

            }
        }
        return false;
    }


    public bool CanShowToBeOrdered(DateTime currentDate)
    {
        return inStock && !isHide && isOnline;
    }



    public static ResortTicket[] GetAll()
    {
        DataTable dt = DBHelper.GetDataTable(" select * from product left join product_resort_ticket on product.[id] = product_id and product.[type] = '雪票' order by sort desc ");
        ResortTicket[] resortTicketsArr = new ResortTicket[dt.Rows.Count];
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            resortTicketsArr[i] = new ResortTicket();
            resortTicketsArr[i].id = int.Parse(dt.Rows[i]["id"].ToString().Trim());
            resortTicketsArr[i]._fields = dt.Rows[i];
        }
        return resortTicketsArr;
    } 



}