<%@ Page Language="C#" %>
<%@ Import Namespace="System.IO" %>
<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        //string str = new System.IO.StreamReader(Request.InputStream).ReadToEnd();
        string str = "code=10000&msg=Success&trade_status=TRADE_SUCCESS&app_id=2019011010661559&buyer_user_id=2088002319285895&buyer_logon_id=2088002319285895&buyer_pay_amount=1&receipt_amount=1&total_amount=1&trade_no=2019012022001485891013142701&out_trade_no=1547989454&store_name=%E5%8C%97%E4%BA%AC%E6%98%93%E9%BE%99%E9%9B%AA%E8%81%9A%E6%BB%91%E9%9B%AA%E7%94%A8%E5%93%81%E5%BA%97&charset=utf-8&version=1.0&gmt_payment=2019-01-20+21%3A04%3A59&fund_bill_list=%5B%7B%22fund_channel%22%3A%22LCSW%22%2C%22amount%22%3A1%7D%5D&sign=g2lFWiVbC7zHH0ay078cF0IFlCUA%2FV7sHtGJgmJJUhcr%2BZtn%2BD4b%2Ff7TlmC3ct2Tvot%2F%2FYFquu97xDuyTrth6Dn8N6S0%2BiRSrrrqiaN%2FJ1DTBrAhmafCA6eX0k%2BxVh9yWmm9icHhQJ%2FmKUMrwufev0FTeRmLUvApfQ4hkjFcO%2F0%3D";
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
                                    catch
                                    {

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
