<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Xml" %>
<!DOCTYPE html>

<script runat="server">

    public string callBack = "http://trx.999uuu.cn/test.aspx";

    protected void Page_Load(object sender, EventArgs e)
    {
        //string openId = WeixinUser.CheckToken("044d8678dbc82fc2ae4e2f8680c49b8449d2da7e72ed5325494202bba809c8c232e8cd55");
        //Response.Write(Util.GetToken());
        Response.Write(Util.GetWebContent("http://52.80.17.211:8848/show_client_ip.aspx"));
        
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        After authorize go to:<a href="authorize.aspx?callback=<%=callBack %>" ><%=Server.UrlDecode(callBack) %></a>
    </div>
    </form>
</body>
</html>
