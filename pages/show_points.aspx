<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">
    public string headImage = "";

    public string openId = "";

    public WeixinUser currentUser;

    public string nick = "";
    
    protected void Page_Load(object sender, EventArgs e)
    {
        string currentPageUrl = Server.UrlEncode("/pages/show_points.aspx");

        //Session["user_token"] = "a8488dfb185d7719b88315b7bcfe5d85cbd7cbbe971d175a4e1079fe22ec5724519eed31";

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

        string userInfoJson = Util.GetWebContent("http://" + Util.domainName.Trim() + "/get_user_info.aspx?openid=" + openId.Trim(), "GET", "", "text/html");
        headImage = Util.GetSimpleJsonValueByKey(userInfoJson, "headimgurl");
        nick = Util.GetSimpleJsonValueByKey(userInfoJson, "nickname");
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
    <form id="form1" runat="server">
    <div class="container">
        <div ><br /></div>
        <div class="row" >
            <div class="col-xs-12" ><p class="text-center"><strong>您的积分</strong></p></div>
        </div>
        <div class="row" >
            <div class="col-xs-12">
                <img style="width:100px;height:100px;" class="center-block img-circle" src="<%=headImage %>" />
            </div>
        </div>
        <div class="row" >
            <div class="col-xs-12" ><br /></div>
        </div>
        <div class="row" >
            <div class="col-xs-12" style="align-content:center" ><%=currentUser.Points.ToString() %></div>
        </div>
    </div>
    </form>
</body>
</html>
