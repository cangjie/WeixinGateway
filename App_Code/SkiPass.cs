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
        bool inAvaDays = false;
        bool inUnAvaDays = false;

        if (_fields["available_days"].ToString().Trim().Equals(""))
        {
            inAvaDays = true;
        }
        else
        {
            inAvaDays = Util.InDate(currentDate, _fields["available_days"].ToString().Trim());
        }

        if (_fields["unavailable_days"].ToString().Trim().Equals(""))
        {
            inUnAvaDays = false;
        }
        else
        {
            inUnAvaDays = Util.InDate(currentDate, _fields["unavailable_days"].ToString().Trim());
        }
        return inAvaDays && !inUnAvaDays;
            
    }

}