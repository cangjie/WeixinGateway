<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<!DOCTYPE html>

<script runat="server">

    public DataTable balanceTable;

    public WeixinUser currentUser;
    public string openId = "";


    protected void Page_Load(object sender, EventArgs e)
    {
        string currentPageUrl = Server.UrlEncode("../pages/dragon_ball_list.aspx");
        if (Session["user_token"] == null || Session["user_token"].ToString().Trim().Equals(""))
        {
            Response.Redirect("../authorize.aspx?callback=" + currentPageUrl, true);
        }
        string userToken = Session["user_token"].ToString();
        openId = WeixinUser.CheckToken(userToken);
        if (openId.Trim().Equals(""))
        {
            Response.Redirect("../authorize.aspx?callback=" + currentPageUrl, true);
        }
        currentUser = new WeixinUser(WeixinUser.CheckToken(userToken));

        Point[] userPointArray = Point.GetUserBalance(currentUser.OpenId);

        balanceTable = new DataTable();
        balanceTable.Columns.Add("日期");
        balanceTable.Columns.Add("收入");
        balanceTable.Columns.Add("支出");
        balanceTable.Columns.Add("余额");
        balanceTable.Columns.Add("备注");

        int sum = 0;

        foreach (Point p in userPointArray)
        {
            sum = sum + p.Points;
        }


        foreach(Point p in userPointArray)
        {
            DataRow dr = balanceTable.NewRow();
            dr["日期"] = p.TransactDate.ToShortDateString();
            if (p.Points >= 0)
            {
                dr["收入"] = p.Points.ToString();
                dr["支出"] = "";
            }
            else
            {
                dr["支出"] = p.Points.ToString();
                dr["收入"] = "";
            }
            dr["余额"] = sum.ToString();
            dr["备注"] = p._fields["memo"].ToString();
            balanceTable.Rows.Add(dr);
        }


    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <!-- 新 Bootstrap 核心 CSS 文件 -->
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="css/normalize.css" />
    <!-- 可选的Bootstrap主题文件（一般不用引入） -->
    <link rel="stylesheet" href="css/bootstrap-theme.min.css">
    <!-- jQuery文件。务必在bootstrap.min.js 之前引入 -->
    <script src="js/jquery.min.js"></script>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="js/bootstrap.min.js"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
</head>
<body>
    <div>
        <table class="table table-striped" >
            <tr>
                <td>日期</td>
                <td>收入</td>
                <td>支出</td>
                <td>余额</td>
                <td>备注</td>
            </tr>
            <%
                foreach (DataRow dr in balanceTable.Rows)
                {
                    %>
            <tr>
                <td><%=dr["日期"].ToString() %></td>
                <td><%=dr["收入"].ToString() %></td>
                <td><%=dr["支出"].ToString() %></td>
                <td><%=dr["余额"].ToString() %></td>
                <td><%=dr["备注"].ToString() %></td>
            </tr>
            <%
                }
                 %>
        </table>
    </div>
</body>
</html>
