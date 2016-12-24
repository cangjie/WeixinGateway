<%@ Page Language="C#" %>

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

        pass = new OnlineSkiPass(code);
        order = pass.associateOnlineOrder;
        detail = pass.associateOnlineOrderDetail;
        
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
            <div id="ticket-<%=code.Trim()%>" name="ticket" class="panel panel-info" style="width:350px"  >
            <div class="panel-heading">
                <h3 class="panel-title"><%=detail.productName.Trim() %></h3>
            </div>
            <div class="panel-body">
                    <li>请看清雪票的使用时段。</li>
                    <li>一旦下单，不退不换。</li>
                    <%
                        if (detail.productName.Trim().StartsWith("南山"))
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
