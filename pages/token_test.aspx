<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    string openId = "";
    string userToken = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        string currentPageUrl = Request.Url.ToString();

        if (Session["user_token"] == null || Session["user_token"].ToString().Trim().Equals(""))
        {
            Response.Redirect("../authorize.aspx?callback=" + currentPageUrl, true);
        }
        userToken = Session["user_token"].ToString();
        openId = WeixinUser.CheckToken(userToken);
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        open id: <%=openId %><br />
        user token:<%=userToken %>
    </div>
    </form>
</body>
</html>
