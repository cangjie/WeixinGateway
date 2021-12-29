﻿<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<script runat="server">

    public OnlineSkiPass[] passArr;

    public bool rent = false;

    public string resort = "南山";

    public DateTime currentDate = DateTime.Parse(DateTime.Now.ToShortDateString());

    public int dayNum = 0;

    public int nightNum = 0;

    public bool isNight = false;

    public DataTable dtUser = new DataTable();
    public DataTable dtMini = new DataTable();

    protected void Page_Load(object sender, EventArgs e)
    {
        rent = (Util.GetSafeRequestValue(Request, "rent", "0").Equals("0") ? false : true);
        resort = Util.GetSafeRequestValue(Request, "resort", "南山").Trim();
        isNight = Util.GetSafeRequestValue(Request, "night", "0").Trim().Equals("0") ? false : true;
        passArr = OnlineSkiPass.GetLastWeekOnlineSkiPass();
        dtUser = DBHelper.GetDataTable("select * from users");
        dtMini = DBHelper.GetDataTable(" select mini_users.open_id as open_id, mini_users.nick as mini_nick, mini_users.cell_number as mini_cell, users.nick as nick, users.cell_number as cell  from mini_users  "
            + " left join unionids on unionids.union_id = mini_users.union_id  and unionids.source = 'snowmeet_official_account_new'   left join users on users.open_id = unionids.open_id  " );

    }

    public bool CanDisplay(OnlineSkiPass pass, OnlineOrderDetail dtl)
    {
        bool ret = true;
       

        if (resort.Trim().IndexOf("八易") >= 0)
        {
            switch (resort)
            {
                case "八易租单板":
                    if (dtl.productName.IndexOf("租单板") < 0 || dtl.productName.IndexOf("八易") < 0)
                    {
                        ret = false;
                    }
                    break;
                case "八易租双板":
                    if (dtl.productName.IndexOf("租双板") < 0 || dtl.productName.IndexOf("八易") < 0)
                    {
                        ret = false;
                    }
                    break;
                default:
                    if (dtl.productName.IndexOf("八易") < 0 || (dtl.productName.Trim().IndexOf("八易") >= 0 && dtl.productName.Trim().IndexOf("租") >= 0))
                    {
                        ret = false;
                    }
                    break;
            }
        }
        else
        {
            if (dtl.productName.IndexOf(resort) < 0)
            {
                ret = false;
            }
        }

        if (pass.AppointDate != currentDate || pass.Rent != rent)
            ret = false;
        if (isNight && dtl.productName.Trim().IndexOf("夜场") < 0)
        {
            ret = false;
        }

        if (dtl.productName.Trim().IndexOf("当日票") >= 0)
        {
            Card c = new Card(pass.CardCode.Trim());
            c.Use(DateTime.Now.Date, "当日现场出票，自动验票。");
        }
        return ret;

    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
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
    <ul class="nav nav-tabs" >
        <li class="nav-item"  ><a class="nav-link" href="admin_online_ski_pass_list.aspx" >最近七日</a></li>
        <li class="nav-item"  ><a class="nav-link <%if (resort.Trim().StartsWith("南山") && !rent && !isNight) {%>active<% } %>" href="admin_online_ski_pass_list_today.aspx?resort=南山&rent=0" >南山今日自带</a></li>
        <li class="nav-item"  ><a class="nav-link <%if (resort.Trim().StartsWith("南山") && rent && !isNight) {%>active<% } %>" href="admin_online_ski_pass_list_today.aspx?resort=南山&rent=1" >南山今日租板</a></li>
        <li class="nav-item"  ><a class="nav-link <%if (resort.Trim().StartsWith("南山") && !rent && isNight) {%>active"<% } %>" href="admin_online_ski_pass_list_today.aspx?resort=南山&rent=0&night=1" >南山今日下午夜场自带</a></li>
        <li class="nav-item"  ><a class="nav-link <%if (resort.Trim().StartsWith("南山") && rent && isNight) {%>active<% } %>" href="admin_online_ski_pass_list_today.aspx?resort=南山&rent=1&night=1" >南山今日下午夜场租板</a></li>
        <li class="nav-item"  ><a class="nav-link <%if (resort.Trim().Equals("八易") && !rent) {%>active<% } %>" href="admin_online_ski_pass_list_today.aspx?resort=八易自带&rent=0" >八易今日自带</a></li>
        <li class="nav-item"  ><a class="nav-link <%if (resort.Trim().Equals("八易租单板") && !rent) {%>active<% } %>" href="admin_online_ski_pass_list_today.aspx?resort=八易租单板&rent=0" >八易今日租单板</a></li>
        <li class="nav-item"  ><a class="nav-link <%if (resort.Trim().Equals("八易租双板") && !rent) {%>active<% } %>" href="admin_online_ski_pass_list_today.aspx?resort=八易租双板&rent=0" >八易今日租双板</a></li>
    </ul>
    <table class="table table-striped">
        <tr>
            <td>票号</td>
            <td>手机号</td>
            <td>昵称</td>
            <td>商品</td>
            <td>单价</td>
            <td>张数</td>
            <td>验票</td>
            <td>验票时间</td>
            <td>购买日期</td>
        </tr>
        <%
            foreach (OnlineSkiPass pass in passArr)
            {
                string openId = pass._fields["open_id"].ToString().Trim();
                string cell = "";
                string nick = "";
                DataRow[] drArr = dtMini.Select(" open_id = '" + openId.Trim() + "' ");
                if (drArr.Length == 0)
                {
                    drArr = dtUser.Select(" open_id = '" + openId.Trim() + "' ");
                    if (drArr.Length > 0)
                    {
                        cell = drArr[0]["cell_number"].ToString().Trim();
                        nick = drArr[0]["nick"].ToString().Trim();
                    }
                }
                else
                {
                    cell = drArr[0]["mini_cell"].ToString().Trim();
                    nick = drArr[0]["mini_nick"].ToString().Trim();
                    if (nick.Trim().Equals(""))
                    {

                        nick = drArr[0]["nick"].ToString().Trim();
                    }
                }


                OnlineOrderDetail dtl = pass.AssociateOnlineOrderDetail;
                if (CanDisplay(pass, dtl))
                {
                    if (pass.AssociateOnlineOrderDetail.productName.IndexOf("日场") >= 0)
                    {
                        dayNum++;
                    }
                    if (pass.AssociateOnlineOrderDetail.productName.IndexOf("夜场") >= 0)
                    {
                        nightNum++;
                    }
                %>
        <tr>
            <td><%=pass.CardCode.Trim()%></td>
            <td><%=cell %></td>
            <td><%=nick %></td>
            <td><%=dtl.productName.Trim() %></td>
            <td><%=pass.AssociateOnlineOrderDetail.price.ToString() %></td>
            <td><%=pass.AssociateOnlineOrderDetail.count.ToString() %></td>
            <td><%=(pass.Used ? "已验" : "未验") %></td>
            <td><%=(pass.Used ? pass.useDate.ToString("u").Replace("Z", "") : "---") %></td>
            <td><%=DateTime.Parse(pass.AssociateOnlineOrder._fields["crt"].ToString()).ToString("u").Replace("Z", "") %></td>
        </tr>
                    <%
                            }
                        }
                        if (resort.Trim().Equals("八易"))
                        {
                            %>
        <tr>
            <td colspan="8" >日场：<%=dayNum.ToString() %> 夜场：<%=nightNum.ToString() %></td>
        </tr>
        <%
                        }
             %>
        
    </table>
</body>
</html>
