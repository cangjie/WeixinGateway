<%@ Page Language="C#" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string token = Util.GetSafeRequestValue(Request, "token", "7193fa1e90af61b264fe3989f1576b53a23cae5e157923fcedb37c693f8aaf110405a201");
        double marketPrice = double.Parse(Util.GetSafeRequestValue(Request, "marketprice", "0.01"));
        double salePrice = double.Parse(Util.GetSafeRequestValue(Request, "saleprice", "0.01"));
        double ticketAmount = double.Parse(Util.GetSafeRequestValue(Request, "ticketamount", "0"));
        string memo = Util.GetSafeRequestValue(Request, "memo", "测试店销产品");
        string payMethod = Util.GetSafeRequestValue(Request, "paymethod", "现金");
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

        if (!payMethod.Trim().Equals("现金"))
        {
            Response.Write("{\"status\": 1, \"err_msg\":\"Paymethod is not correct.\" }");
            Response.End();
        }

        int chargeId = OrderTemp.AddNewOrderTemp(customerOpenId, marketPrice, salePrice, ticketAmount, memo, currentUser.OpenId.Trim(), payMethod, shop,
            memberType, recommenderNumber, recommenderType, name, orderDetailJson, ticketCode, cell);



        if (customerOpenId.Trim().Equals(""))
        {
            string placeOrderCell = "00000000000";
            if (!cell.Trim().Equals(""))
            {
                placeOrderCell = cell.Trim();
            }
            WeixinUser tempUser = WeixinUser.GetTempWeixinUser(placeOrderCell);
            OrderTemp orderTemp = new OrderTemp(chargeId);
            int orderId = orderTemp.PlaceOnlineOrder(tempUser.OpenId.Trim());
            OnlineOrder order = new OnlineOrder(orderId);
            order.SetOrderPaySuccess(DateTime.Now, "cashpaid");
            Point.AddNew(tempUser.OpenId.Trim(), int.Parse(order._fields["generate_score"].ToString()), 
                DateTime.Now, "现金支付赠送龙珠，订单ID：" + order._fields["id"].ToString());
            Response.Write("{\"status\":0, \"order_id\":\"" + order._fields["id"].ToString() + "\", \"pay_method\": \"" + order.PayMethod.Trim() + "\"  }");
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
            order.SetOrderPaySuccess(DateTime.Now, "cashpaid");
            Response.Write("{\"status\":0, \"order_id\":\"" + order._fields["id"].ToString() + "\", \"pay_method\": \"" + order.PayMethod.Trim() + "\"  }");
        }

    }
</script>