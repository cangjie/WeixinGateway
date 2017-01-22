<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string token = Util.GetSafeRequestValue(Request, "token", "76f9c1d2b003a306ec127e6d25c2bc98c16e3128251012f1d4e667832e2725899635eef1");
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

        Response.Write("{\"status\":0, \"charge_id\":" + chargeId.ToString() + " }");

    }
</script>