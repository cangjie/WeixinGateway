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
        string call = "http://trx.999uuu.cn/users_test.aspx?id=test&value=2";
        callBack = callBack + "?type=1&redirect_url=" + Server.UrlEncode(call);
        callBack = Server.UrlEncode(callBack);
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
