<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string token = Util.GetSafeRequestValue(Request, "token", "01127366f2f219f3578b75fbd32a3bb2f200ac7fcf3051fa5bf5515f0321f86e43592f6e");
        double marketPrice = double.Parse(Util.GetSafeRequestValue(Request, "marketprice", "2"));
        double salePrice = double.Parse(Util.GetSafeRequestValue(Request, "saleprice", "1.9"));
        double ticketAmount = double.Parse(Util.GetSafeRequestValue(Request, "ticketamount", "0"));
        string memo = Util.GetSafeRequestValue(Request, "memo", "测试店销产品");
        string openId = WeixinUser.CheckToken(token);
        WeixinUser currentUser = new WeixinUser(openId);

        if (!currentUser.IsAdmin)
        {
            Response.Write("{\"status\":1, \"err_msg\":\"Is not admin.\" }");
            Response.End();
        }

        int chargeId = OrderTemp.AddNewOrderTemp(marketPrice, salePrice, ticketAmount, memo, openId);
        Response.Write("{\"status\":0, \"charge_id\":\"4294" + chargeId.ToString().PadLeft(6,'0') + "\" }");

    }
</script>