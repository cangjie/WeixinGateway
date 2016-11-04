using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for Order
/// </summary>
public class Order
{
    public OrderDetail[] orderDetails;
    public int startIndex = 0;
    public string flowNumber = "";
    private double orderPrice = 0;
    private double orderShouldPaidAmount = 0;
    private double usedDragonBallCount = 0;
    private double usedTicketAmount = 0;
    private double realPaidAmount = 0;
    private double disCountRate = 0;
    private double dragonBallRate = 0;
    private int generateDragonBallCount = 0;
    


    public Order()
    {
        
    }

    public double OrderPrice
    {
        get
        {
            orderPrice = 0;
            foreach (OrderDetail detail in orderDetails)
            {
                orderPrice = orderPrice + detail.unitPrice * detail.count;
            }
            return orderPrice;
        }
    }

    public double OrderShouldPaidAmount
    {
        get
        {
            orderShouldPaidAmount = 0;
            foreach (OrderDetail detail in orderDetails)
            {
                orderShouldPaidAmount = orderShouldPaidAmount + detail.saleSummary;
            }
            return orderShouldPaidAmount;
        }
    }

    public double UsedDragonBallCount
    {
        get
        {
            usedDragonBallCount = 0;
            foreach (OrderDetail detail in orderDetails)
            {
                usedDragonBallCount = usedDragonBallCount + detail.usedDragonBallCount;
            }
            return usedDragonBallCount;
        }
    }

    public double UsedTicketAmount
    {
        get
        {
            usedTicketAmount = 0;
            foreach (OrderDetail detail in orderDetails)
            {
                usedTicketAmount = usedTicketAmount + detail.usedTicketAmount;
            }
            return usedTicketAmount;
        }
    }

    public double RealPaidAmount
    {
        get
        {
            return OrderShouldPaidAmount - UsedTicketAmount - UsedDragonBallCount / 10;
        }
    }

    public double DisCountRate
    {
        get
        {
            return Math.Round(OrderShouldPaidAmount / OrderPrice, 4);
        }
    }

    public double DragonBallRate
    {
        get
        {
            double rate = 0;
            double disCountRate = DisCountRate;
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



    public int GenerateDraonBallCount
    {
        get
        {
            return (int)(RealPaidAmount*DragonBallRate);
        }
    }

    public void AddItem(OrderDetail orderDetail)
    {
        OrderDetail[] newOrderDetails;// = new OrderDetail[orderDetails.Length + 1];
        if (orderDetails == null)
            newOrderDetails = new OrderDetail[1];
        else
            newOrderDetails = new OrderDetail[orderDetails.Length + 1];
        for (int i = 0; i < newOrderDetails.Length; i++)
        {
            if (i < newOrderDetails.Length-1)
            {
                newOrderDetails[i] = orderDetails[i];
            }
            else
            {
                newOrderDetails[i] = orderDetail;
            }
        }
        orderDetails = newOrderDetails;
    }
}