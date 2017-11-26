<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    public string shop = "万龙";

    public string openId = "";

    public string userToken = "";

    public WeixinUser currentUser;

    public int productId = 12;

    protected void Page_Load(object sender, EventArgs e)
    {
        shop = Util.GetSafeRequestValue(Request, "shop", "万龙").Trim();
        if (shop.Trim().Equals(""))
            shop = "万龙";
        string currentPageUrl = Server.UrlEncode("/pages/offer.aspx?shop=" + Server.UrlEncode(shop));
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

        switch (shop)
        {
            case "南山":
                productId = 15;
                break;
            case "八易":
                productId = 16;
                break;
            default:
                productId = 12;
                break;
        }
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
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
        function confirm_offer() {
            var amount = 0;
            try{
                amount = parseInt(Math.round(parseFloat(document.getElementById("amount").value.trim()) * 100, 0));
            }
            catch (exp) {

            }
            if (amount > 0) {
                offer_pay(amount);
            }

        }

        function offer_pay(amount) {
            var product_id = <%=productId%>;
            var cart_json = '{"cart_array": [{"product_id": ' + product_id + ', "count":' + amount + '}  ]}';
            $.ajax({
                url: "/api/place_online_order.aspx?token=<%=userToken%>&cart=" + cart_json.trim(),
                async: false,
                type: "GET",
                success: function(msg, status) {
                    var msg_object = eval("(" + msg + ")");
                    if (msg_object.status == "0") {
                        var order_id = msg_object.order_id;
                        window.location.href = "../payment/haojin_pay_online_order.aspx?orderid=" + order_id;
                    }
                }
            });
        }
    </script>
</head>
<body>
    <div class="row" >
        <div class="col-xs-1" ><br /></div>
    </div>
    <div class="row">
        <div class="col-xs-3">打赏金额：</div>
        <div class="col-xs-6"><input type="text" id="amount" /></div>
    </div>
    <div class="row" >
        <div class="col-xs-1" ><br /></div>
    </div>
    <div class="row" >
        <div class="col-md-12" ><button onclick="confirm_offer()" >确定打赏</button></div>
    </div>
</body>
</html>
