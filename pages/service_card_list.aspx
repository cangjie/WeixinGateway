<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    public WeixinUser currentUser;
    public string openId = "";
    public Card[] cardArray;
    public bool used = true;
    public string userToken = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        used = !Util.GetSafeRequestValue(Request, "used", "0").Trim().Equals("0");
        string currentPageUrl = Request.Url.ToString().Split('?')[0].Trim();
        if (!Request.QueryString.ToString().Trim().Equals(""))
        {
            currentPageUrl = currentPageUrl + "?" + Request.QueryString.ToString().Trim();
        }
        if (Session["user_token"] == null || Session["user_token"].ToString().Trim().Equals(""))
        {
            Response.Redirect("../authorize.aspx?callback=" + currentPageUrl, true);
        }
        userToken = Session["user_token"].ToString();


        openId = WeixinUser.CheckToken(userToken);
        if (openId.Trim().Equals(""))
        {
            Response.Redirect("../authorize.aspx?callback=" + currentPageUrl, true);
        }
        currentUser = new WeixinUser(WeixinUser.CheckToken(userToken));
        if (currentUser.CellNumber.Trim().Equals("") || currentUser.VipLevel < 1)
            Response.Redirect("register_cell_number.aspx", true);
        /*
        if (!currentUser.IsBetaUser)
            Response.Redirect("beta_announce.aspx", true);
            */

        Card[] cardArrNew = Card.GetCardList(currentUser.OpenId.Trim());
        Card[] cardArrOld = Card.GetCardList(currentUser.OldUser.OpenId.Trim());

        cardArray = new Card[cardArrNew.Length + cardArrOld.Length];

        for (int i = 0; i < cardArray.Length; i++)
        {
            if (i < cardArrNew.Length)
            {
                cardArray[i] = cardArrNew[i];
            }
            else
            {
                cardArray[i] = cardArrOld[i - cardArrNew.Length];
            }
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
    <script type="text/javascript" >
        function go_to_ticket_detail(code) {
            window.location.href = "service_card_detail.aspx?code=" + code;
        }
    </script>
</head>
<body>
    <div style="margin-left: 5px" >
        <div id="nav" >
            <!--ul class="nav nav-tabs" role="tablist">
                <li class="nav-item" ><a class="nav-link <%if (!used)
                    { %>active<%} %>" href="ticket_list.aspx">未使用</a></li>
                <li class="nav-item"  ><a class="nav-link <%if (used) {%>active<%} %>" href="ticket_list.aspx?used=1">已使用</a></li>
            </ul-->
        </div>
        <div id="tickets" >
            <%
    foreach (Card c in cardArray)
    {
                    Product p = new Product(int.Parse(c._fields["product_id"].ToString()));
                 %>
            <div id="ticket-<%=c.Code.Trim()%>" name="ticket" class="panel panel-info" style="width:350px" onclick="go_to_ticket_detail('<%=c.Code.Trim() %>')" >
                <div class="panel-heading">
                    <h3 class="panel-title"><%=c.Name.Trim()%></h3>
                </div>
                <div class="panel-body">
                    <%if (c.Name.IndexOf("2020") >= 0 || c.Name.IndexOf("19-20") >= 0) %>
                    <%
                        {%>
                    <%=p.cardInfo.rules.Trim().Replace("2021", "2020") %>
                    <%}
    else
    {%>
                  <%=p.cardInfo.rules.Trim() %>
                    <%} %>
                </div>
            </div>
            <%}
                 %>
        </div>
    </div>
</body>
</html>
