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
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <!-- jQuery文件。务必在bootstrap.min.js 之前引入 -->
    <script src="../../js/jquery.min.js"></script>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="../../js/bootstrap.min.js"></script>
    <script src="../../third/alertjs/alert.js?3"></script>
    <script type="text/javascript" >
        function waiting_for_scan() {
            $.ajax({
                url: "/api/get_current_scan_openid.aspx?eventkey=shop_sale_charge_request_openid_<%=currentUser.OpenId.Trim()%>",
                success: function (msg, status) {
                    if (msg.toString() != '') {
                        //alert(msg);
                        window.location.href = 'admin_charge_shop_sale_simple_new.aspx?openid=' + msg;
                    }
                }
            });
        }
        setInterval("waiting_for_scan()", 3000);
        function cell_number_charge() {
            window.location.href = 'admin_charge_shop_sale_simple_new.aspx?cell=' + document.getElementById("cell").value;
        }
    </script>
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
                <td class="auto-style1" colspan="2">顾客电话:</td>
            </tr>
            <tr>
                <td colspan="2"><input id="cell" type="tel" value="" /> <input type="button" onclick="cell_number_charge()" value="去收款" style="width:100px" /></td>
            </tr>
            <tr>
                <td colspan="2" > </td>
            </tr>
            <tr>
                <td colspan="2"> <input type="button" value="散客收款" style="width:100px" onclick="javascript:window.location.href='admin_charge_shop_sale_simple_new.aspx'" /> </td>
            </tr>
        </table>
    </form>
</body>
</html>
