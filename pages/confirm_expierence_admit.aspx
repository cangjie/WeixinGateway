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
        Expierence expierence = new Expierence(id);
        WeixinUser.GetUnionId(openId);
        int orderId = expierence.PlaceOrder(openId);
        if (orderId > 0)
        {
            Response.Redirect("/payment/payment.aspx?product_id=" + orderId.ToString(), true);
        }
    }
</script>