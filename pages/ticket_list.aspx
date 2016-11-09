<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    public WeixinUser currentUser;
    public string openId = "";
    public Ticket[] ticketArray;
    public bool used = true;

    protected void Page_Load(object sender, EventArgs e)
    {
        used = !Util.GetSafeRequestValue(Request, "used", "0").Trim().Equals("0");
        string currentPageUrl = Server.UrlEncode("/pages/ticket_list.aspx" + (used?"?used=1":"") );
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

        ticketArray = Ticket.GetUserTickets(openId, used);

        

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
    <div style="margin-left: 5px" >
        <div id="nav" >
            <ul class="nav nav-tabs" role="tablist">
                <li role="presentation" <%if (!used)
                    { %> class="active" <%} %> ><a href="ticket_list.aspx">未使用</a></li>
                <li role="presentation" <%if (used) {%> class="active" <%} %> ><a href="ticket_list.aspx?used=1">已使用</a></li>
            </ul>
        </div>
        <div id="tickets" >
            <%
    foreach (Ticket t in ticketArray)
    {
                 %>
            <div id="ticket-<%=t.Code.Trim()%>" name="ticket" class="panel panel-info" style="width:350px" >
                <div class="panel-heading">
                    <h3 class="panel-title">代金券<%=Math.Round(t.Amount, 2).ToString() %>元&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;到期日：<%=t.ExpireDate.ToShortDateString() %></h3>
                </div>
                <div class="panel-body">
                    <%=t._fields["memo"].ToString().Trim() %>
                </div>
            </div>
            <%}
                 %>
        </div>
    </div>
</body>
</html>
