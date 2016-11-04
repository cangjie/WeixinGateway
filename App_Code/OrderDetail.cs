using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for OrderDetail
/// </summary>
public class OrderDetail
{

    public double unitPrice = 0;
    public double count = 0;
    public double salePrice = 0;
    public double saleSummary = 0;
    public int usedDragonBallCount = 0;
    public double usedTicketAmount = 0;

    public OrderDetail()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public bool IsValid
    {
        get
        {
            if (saleSummary != 0 && salePrice != 0)
                return true;
            else
                return false;
        }
    }
}