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
    public string cellNumber = "";
    public string memberName = "";
    public string flowNumber = "";
    public string goodName = "";
    public DateTime orderDate = DateTime.MinValue;

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

    public int Save()
    {
        string[,] insertParams = { { "flow_number", "varchar", flowNumber.Trim()},
            {"good_name", "varchar", goodName.Trim()  },
            {"count", "int", count.ToString() },
            {"unit_price", "float", unitPrice.ToString() },
            {"deal_price", "float", saleSummary.ToString() }};
        int i = DBHelper.InsertData("order_details",insertParams);
        return i;
    }

   
}