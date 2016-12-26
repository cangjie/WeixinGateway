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
                <ul>
                    <li>价格：<font color="red" ><%=p._fields["sale_price"].ToString() %></font>元。</li>
                    <li>请看清雪票的使用时段。</li>
                    <li>一旦下单，不退不换。</li>
                    <%
                        if (p._fields["name"].ToString().Trim().StartsWith("南山"))
                        {
                            %>
                    <li>如需租赁雪具，请下单时加入备注。</li>
                    <%
                        }
                        else
                        {
                            %>
                    <li>不支持租赁，<font color="red" >请自带雪具</font>。</li>
                                <%
                        }
                         %>
                    
                    <li>到店请出示雪票二维码。</li>
                </ul>
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
