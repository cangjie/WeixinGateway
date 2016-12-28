<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    public WeixinUser currentUser;
    public string openId = "";
    public Ticket ticket;

    protected void Page_Load(object sender, EventArgs e)
    {
        string code = Util.GetSafeRequestValue(Request, "code", "");

        Card card = new Card(code);

        switch (card._fields["type"].ToString().Trim())
        {
            case "雪票":
                Response.Redirect("card_confirm.aspx?code=" + code.Trim(), true);
                break;
            default:
                break;
        }
        try
        {


            ticket = new Ticket(code);

            string currentPageUrl = Server.UrlEncode("/pages/admin/wechat/ticket_confirm.aspx?code=" + ticket.Code);
            if (Session["user_token"] == null || Session["user_token"].ToString().Trim().Equals(""))
            {
                Response.Redirect("../../../authorize.aspx?callback=" + currentPageUrl, true);
            }
            string userToken = Session["user_token"].ToString();
            openId = WeixinUser.CheckToken(userToken);
            if (openId.Trim().Equals(""))
            {
                Response.Redirect("../../../authorize.aspx?callback=" + currentPageUrl, true);
            }
            currentUser = new WeixinUser(WeixinUser.CheckToken(userToken));

            if (!currentUser.IsAdmin || ticket.Used)
            {
                Response.End();
            }
        }
        catch
        {
            Response.Redirect("card_confirm.aspx?code=" + code, true);
        }
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <!-- 新 Bootstrap 核心 CSS 文件 -->
    <link rel="stylesheet" href="../../css/bootstrap.min.css">
    <link rel="stylesheet" href="css/normalize.css" />
    <!-- 可选的Bootstrap主题文件（一般不用引入） -->
    <link rel="stylesheet" href="../../css/bootstrap-theme.min.css">
    <!-- jQuery文件。务必在bootstrap.min.js 之前引入 -->
    <script src="../../js/jquery.min.js"></script>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="../../js/bootstrap.min.js"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <script type="text/javascript" >
        function use_ticket() {
            var code = "<%=ticket.Code.Trim()%>";
            var token = "<%=Session["user_token"].ToString().Trim()%>";
            var word = document.getElementById("word").value;
            $.ajax({
                url:        "../../../api/use_ticket.aspx",
                async:      false,
                data:       { code: code, token: token, word: word },
                success:    function (msg, status) {
                    var msg_object = eval("(" + msg + ")");
                    if (msg_object.status == 0) {
                        alert("success");
                        window.close();
                    }
                    else {
                        alert("failed");
                    }
                }
            });
        }
    </script>
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
                <div style="text-align:center" >
                    <img src="<%=ticket.Owner.HeadImage.Trim() %>" style="width:200px; text-align:center"  />
                    <br />
                    <b style="text-align:center" ><%=ticket.Code.Substring(0,3) %>-<%=ticket.Code.Substring(3,3) %>-<%=ticket.Code.Substring(6,3) %></b>
                    <br />
                    <%=ticket.Owner.CellNumber.Trim() %> <%=ticket.Owner.Nick.Trim() %>
                    <br /><br />
                    <p style="text-align:left" >填写备注<br /></p>
                    <textarea id="word" rows="3" cols="38"  ></textarea>  <br />
                    <button class="btn btn-default" onclick="use_ticket()" >确认使用</button>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
