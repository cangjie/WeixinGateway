using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

/// <summary>
/// Summary description for SkiPass
/// </summary>
public class SkiPass
{
    public DataRow _fields;

    public SkiPass()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public SkiPass(int id)
    {
        
    }

    public int StockNum
    {
        get
        {
            return int.Parse(_fields["stock_num"].ToString().Trim());
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
                    DateTime endDate = DateTime.Parse(day.Replace("--", "#").Split('#')[1].Trim());
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

}