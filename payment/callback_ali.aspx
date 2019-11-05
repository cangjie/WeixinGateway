<%@ Page Language="C#" %>
<%@ Import Namespace="System.IO" %>
<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string str = new System.IO.StreamReader(Request.InputStream).ReadToEnd();
        if (str.Trim().Equals(""))
        {
            str = "code=10000&msg=Success&trade_status=TRADE_SUCCESS&app_id=2019011010661559&buyer_user_id=2088002319285895&buyer_logon_id=2088002319285895&buyer_pay_amount=0.01&receipt_amount=0.01&total_amount=0.01&trade_no=2019032022001485891025730502&out_trade_no=4664&store_name=%E5%8C%97%E4%BA%AC%E6%98%93%E9%BE%99%E9%9B%AA%E8%81%9A%E6%BB%91%E9%9B%AA%E7%94%A8%E5%93%81%E5%BA%97&charset=utf-8&version=1.0&gmt_payment=2019-03-20+16%3A18%3A08&fund_bill_list=%5B%7B%22fund_channel%22%3A%22LCSW%22%2C%22amount%22%3A0.01%7D%5D&sign=bvskiT1q32e3OElefoxpcrw1PSR67Oc3dsN7kS5T%2FEga6k2nZzG%2FetTW5jzyiwXqAqJEbRCJeKkNnEju6n2ynAwHM1qSoB0feSkTRR8KBDjsZbuaqwGpOuJ%2FgTAGLz4mz3sQAX7rGY9QpU7O8fOzs9%2B3gGJVizY%2BEAuVAHaoxh4%3D";
        }
        try
        {
            try
            {
                File.AppendAllText(Server.MapPath("../log/payment_callback_ali.txt"), str + "\r\n");
            }
            catch
            {

            }
            string[] callBackMsgArr = str.Split('&');
            string orderId = "";
            foreach (string msg in callBackMsgArr)
            {
                if (msg.Trim().StartsWith("out_trade_no="))
                {
                    orderId = msg.Split('=')[1].Trim();
                    break;
                }
            }
            if (!orderId.Trim().Equals(""))
            {
                foreach(string msg in callBackMsgArr)
                {
                    if (msg.Trim().StartsWith("trade_status=TRADE_SUCCESS"))
                    {
                        try
                        {
                            string tradeNo = "";
                            foreach (string s in callBackMsgArr)
                            {
                                if (s.Trim().StartsWith("trade_no="))
                                {
                                    tradeNo = s.Split('=')[1].Trim();
                                    break;
                                }
                            }
                            OnlineOrder order = new OnlineOrder(int.Parse(orderId.Trim()));
                            if (order._fields["pay_state"].ToString().Trim().Equals("0"))
                            {
                                order.SetOrderPaySuccess(DateTime.Now, tradeNo);

                                try
                                {
                                    Point.AddNew(order._fields["open_id"].ToString(), int.Parse(order._fields["generate_score"].ToString()), DateTime.Now, "店内购买 订单号：" + order._fields["id"].ToString().Trim()
                                        + "  " + order.Memo.Trim());
                                }
                                catch
                                {

                                }



                                string[] ticketCodeArr = order._fields["ticket_code"].ToString().Trim().Split(',');
                                foreach (string tickCode in ticketCodeArr)
                                {
                                    if (tickCode.Trim().Equals(""))
                                    {
                                        continue;
                                    }
                                    try
                                    {
                                        Ticket ticket = new Ticket(tickCode.Trim());
                                        ticket.Use("订单支付成功，此券核销。订单号：" + order._fields["id"].ToString());
                                    }
                                    catch(Exception err)
                                    {
                                        Response.Write(err.ToString());
                                    }
                                }
                            }
                        }
                        catch
                        {

                        }
                    }

                }
            }
        }
        catch
        {

        }
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
    </div>
    </form>
</body>
</html>
