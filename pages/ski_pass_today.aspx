<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    public string openId = "";
    public WeixinUser currentUser;
    public string token = "";
    public int productId = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        productId = int.Parse(Util.GetSafeRequestValue(Request, "productid", "5").Trim());
        string currentPageUrl = Server.UrlEncode("/pages/ski_pass_today.aspx");
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
        currentUser = new WeixinUser(WeixinUser.CheckToken(userToken));
        token = userToken.Trim();
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="js/jquery.min.js"></script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
    </div>
    </form>
</body>
</html>
<script type="text/javascript" >
    var cart_json = '{ "cart_array": [{ "product_id": "<%=productId.ToString()%>", "count": "1" }], "memo": { "rent": "0", "use_date": "<%=DateTime.Now.ToShortDateString()%>" } }';
    $.ajax({
                url: "/api/place_online_order.aspx",
                async: false,
                type: "GET",
                data: { "cart": cart_json, "token": "<%=token%>" },
                success: function(msg, status) {
                    var msg_object = eval("(" + msg + ")");
                    window.location.href = "../payment/haojin_pay_online_order.aspx?orderid=" + msg_object.order_id;
                }
            });
</script>

