<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    public int userPoints = 0;
    public Ticket.TicketTemplate[] ticketTemplateArray = Ticket.GetAllTicketTemplate();
    public WeixinUser currentUser;
    public string openId = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        string currentPageUrl = Server.UrlEncode("/pages/ticket_exchange_list.aspx");
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

        if (currentUser.CellNumber.Trim().Equals("") || currentUser.VipLevel < 1)
            Response.Redirect("register_cell_number.aspx", true);
        if (!currentUser.IsBetaUser)
            Response.Redirect("beta_announce.aspx", true);

        userPoints = currentUser.Points;
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
    <script type="text/javascript" >
        var current_id = "";
        var token = "<%=Session["user_token"].ToString().Trim()%>";
        function select_ticket(id) {
            //alert(id);
            
            var ticket_array = document.getElementsByName("ticket");
            for (var i = 0; i < ticket_array.length; i++) {
                var ticket = ticket_array[i];
                //alert(ticket.className);
                if (ticket.className != "panel panel-default") {
                    if (ticket.id == "ticket-" + id) {
                        ticket.className = "panel panel-danger";
                        current_id = id;
                    }
                    else {
                        ticket.className = "panel panel-info";
                    }
                }
            }
        }

        function exchange() {
            var ajax_url = "../api/exchange_dragon_ball_to_ticket.aspx?token=" + token + "&templateid=" + current_id;
            $.ajax({
                url:        ajax_url,
                async:      false,
                success:    function (msg, status) {
                                var msg_object = eval("(" + msg + ")");
                                if (msg_object.status == 0) {
                                    //alert("success");
                                    window.location.href = "ticket_list.aspx";
                                }
                                else {
                                    alert(msg_object.error_message);
                                }
                            }
            });
        }
    </script>
</head>
<body>
    <div style="margin-left: 5px" >
        <h1>龙珠兑换代金券</h1>
        <h6>你目前拥有龙珠：<%=userPoints.ToString() %>颗</h6>
<%
    for (int i = 0; i < ticketTemplateArray.Length; i++)
    {
        string className = "panel panel-info";
        string onClick = "select_ticket('" +  ticketTemplateArray[i].id.ToString() + "')";

        if (userPoints < ticketTemplateArray[i].neetPoints)
        {
            className = "panel panel-default";
            onClick = "";
        }

        %>
        <div id="ticket-<%=ticketTemplateArray[i].id.ToString() %>" name="ticket" class="<%=className %>" style="width:350px" <%if (!onClick.Trim().Equals(""))
            { %> onclick="<%=onClick.Trim() %>" <%} %> >
            <div class="panel-heading">
                <h3 class="panel-title"><%=ticketTemplateArray[i].neetPoints.ToString() %>龙珠兑换代金券<%=ticketTemplateArray[i].currencyValue.ToString() %>元</h3>
            </div>
            <div class="panel-body">
                <%=ticketTemplateArray[i].memo %>
            </div>
        </div>
        <%
    }
     %>
        <button type="button" class="btn btn-danger" onclick="exchange()" >我要兑换（此操作不可逆）</button>
        <br />
    </div>
</body>
</html>
