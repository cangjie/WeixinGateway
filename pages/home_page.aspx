﻿<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    public string openId = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["user_token"] == null || Session["user_token"].ToString().Trim().Equals(""))
        {
            Response.Redirect("../authorize.aspx?callback=" + Server.UrlEncode("/pages/home_page.aspx"), true);
        }
        string userToken = Session["user_token"].ToString();
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
        token is : <%=Session["user_token"].ToString().Trim() %><br />
        open id is : <%=openId %>
    </div>
    </form>
</body>
</html>
