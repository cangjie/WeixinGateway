<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string token = Util.GetSafeRequestValue(Request, "token", "eb3342153da97dee7cd3f39cdfe42a16ec5b35f5acd3c4f15e4f15b948ff1fe67c2388dc");
        int tempOrderId = int.Parse(Util.GetSafeRequestValue(Request, "temporderid", "37"));
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