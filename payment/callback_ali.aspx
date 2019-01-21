<%@ Page Language="C#" %>
<%@ Import Namespace="System.IO" %>
<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string str = new System.IO.StreamReader(Request.InputStream).ReadToEnd();
        //str = "code=10000&msg=Success&trade_status=TRADE_SUCCESS&app_id=2019011010661559&buyer_user_id=2088002319285895&buyer_logon_id=2088002319285895&buyer_pay_amount=0.01&receipt_amount=0.01&total_amount=0.01&trade_no=2019012022001485891013080141&out_trade_no=3078&store_name=%E5%8C%97%E4%BA%AC%E6%98%93%E9%BE%99%E9%9B%AA%E8%81%9A%E6%BB%91%E9%9B%AA%E7%94%A8%E5%93%81%E5%BA%97&charset=utf-8&version=1.0&gmt_payment=2019-01-20+23%3A34%3A19&fund_bill_list=%5B%7B%22fund_channel%22%3A%22LCSW%22%2C%22amount%22%3A0.01%7D%5D&sign=sJsdatn0bB78ETdBaParu2IkSPLVKhtn1xXtuqq3Ifor9gimeV0eS4TgLwhTV3KoQVn6K%2B%2BFVP9zDFFyBqJ6%2BtA0QAFEw9DcvAdNTdYq1XUg7ke2fZnEJIujpaFgDmTf6vokwd%2BJyk1MB0SrgPoyFwEXAumIw6wnY2E3ca3QGOY%3D";
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
