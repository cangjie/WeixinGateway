<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    public string timeStamp = "";
    public string nonceStr = "e4bf6e00dd1f0br0fcab93bd5ae8f";
    public string ticketStr = "";
    public string shaParam = "";
    public string appId = System.Configuration.ConfigurationManager.AppSettings["wxappid"];


    public WeixinUser currentUser;
    public string openId = "";
    //public Ticket ticket;
    public string userToken = "";
    public Card card;
    public Product product;

    public Product.ServiceCard cardInfo;

    protected void Page_Load(object sender, EventArgs e)
    {
        card = new Card(Util.GetSafeRequestValue(Request, "code", "345678923"));

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
        if (!currentUser.OpenId.Trim().Equals(card.Owner.OpenId))
        {
            Response.Write("error");
            Response.End();
        }
        product = new Product(int.Parse(card._fields["product_id"].ToString()));
        cardInfo = product.cardInfo;
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
    <script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.2.0.js" ></script>
</head>
<body>
    <div style="margin-left: 5px" >
        <div id="ticket-<%=card.Code.Trim()%>" name="ticket" class="panel panel-info" style="width:350px"  >
            <div class="panel-heading">
                <h3 class="panel-title"><%=product._fields["name"].ToString().Trim()%></h3>
            </div>
            <div class="panel-body">
                    <%=cardInfo.rules.Trim()%>
                <br />
                <div style="text-align:center" >

                    <img src="images/ticket.jpg"  id="ticket_img" onclick="show_ticket_qrcode('<%=card.Code.Trim() %>')"  style="width:200px; text-align:center"  />
                    <br />
                    <br /><b style="text-align:center" ><%=card.Code.Substring(0,3) %>-<%=card.Code.Substring(3,3) %>-<%=card.Code.Substring(6,3) %></b>
                </div>
            </div>
        </div>
    </div>
</body>
</html>