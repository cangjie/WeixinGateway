<%@ Page Language="C#" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string token = Util.GetSafeRequestValue(Request, "token", "");
        double marketPrice = double.Parse(Util.GetSafeRequestValue(Request, "marketprice", "2"));
        double salePrice = double.Parse(Util.GetSafeRequestValue(Request, "saleprice", "1.9"));
        double ticketAmount = double.Parse(Util.GetSafeRequestValue(Request, "ticketamount", "0"));
        //string memo = Util.GetSafeRequestValue(Request, "memo", "测试店销产品");
        string payMethod = Util.GetSafeRequestValue(Request, "paymethod", "微信");
        string shop = Util.GetSafeRequestValue(Request, "shop", "南山");
        string openId = WeixinUser.CheckToken(token);
        string memberType = Util.GetSafeRequestValue(Request, "membertype", "");
        string recommenderNumber = Util.GetSafeRequestValue(Request, "recommendernumber", "");
        string recommenderType = Util.GetSafeRequestValue(Request, "recommendertype", "");
        string name = Util.GetSafeRequestValue(Request, "name", "");
        string orderDetailJson = Util.GetSafeRequestValue(Request, "reforderdetail", "");
        string ticketCode = Util.GetSafeRequestValue(Request, "ticketcode", "");
        string customerOpenId = Util.GetSafeRequestValue(Request, "openid", "");
        string cell = Util.GetSafeRequestValue(Request, "cell", "").Trim();
        string customerMemo =  Util.GetSafeRequestValue(Request, "customermemo", "");
        WeixinUser currentUser = new WeixinUser(openId);

        if (!currentUser.IsAdmin)
        {
            Response.Write("{\"status\":1, \"err_msg\":\"Is not admin.\" }");
            Response.End();
        }



        int chargeId = OrderTemp.AddNewOrderTemp(customerOpenId, marketPrice, salePrice, ticketAmount, customerMemo, openId, payMethod, shop,
            memberType, recommenderNumber, recommenderType, name, orderDetailJson, ticketCode, cell, currentUser.OpenId.Trim());
        //if (payMethod.Trim().Equals("现金") || payMethod.Trim().Equals("刷卡"))
        if (customerOpenId.Trim().Equals(""))
        {
            if (payMethod.Trim().Equals("微信"))
            {
                Response.Write("{\"status\":0, \"charge_id\":\"4294" + chargeId.ToString().PadLeft(6, '0') + "\", \"temp_order_id\":" + chargeId.ToString()
                    + ", \"pay_method\": \"" + payMethod.Trim() + "\" }");
            }
            else if (payMethod.Trim().Equals("支付宝"))
            {
                if (cell.Length == 11 && (cell.StartsWith("13") || cell.StartsWith("15") || cell.StartsWith("18")))
                {
                    WeixinUser tempUser = WeixinUser.GetTempWeixinUser(cell.Trim());
                    OrderTemp orderTemp = new OrderTemp(chargeId);
                    int orderId = orderTemp.PlaceOnlineOrder(tempUser.OpenId.Trim());
                    OnlineOrder order = new OnlineOrder(orderId);
                    Response.Write("{\"status\":0, \"order_id\":\"" + order._fields["id"].ToString() + "\", \"pay_method\": \"" + order.PayMethod.Trim() + "\"  }");
                }
            }
            else
            {

            }
        }
        else
        {
            WeixinUser customer = new WeixinUser(customerOpenId.Trim());
            customer.Memo = customerMemo.Trim();
            try
            {
                if (!cell.Trim().Equals(""))
                {
                    customer.CellNumber = cell.Trim();
                    customer.VipLevel = 1;

                }
            }
            catch
            {

            }
            OrderTemp orderTemp = new OrderTemp(chargeId);
            int orderId = orderTemp.PlaceOnlineOrder(customerOpenId.Trim());
            OnlineOrder order = new OnlineOrder(orderId);
            Response.Write("{\"status\":0, \"order_id\":\"" + order._fields["id"].ToString() + "\", \"pay_method\": \"" + order.PayMethod.Trim() + "\"  }");
        }

    }
</script>