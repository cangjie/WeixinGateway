<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    public string comment = "";
    public int score = 0;
    public int totalScore = 0;
    public string openId = "";
    public string userToken = "";
    public WeixinUser currentUser;
    public bool canPay = false;

    protected void Page_Load(object sender, EventArgs e)
    {

        comment = Util.GetSafeRequestValue(Request, "comment", "进入南山店二楼休息室").Trim();
        score = int.Parse(Util.GetSafeRequestValue(Request, "score", "10").Trim());


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
        totalScore = currentUser.Points;
        if (totalScore >= score)
        {
            canPay = true;
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
    <div class="container" >
        <div class="row">
            <div class="col" ><h1 style="text-align:center" > 支 付 龙 珠 </h1></div>
        </div>
        <div class="row">
            <div class="col" ><hr /></div>
        </div>
        <div class="row" >
            <div class="col" style="text-align:right" >需要支付龙珠（颗）：</div>
            <div class="col" ><%=score.ToString() %></div>
        </div>
        <div class="row" >
            <div class="col" style="text-align:right" >用途：</div>
            <div class="col" ><%=comment.Trim() %></div>
        </div>
        <div class="row" >
            <div class="col" style="text-align:right" >现有龙珠：</div>
            <div class="col" ><%=totalScore.ToString()%></div>
        </div>
        <div class="row" >
            <div class="col" ><hr /></div>
        </div>
        <%
            if (canPay)
            {
             %>
        <div class="row" >
            <div class="col"   style="text-align:center" ><button id="btn_pay" onclick="pay_score('<%=userToken.Trim() %>', <%=score.ToString() %>, '<%=comment.Trim() %>')"  >同 意 支 付</button></div>
        </div>
        <%
            }
            else
            {
                %>
        <div class="row" >
            <div class="col"   style="text-align:center" ><button id="btn_pay" disabled="disabled" > 龙 珠 余 额 不 足 </button></div>
        </div>
        <%
            }
             %>
    </div>
</body>
</html>
