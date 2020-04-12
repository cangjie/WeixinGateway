<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        int orderId = int.Parse(Util.GetSafeRequestValue(Request, "orderid", "0"));
        OnlineOrder order = new OnlineOrder(orderId);

        switch (order.Type.Trim())
        {
            case "雪票":
                Response.Redirect("../pages/ski_pass_list.aspx", true);
                break;
            case "服务卡":
                string code = order._fields["code"].ToString();
                Response.Redirect("../pages/service_card_detail.aspx?code=" + code.Trim(), true);
                break;
            default:
                Response.Redirect("../pages/dragon_ball_list.aspx", true);
                break;
        }

        if (order.Type.Trim().Equals("雪票"))
        {
            //order.CreateSkiPass();
            Response.Redirect("../pages/ski_pass_list.aspx", true);
        }
        else
        {
            Response.Redirect("../pages/dragon_ball_list.aspx", true);
        }

        /*

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

        */
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