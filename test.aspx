<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Xml" %>
<!DOCTYPE html>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
       
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
