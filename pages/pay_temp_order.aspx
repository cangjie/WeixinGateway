<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    public WeixinUser currentUser;

    public string openId = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            string currentPageUrl = Request.Url.LocalPath.Trim().ToString();
            if (Session["user_token"] == null || Session["user_token"].ToString().Trim().Equals(""))
            {
                Response.Redirect("../authorize.aspx?callback=" + currentPageUrl, true);
            }
            string userToken = Session["user_token"].ToString();
            openId = WeixinUser.CheckToken(userToken);
            if (openId.Trim().Equals(""))
            {
                Response.Redirect("../authorize.aspx?callback=" + currentPageUrl, true);
            }

            int tempOrderId = int.Parse(Util.GetSafeRequestValue(Request, "temporderid", "0"));

            OrderTemp orderTemp = new OrderTemp(tempOrderId);
            int orderId = orderTemp.PlaceOnlineOrder(openId);
            OnlineOrder order = new OnlineOrder(orderId);
            if (order._fields["pay_method"].ToString().Equals("微信"))
            {
                Response.Redirect("/payment/payment.aspx?product_id=" + orderId.ToString(), true);
            }
        }
        catch
        {
            Response.Write("二维码已失效，请联系店员刷新此付款二维码。");
        }


    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
    </div>
    </form>
</body>
</html>
