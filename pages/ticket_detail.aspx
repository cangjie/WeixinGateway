<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    public WeixinUser currentUser;
    public string openId = "";
    public Ticket ticket;

    protected void Page_Load(object sender, EventArgs e)
    {
        ticket = new Ticket(Util.GetSafeRequestValue(Request, "code", ""));

        string currentPageUrl = Server.UrlEncode("/pages/ticket_detail.aspx?code=" + ticket.Code);
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

        if (!currentUser.OpenId.Trim().Equals(ticket.Owner.OpenId))
        {
            Response.End();
        }
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <div style="margin-left: 5px" >
        <div id="ticket-<%=ticket.Code.Trim()%>" name="ticket" class="panel panel-info" style="width:350px"  >
            <div class="panel-heading">
                <h3 class="panel-title">代金券<%=Math.Round(ticket.Amount, 2).ToString() %>元&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;到期日：<%=ticket.ExpireDate.ToShortDateString() %></h3>
            </div>
            <div class="panel-body">
                    <%=ticket._fields["memo"].ToString().Trim() %>
                <br />
                <img src="../show_qrcode.aspx?sceneid=3<%=ticket.Code %>" style="width:200px" />
                <br />
                <b><%=ticket.Code.Substring(0,3) %>-<%=ticket.Code.Substring(3,3) %>-<%=ticket.Code.Substring(6,3) %></b>
            </div>
        </div>
    </div>
</body>
</html>
