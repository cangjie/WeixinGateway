<%@ Page Language="C#" %>
<script runat="server">

    public OnlineSkiPass[] passArr;

    protected void Page_Load(object sender, EventArgs e)
    {
        passArr = OnlineSkiPass.GetLastWeekOnlineSkiPass();
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
            <td>票号</td>
            <td>手机号</td>
            <td>昵称</td>
            <!--td>票种</td-->
            <td>单价</td>
            <td>张数</td>
            <td>验票</td>
            <td>验票时间</td>
            <td>购买日期</td>
        </tr>
        <%
            foreach(OnlineSkiPass pass in passArr)
            {
                %>
        <tr>
            <td><%=pass.cardCode.Trim()%></td>
            <td><%=pass.owner.CellNumber.Trim() %></td>
            <td><%=pass.owner.Nick.Trim() %></td>
            <!--td><%=pass.associateOnlineOrderDetail.productName.Trim() %></td-->
            <td><%=pass.associateOnlineOrderDetail.price.ToString() %></td>
            <td><%=pass.associateOnlineOrderDetail.count.ToString() %></td>
            <td><%=(pass.used? "已验":"未验") %></td>
            <td><%=(pass.used? pass.useDate.ToString() : "---") %></td>
            <td><%=pass.associateOnlineOrder._fields["crt"].ToString() %></td>
        </tr>
                    <%
            }
             %>
        
    </table>
</body>
</html>
