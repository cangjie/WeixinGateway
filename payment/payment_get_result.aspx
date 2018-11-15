<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {

        string token = Util.GetSafeRequestValue(Request, "token", "");
        int orderId = int.Parse(Util.GetSafeRequestValue(Request, "orderid", "0"));
        OnlineOrder order = new OnlineOrder(orderId);
        string openId = WeixinUser.CheckToken(token);
        if (!order._fields["owner"].ToString().Trim().Equals(openId.Trim()))
        {
            Response.End();
        }
        if (order._fields["state"].ToString().Equals("2"))
        {
            Response.Write("支付成功");
        }
        else
        {
            Response.Write("支付尚未成功");
        }
        /*
        string body = Util.GetSafeRequestValue(Request, "body", "卢勤问答平台微课教室");
        int productId = int.Parse(Util.GetSafeRequestValue(Request, "productid", "10000681"));
        int amount = int.Parse(Util.GetSafeRequestValue(Request, "amount", "198"));
        Order order = Order.GetOrderByOriginInfo(body, productId, amount);
        if (order.Status == 2)
        {
            Response.Write("PAID");
        }
        else
        {
            Response.Write("UNPAID");
        }
        */
    }
</script>