<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Xml" %>
<!DOCTYPE html>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        //OrderTemp orderTemp = new OrderTemp(1);
        //orderTemp.PlaceOnlineOrder("oZBHkjhdFpC5ScK5FUU7HKXE3PJM");
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <img src="http://weixin-snowmeet.chinacloudsites.cn/show_qrcode.aspx?qrcodetext=<%=Server.UrlEncode("https://qr.alipay.com/bax0364050gripraioyb6066") %>" />
        <br />
        <img src="http://weixin-snowmeet.chinacloudsites.cn/show_qrcode.aspx?qrcodetext=<%=Server.UrlEncode("weixin://wxpay/bizpayurl?pr=Cr1X6AA") %>" />
    </div>
    </form>
</body>
</html>
