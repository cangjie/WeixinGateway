<%@ Page Language="C#" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Xml" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {




        string str = new System.IO.StreamReader(Request.InputStream).ReadToEnd();
        if (str.Trim().Equals(""))
        {
            str = "<xml><appid><![CDATA[wxf91253fd1c38d24e]]></appid><bank_type><![CDATA[CMB_CREDIT]]></bank_type><cash_fee>1</cash_fee><fee_type><![CDATA[CNY]]></fee_type><is_subscribe><![CDATA[Y]]></is_subscribe><mch_id>1517744411</mch_id><nonce_str><![CDATA[b6wr4s9y9orwazks1k8n4sdhjwjy7ih]]></nonce_str><openid><![CDATA[oZBHkjhdFpC5ScK5FUU7HKXE3PJM]]></openid><out_trade_no>1553071018004666</out_trade_no><result_code><![CDATA[SUCCESS]]></result_code><return_code><![CDATA[SUCCESS]]></return_code><time_end>20190320163703</time_end><total_fee>1</total_fee><trade_type><![CDATA[JSAPI]]></trade_type><transaction_id>4200000246201903201062722607</transaction_id><sign><![CDATA[37FBEB312B10C734BFA0297AFE2405BB]]></sign></xml>";
        }
        try
        {
            File.AppendAllText(Server.MapPath("../log/payment_callback.txt"), str + "\r\n");
        }
        catch
        {

        }
        XmlDocument xmlD = new XmlDocument();
        xmlD.LoadXml(str);
        WeixinPaymentOrder order = new WeixinPaymentOrder(xmlD.SelectSingleNode("//xml/out_trade_no").InnerText.Trim());
        if (xmlD.SelectSingleNode("//xml/result_code").InnerText.Trim().ToUpper().Equals("SUCCESS") &&
            xmlD.SelectSingleNode("//xml/return_code").InnerText.Trim().ToUpper().Equals("SUCCESS"))
        {

            order.Status = 2;
            try
            {
                OnlineOrder onlineOrder = new OnlineOrder(int.Parse(order._fields["order_product_id"].ToString()));
                if (onlineOrder._fields["pay_state"].ToString().Equals("0"))
                {
                    onlineOrder.SetOrderPaySuccess(DateTime.Now, xmlD.SelectSingleNode("//xml/transaction_id").InnerText.Trim());
                    onlineOrder = new OnlineOrder(int.Parse(order._fields["order_product_id"].ToString()));
                    if (onlineOrder.Type.Trim().Equals("雪票"))
                    {
                        onlineOrder.CreateSkiPass();
                    }

                    if (onlineOrder.Type.Trim().Equals("店销"))
                    {
                        OrderTemp tempOrder = OrderTemp.GetFinishedOrder(int.Parse(onlineOrder._fields["id"].ToString()));
                        if (onlineOrder._fields["pay_state"].ToString().Equals("1") )
                        {
                            string[] ticketCodeArr = tempOrder._fields["ticket_code"].ToString().Trim().Split(',');
                            foreach (string tickCode in ticketCodeArr)
                            {
                                if (tickCode.Trim().Equals(""))
                                {
                                    continue;
                                }
                                try
                                {
                                    Ticket ticket = new Ticket(tickCode.Trim());
                                    ticket.Use("订单支付成功，此券核销。订单号：" + onlineOrder._fields["id"].ToString());
                                }
                                catch(Exception err)
                                {
                                    Response.Write(err.ToString() + "<br/>");
                                }
                            }
                            ServiceMessage toCustomerMessage = new ServiceMessage();
                            toCustomerMessage.from = "";
                            toCustomerMessage.to = order._fields["order_openid"].ToString();
                            toCustomerMessage.type = "text";
                            toCustomerMessage.content = "您的订单" + onlineOrder.Memo.Trim() + "，已经支付成功，支付金额：" + onlineOrder.OrderPrice.ToString() + "元，您获得龙珠：" + tempOrder._fields["generate_score"].ToString() + "颗。";
                            ServiceMessage.SendServiceMessage(toCustomerMessage);


                            ServiceMessage toSales = new ServiceMessage();
                            WeixinUser customer = new WeixinUser(order._fields["order_openid"].ToString());
                            toSales.type = "text";
                            toSales.from = "";
                            toSales.to = tempOrder._fields["admin_open_id"].ToString();
                            toSales.content = customer.Nick.Trim() + " 的订单" + onlineOrder.Memo.Trim() + "，已经支付成功，支付金额：" + onlineOrder.OrderPrice.ToString() + "元。";
                            ServiceMessage.SendServiceMessage(toSales);
                            if (int.Parse(tempOrder._fields["generate_score"].ToString()) > 0)
                            {
                                Point.AddNew(customer.OpenId.Trim(), int.Parse(tempOrder._fields["generate_score"].ToString()), DateTime.Now, "店内购买 订单号：" + order._fields["order_product_id"].ToString().Trim()
                                    + "  " + onlineOrder.Memo.Trim());
                            }
                        }
                    }
                }




            }
            catch
            {

            }
        }
        else
        {
            order.Status = -1;
        }

    }
</script>
<xml>
   <return_code><![CDATA[SUCCESS]]></return_code>
   <return_msg><![CDATA[OK]]></return_msg>
</xml>