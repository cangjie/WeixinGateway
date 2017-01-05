﻿<%@ Page Language="C#" %>
<script runat="server">

    public OnlineSkiPass[] passArr;

    public bool rent = false;

    public string resort = "南山";

    public DateTime currentDate = DateTime.Parse(DateTime.Now.ToShortDateString());

    protected void Page_Load(object sender, EventArgs e)
    {
        rent = (Util.GetSafeRequestValue(Request, "rent", "0").Equals("0") ? false : true);
        resort = Util.GetSafeRequestValue(Request, "resort", "八易").Trim();


        passArr = OnlineSkiPass.GetLastWeekOnlineSkiPass();
    }

    public bool CanDisplay(OnlineSkiPass pass)
    {
        bool ret = true;
        if (pass.productName.IndexOf(resort) < 0 || pass.AppointDate != currentDate || pass.Rent != rent)
            ret = false;
        return ret;

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
            <td>单价</td>
            <td>张数</td>
            <td>租板</td>
            <td>验票时间</td>
            <td>购买日期</td>
        </tr>
        <%
    foreach (OnlineSkiPass pass in passArr)
    {
        if (CanDisplay(pass))
        { 
                %>
        <tr>
            <td><%=pass.cardCode.Trim()%></td>
            <td><%=pass.owner.CellNumber.Trim() %></td>
            <td><%=pass.owner.Nick.Trim() %></td>
            <!--td><%=pass.associateOnlineOrderDetail.productName.Trim() %></td-->
            <td><%=pass.associateOnlineOrderDetail.price.ToString() %></td>
            <td><%=pass.associateOnlineOrderDetail.count.ToString() %></td>
            <td><%=(pass.used ? "已验" : "未验") %></td>
            <td><%=(pass.used ? pass.useDate.ToString() : "---") %></td>
            <td><%=pass.associateOnlineOrder._fields["crt"].ToString() %></td>
        </tr>
                    <%
                            }
                        }
             %>
        
    </table>
</body>
</html>
