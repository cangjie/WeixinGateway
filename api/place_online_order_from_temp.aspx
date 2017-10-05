<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string token = Util.GetSafeRequestValue(Request, "token", "7d3169bf564fd1a6a86d98dcf828509363231e100d58f2c219f082e28d06877c1a92a219");
        int tempOrderId = int.Parse(Util.GetSafeRequestValue(Request, "temporderid", "33"));
        string openId = WeixinUser.CheckToken(token);
        OrderTemp orderTemp = new OrderTemp(tempOrderId);
        DBHelper.UpdateData("order_online_temp", new string[,] { { "customer_open_id", "varchar", openId.Trim() } },
            new string[,] { { "id", "int", orderTemp._fields["id"].ToString().Trim() } }, Util.conStr.Trim());
        int orderId = orderTemp.PlaceOnlineOrder(openId);
        if (orderId > 0)
        {
            OnlineOrder order = new OnlineOrder(orderId);
            Response.Write("{\"status\": 0, \"order_id\": " + orderId.ToString()+", \"pay_method\": \"" + order.PayMethod.Trim()  + "\"}");
        }
        else
            Response.Write("{\"status\": 1}");
    }
</script>