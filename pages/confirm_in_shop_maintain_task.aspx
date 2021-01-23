<%@ Page Language="C#" %>

<script runat="server">

    public string userToken = "";
    public string openId = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        string currentPageUrl = Request.Url.ToString();
        if (Session["user_token"] == null || Session["user_token"].ToString().Trim().Equals(""))
        {
            Response.Redirect("../authorize.aspx?callback=" + currentPageUrl, true);
        }
        userToken = Session["user_token"].ToString();
        openId = WeixinUser.CheckToken(userToken);
        int id = int.Parse(Util.GetSafeRequestValue(Request, "id", "0"));
        int orderId = EquipMaintainRequestInshop.PlaceOrder(id);
        if (orderId > 0)
        {
            Response.Redirect("/payment/payment.aspx?product_id=" + orderId.ToString(), true);
        }
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
  
</body>
</html>
