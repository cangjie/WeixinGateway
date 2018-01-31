<%@ Page Language="C#" %>
<%@ Import Namespace="System.IO" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        StreamReader sr = new StreamReader(Request.InputStream);
        string paymentResult = sr.ReadToEnd();
        sr.Close();
        string status = Util.GetSimpleJsonValueByKey(paymentResult, "status").Trim();
        string out_trade_no = Util.GetSimpleJsonValueByKey(paymentResult, "out_trade_no").Trim();
        string notify_type = Util.GetSimpleJsonValueByKey(paymentResult, "notify_type").Trim();
        string syssn = Util.GetSimpleJsonValueByKey(paymentResult, "syssn").Trim();
        if (notify_type.Trim().Equals("payment") && status.Trim().Equals("1"))
        {
            OnlineOrder order = new OnlineOrder(int.Parse(out_trade_no));
            order.SetOrderPaySuccess(DateTime.Now, syssn.Trim());
            if (order.Type.Trim().Equals("雪票"))
            {
                order.CreateSkiPass();
            }
            if (order.Type.Trim().Equals("店销"))
            {
                OrderTemp tempOrder = OrderTemp.GetFinishedOrder(int.Parse(order._fields["id"].ToString()));
                //Ticket ticket = new Ticket(tempOrder._fields["ticket_code"].ToString().Trim());
                //ticket.Use(int.Parse(order._fields["id"].ToString()), "订单支付成功，此券核销。订单号：" + order._fields["id"].ToString());

                if (order.HaveFinishedShopSaleOrder())
                {
                    //OrderTemp orderTemp = new OrderTemp()

                    OrderTemp orderTmep = OrderTemp.GetFinishedOrder(int.Parse(order._fields["id"].ToString()));
                    string[] ticketCodeArr = orderTmep._fields["ticket_code"].ToString().Trim().Split(',');
                    foreach (string tickCode in ticketCodeArr)
                    {
                        Ticket ticket = new Ticket(tickCode.Trim());
                        ticket.Use(int.Parse(order._fields["id"].ToString()), "订单支付成功，此券核销。订单号：" + order._fields["id"].ToString());
                    }

                    ServiceMessage toCustomerMessage = new ServiceMessage();
                    toCustomerMessage.from = "";
                    toCustomerMessage.to = order._fields["open_id"].ToString();
                    toCustomerMessage.type = "text";
                    toCustomerMessage.content = "您的订单" + order.Memo.Trim() + "，已经支付成功，支付金额：" + order.OrderPrice.ToString() + "元，您获得龙珠：" + tempOrder._fields["generate_score"].ToString() + "颗。";
                    ServiceMessage.SendServiceMessage(toCustomerMessage);


                    ServiceMessage toSales = new ServiceMessage();
                    WeixinUser customer = new WeixinUser(order._fields["open_id"].ToString());
                    toSales.type = "text";
                    toSales.from = "";
                    toSales.to = tempOrder._fields["admin_open_id"].ToString();
                    toSales.content = customer.Nick.Trim() + " 的订单" + order.Memo.Trim() + "，已经支付成功，支付金额：" + order.OrderPrice.ToString() + "元。";
                    ServiceMessage.SendServiceMessage(toSales);
                    Point.AddNew(customer.OpenId.Trim(), int.Parse(tempOrder._fields["generate_score"].ToString()), DateTime.Now, "店内购买 订单号：" + order._fields["id"].ToString().Trim()
                        + "  " + order.Memo.Trim());
                }
            }
        }
        //File.AppendAllText(Server.MapPath("payment_result.txt"), paymentResult + "\r\n");
    }
</script>
SUCCESS