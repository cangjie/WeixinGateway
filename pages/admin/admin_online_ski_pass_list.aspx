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
    <ul class="nav nav-tabs" role="tablist">
        <li role="presentation" class="active" ><a href="admin_online_ski_pass_list.aspx" >最近七日</a></li>
        <li role="presentation" ><a href="admin_online_ski_pass_list_today.aspx?resort=南山&rent=0" >南山今日自带</a></li>
        <li role="presentation" ><a href="admin_online_ski_pass_list_today.aspx?resort=南山&rent=1" >南山今日租板</a></li>
        <li role="presentation" ><a href="admin_online_ski_pass_list_today.aspx?resort=八亿&rent=0" >八易今日自带</a></li>
        <li role="presentation" ><a href="admin_online_ski_pass_list_today.aspx?resort=八亿&rent=1" >八易今日租板</a></li>
        <li role="presentation" ><a href="admin_online_ski_pass_list_today.aspx?resort=万龙&rent=0" >万龙今日自带</a></li>
    </ul>
    <table class="table table-striped">
        <tr>
            <td>票号</td>
            <td>手机号</td>
            <td>昵称</td>
            <td>雪场</td>
            <td>单价</td>
            <td>张数</td>
            <td>租板</td>
            <td>支付金额</td>
            <td>验票</td>
            <td>验票时间</td>
            <td>购买日期</td>
        </tr>
        <%
            foreach(OnlineSkiPass pass in passArr)
            {
                
                %>
        <tr>
            <td><%=pass.CardCode.Trim()%></td>
            <td><%=pass.Owner.CellNumber.Trim() %></td>
            <td><%=pass.Owner.Nick.Trim() %></td>
            <%
                OnlineOrderDetail dtl = pass.AssociateOnlineOrderDetail;
                 %>
            <td><%=dtl.productName.Trim() %></td>
            <td><%=dtl.price.ToString() %></td>
            <td><%=dtl.count.ToString() %></td>
            <td><%=(pass.Rent? "需要" : "不需要") %></td>
            <td><%=Math.Round(double.Parse(pass.AssociateOnlineOrder._fields["order_real_pay_price"].ToString()),2).ToString() %></td>
            <td><%=(pass.Used? "已验":"未验") %></td>
            <td><%=(pass.Used? pass.useDate.ToString() : "---") %></td>
            <td><%=pass.AssociateOnlineOrder._fields["create_date"].ToString() %></td>
        </tr>
                    <%
            }
             %>
        
    </table>
</body>
</html>
