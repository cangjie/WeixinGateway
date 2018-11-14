﻿<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">
    public WeixinUser currentUser;
    public string openId = "";
    public Card card;
    public string pannelStyle = "info";
    public string title = "";
    public string code = "";
    public string body = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        code = Util.GetSafeRequestValue(Request, "code", "");

        string currentPageUrl = Server.UrlEncode("/pages/admin/wechat/card_confirm.aspx?code=" + code);
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

        card = new Card(code);

        switch (card._fields["type"].ToString().Trim())
        {
            case "雪票":
                pannelStyle = "success";
                OnlineSkiPass pass = new OnlineSkiPass(code);
                title = pass.associateOnlineOrderDetail.productName.Trim();
                body = "";
                break;
            default:
                break;
        }

        if (!currentUser.IsAdmin)
        {
            Response.End();
        }
        if (card.Used)
            Response.Redirect("card_confirm_finish.aspx?code=" + card._fields["card_no"].ToString(), true);
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
        function use_card() {
    
            var code = "<%=code.Trim()%>";
            var token = "<%=Session["user_token"].ToString().Trim()%>";
            var word = document.getElementById("word").value;
            $.ajax({
                url:        "../../../api/use_card.aspx",
                async:      false,
                data:       { code: code, token: token, word: word },
                success:    function (msg, status) {
                    var msg_object = eval("(" + msg + ")");
                    if (msg_object.status == 0) {
                        alert("success");
                        window.location.href = "card_confirm_finish.aspx?code=<%=code%>";
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
        <div id="card-<%=code%>" name="ticket" class="panel panel-<%=pannelStyle %>" style="width:350px"  >
            <div class="panel-heading">
                <h3 class="panel-title"><%=card._fields["type"] %>：<%=title %></h3>
            </div>
            <div class="panel-body">
                    <%=body%>
                <br />
                <div style="text-align:center" >
                    <img src="<%=card.Owner.HeadImage.Trim() %>" style="width:200px; text-align:center"  />
                    <br />
                    <b style="text-align:center" ><%=code.Substring(0,3) %>-<%=code.Substring(3,3) %>-<%=code.Substring(6,3) %></b>
                    <br />
                    <%=card.Owner.CellNumber.Trim() %> <%=card.Owner.Nick.Trim() %>
                    <br /><br />
                    <% if (card._fields["type"].ToString().Equals("雪票"))
                        {
                            OnlineSkiPass pass = new OnlineSkiPass(card._fields["card_no"].ToString().Trim());
                            %>
                    <b style="text-align:center" >日期：<font color="red"><%=pass.AppointDate.ToString() %></font> 张数：<font color="red" ><%=pass.associateOnlineOrderDetail.count.ToString() %> <%=(pass.Rent? "租板":"") %></font></b>
                    <br />
                    <%

                        } %>
                    <p style="text-align:left" >填写备注<br /></p>
                    <textarea id="word" rows="3" cols="38"  ></textarea>  <br />
                    <button class="btn btn-default" onclick="use_card()" >确认使用</button>
                </div>
            </div>
        </div>
    </div>
</body>
</html>