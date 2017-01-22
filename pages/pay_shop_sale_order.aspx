<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    public WeixinUser currentUser;
    public string openId = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        string orderId = Util.GetSafeRequestValue(Request, "orderid", "");
        string currentPageUrl = Server.UrlEncode("/pages/pay_shop_sale_order.aspx?orderid=" + orderId.Trim());
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

        Response.Redirect("/payment/haojin_pay_online_order.aspx?orderid=" + orderId.Trim(), true);

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
