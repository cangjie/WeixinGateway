<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string token = Util.GetSafeRequestValue(Request, "token", "01cd7e34e23378e5cea4cabf22493f0a966b09b54977d62955a8f6e8656668be17780592");
        double marketPrice = double.Parse(Util.GetSafeRequestValue(Request, "marketprice", "1"));
        double salePrice = double.Parse(Util.GetSafeRequestValue(Request, "saleprice", "0.85"));
        double ticketAmount = double.Parse(Util.GetSafeRequestValue(Request, "ticketamount", "0"));
        string memo = Util.GetSafeRequestValue(Request, "memo", "");
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