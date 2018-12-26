<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Xml" %>
<!DOCTYPE html>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        //Core.Util.SetSnapFailed("https://s.taobao.com/search?q=capita", DateTime.Now.Date);
        //Response.Write(System.Text.Encoding.UTF8.ToString());
        //System.Text.Encoding.GetEncoding("UTF-8");

        string ret = QrCode.GetStaticQrCode("openid_oZBHkjhdFpC5ScK5FUU7HKXE3PJM", "images\\qrcode");
        Response.Write(ret.Trim());
        Response.End();
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>taobao cookie: <%=Core.TaobaoSnap.taobaoCookie.Trim() %></div>
    <div>tmall cookie: <%=Core.TaobaoSnap.tmallCookie.Trim() %></div>
    </form>
</body>
</html>
