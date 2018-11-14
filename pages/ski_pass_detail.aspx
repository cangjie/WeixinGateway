﻿<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    public string orderId = "";
    public string code = "";
    public OnlineSkiPass pass;
    public Product p;
    public OnlineOrder order;
    public OnlineOrderDetail detail;
    public WeixinUser currentUser;
    public string openId = "";
    public string userToken = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        orderId = Util.GetSafeRequestValue(Request, "orderid", "0");
        code = Util.GetSafeRequestValue(Request, "code", "");
        string currentPageUrl = Server.UrlEncode("/pages/ski_pass_detail.aspx?orderid=" + orderId.Trim() + "&code=" + code.Trim() );
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
        
        pass = new OnlineSkiPass(code);
        order = pass.associateOnlineOrder;
        detail = pass.associateOnlineOrderDetail;

        if (!openId.Trim().Equals(pass.owner.OpenId.Trim()))
            Response.End();
        
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
    <div>
            <div id="ticket-<%=code.Trim()%>" name="ticket" class="panel panel-success" style="width:350px"  >
            <div class="panel-heading">
                <h3 class="panel-title"><%=detail.productName.Trim() %></h3>
            </div>
            <div class="panel-body">
                <ul>
                    <li>价格：<font color="red" ><%=order._fields["order_price"].ToString() %></font>元，张数：
                        <%=pass.associateOnlineOrderDetail.count.ToString() %>张 
                        <%=(pass.Rent? ",<font color='red' >租板</font>":"") %></li>
                    <%
                        if (detail.productName.IndexOf("南山") >= 0)
                        {
                         %>
                    <li>到达代理商入口请拨打：13910228351，将有工作人员接您入场。</li>
                    <li>来店请出示二维码验票、取票。</li>
                    <li>此票售出后不予退换。</li>
                    <%
                        }
                        else
                        {
                            %>
                    <li><font color="red" >出票日自动出票。</font></li>
                    <li>来店请出示二维码验票、取票。</li>
                    <li>滑雪结束后来店办理雪卡押金退还手续。</li>
                    <li>此票售出后不予退换。</li>
                    <%
                        }
                         %>
                </ul>
                <br />
                <div style="text-align:center" >
                    <img src="../show_qrcode.aspx?sceneid=3<%=code %>" style="width:200px; text-align:center"  />
                    <br />
                    <b style="text-align:center" ><%=code.Substring(0,3) %>-<%=code.Substring(3,3) %>-<%=code.Substring(6,3) %></b>
                </div>
            </div>
        </div>
    </div>
    </form>
</body>
</html>