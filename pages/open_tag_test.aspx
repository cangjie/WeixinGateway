<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    public string appId = "";
    public string timeStamp = Util.GetTimeStamp().ToString();
    public string nonceStr = Util.GetNonceString(8);
    public string sign = "";


    protected void Page_Load(object sender, EventArgs e)
    {
        /*
        string currentPageUrl = Request.Url.ToString().Split('?')[0].Trim();
        if (!Request.QueryString.ToString().Trim().Equals(""))
        {
            currentPageUrl = currentPageUrl + "?" + Request.QueryString.ToString().Trim();
        }

        if (Session["user_token"] == null || Session["user_token"].ToString().Trim().Equals(""))
        {
            Response.Redirect("../authorize.aspx?callback=" + currentPageUrl, true);
        }
        */
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.6.0.js" ></script>

</head>
<body>
    <form id="form1" runat="server">
        <div>
        </div>
    </form>
</body>
</html>
