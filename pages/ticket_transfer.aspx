<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    public string code = "";
    public string fatherOpenId = "";
    public WeixinUser currentUser;
    public string openId = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        code = Util.GetSafeRequestValue(Request, "code", "");
        fatherOpenId = Util.GetSafeRequestValue(Request, "fatheropenid", "");

        string currentPageUrl = Request.Url.ToString();

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

        if (currentUser.CellNumber.Trim().Equals("") || currentUser.VipLevel < 1)
            Response.Redirect("register_cell_number.aspx?fatheropenid=" + fatherOpenId.Trim() + "&refurl=" + Server.UrlEncode(currentPageUrl), true);

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
