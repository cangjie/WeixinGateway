<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    public string used = "0";

    public WeixinUser currentUser;

    public string userToken = "";

    public string openId = "";

    public OnlineSkiPass[] passArr;

    protected void Page_Load(object sender, EventArgs e)
    {
        used = Util.GetSafeRequestValue(Request, "used", "0");

        string currentPageUrl = Server.UrlEncode("/pages/ski_pass_list.aspx");
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
            Response.Redirect("register_cell_number.aspx?refurl=" + currentPageUrl, true);
        
        passArr = OnlineSkiPass.GetOnlieSkiPassByOwnerOpenId(openId);

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
        function go_to_detail(order_id, card_code) {
            window.location.href = "ski_pass_detail.aspx?orderid=" + order_id + "&code=" + card_code;
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <ul class="nav nav-tabs" role="tablist">
            <li role="presentation" <%if (used.Trim().Equals("0"))
                { %> class="active" <%}  %> ><a href="ski_pass_list.aspx?used=0">未使用</a></li>
            <li role="presentation" <%if (used.Trim().Equals("1"))
                { %> class="active" <%}  %> ><a href="ski_pass_list.aspx?used=1">已使用</a></li>
        </ul>
        <%
            foreach (OnlineSkiPass pass in passArr)
            {
                bool valid = false;
                if (used.Trim().Equals("1") == pass.used)
                    valid = true;
                if (valid)
                {
                    Product p = new Product(pass.associateOnlineOrderDetail.productId);
                    %>
        <br />
        <div id="ticket-1" name="ticket" class="panel panel-success" style="width:350px" onclick="go_to_detail('<%=pass.associateOnlineOrder._fields["id"].ToString().Trim() %>','<%=pass.cardCode %>')" >
            <div class="panel-heading">
                <h3 class="panel-title"><%=p._fields["name"].ToString() %></h3>
            </div>
            <div class="panel-body">
                <p>雪票价格：<font color="red" ><%=p._fields["sale_price"].ToString() %></font>元，张数：<%=pass.associateOnlineOrderDetail.count.ToString() %>张 <%=(pass.Rent? ",<font color='red' >租板</font>":"") %></p>
                        <%
                            if (p._fields["name"].ToString().IndexOf("南山") >= 0)
                            {


                     %>
                <p>如租板，押金200元。</p>
                <p>价格包括：门票、滑雪、缆车、拖牵、魔毯费用、（如租板，则包含雪具使用）。</p>
                <p>如需租用雪板、雪鞋、雪杖以外的物品，如头盔、雪镜、雪服等物品，请额外准备现金，押金 100元/件。</p>
                <p>使用说明：</p>
                <ul>
                    <li><font color="red" >出票日：<%=pass.AppointDate.ToShortDateString() %>，将于该日自动出票。</font></li>
                    <li>到达代理商入口请拨打：13693171170，将有工作人员接您入场。</li>
                    <li>来店清除示二维码验票、取票。</li>
                    <li>此票售出后不予退换。</li>
                </ul>
                <p>雪场地址：<br />北京市密云区河南寨镇圣水头村南山滑雪场<br />客服电话：13693171170</p>
                <%}
                    else
                    {
                        %>
                <p><font color="red" >只支持自带板！</font></p>
                <p>价格包括：门票、滑雪、缆车、魔毯费用及雪卡押金（10元）。</p>
                <p>使用说明：</p>
                <ul>
                    <li><font color="red" >出票日自动出票。</font></li>
                    <li>来店清除示二维码验票、取票。</li>
                    <li>滑雪结束后来店办理雪卡押金退还手续。</li>
                    <li>此票售出后不予退换。</li>
                </ul>
                <p>雪场地址：<br />北京市丰台区射击场路甲12号万龙八易滑雪场<br />客服电话：15701179221</p>
                <%
                    }

                     %>
            </div>
        </div>
        
        <%
                }
            }
             %>
    </div>
    </form>
</body>
</html>
