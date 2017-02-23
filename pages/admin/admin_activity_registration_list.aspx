<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<!DOCTYPE html>

<script runat="server">

    public DataTable regTable = Activity.GetRegistrationList(16);

    protected void Page_Load(object sender, EventArgs e)
    {

    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <!-- 新 Bootstrap 核心 CSS 文件 -->
    <link rel="stylesheet" href="../css/bootstrap.min.css">
    <link rel="stylesheet" href="../css/normalize.css" />
    <!-- 可选的Bootstrap主题文件（一般不用引入） -->
    <link rel="stylesheet" href="../css/bootstrap-theme.min.css">
    <!-- jQuery文件。务必在bootstrap.min.js 之前引入 -->
    <script src="../js/jquery.min.js"></script>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="../js/bootstrap.min.js"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
</head>
<body>
    <table class="table table-striped">
        <tr>
            <%
                foreach(DataColumn c in regTable.Columns)
                {
                    %>
                <td><%=c.Caption.Trim() %></td>
            <%
                }
                 %>
        </tr>
        <%
            foreach(DataRow r in regTable.Rows)
            {
                %>
        <tr>
            <%
                foreach (DataColumn c in regTable.Columns)
                {
%>
            <td><%=r[c].ToString().Trim() %></td>
                        <%
                }
                 %>
        </tr>
        <%
            }
             %>
    </table>
</body>
</html>
