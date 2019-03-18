<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    public WeixinUser currentUser;
    public string openId = "";
    public string userToken = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        string currentPageUrl = Request.Url.ToString();
        if (Session["user_token"] == null || Session["user_token"].ToString().Trim().Equals(""))
        {
            Response.Redirect("../../../authorize.aspx?callback=" + currentPageUrl, true);
        }
        userToken = Session["user_token"].ToString();
        openId = WeixinUser.CheckToken(userToken);
        if (openId.Trim().Equals(""))
        {
            Response.Redirect("../../../authorize.aspx?callback=" + currentPageUrl, true);
        }
        currentUser = new WeixinUser(WeixinUser.CheckToken(userToken));

        if (!currentUser.IsAdmin)
            Response.End();
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <!-- 新 Bootstrap 核心 CSS 文件 -->
    <link rel="stylesheet" href="../../css/bootstrap.min.css">
    <link rel="stylesheet" href="../../css/normalize.css" />
    <!-- 可选的Bootstrap主题文件（一般不用引入） -->
    <link rel="stylesheet" href="../../css/bootstrap-theme.min.css">
    <link type="text/css" href="../../third/alertjs/alert.css" rel="stylesheet"/>
    <title></title>
    <style type="text/css">
        .auto-style1 {
            font-size: xx-large;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <table class="table table-striped">
            <tr>
                <td colspan="2" class="auto-style1" >销售二维码</td>
            </tr>
            <tr>
                <td colspan="2" ><img width="400" height="400" src="/<%= QrCode.GetStaticQrCode("shop_sale_charge_request_openid_"+ openId.Trim(), "images/qrcode") %>" /></td>
            </tr>
            <tr>
                <td class="auto-style1">顾客电话:</td>
                <td><input type="tel" /> <input type="button" value="去收款" /></td>
            </tr>
            <tr>
                <td colspan="2" > </td>
            </tr>
            <tr>
                <td colspan="2"> <input type="button" value="散客收款" /> </td>
            </tr>
        </table>
    </form>
</body>
</html>
