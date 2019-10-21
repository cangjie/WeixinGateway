<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<script runat="server">

    public string source = "";

    public int productId;

    public Product p;

    public string userToken = "";

    public string openId = "";

    public int paidCount = 0;

    protected void Page_Load(object sender, EventArgs e)
    {

        string currentPageUrl = Request.Url.ToString();
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



        source = Util.GetSafeRequestValue(Request, "source", "");
        productId = int.Parse(Util.GetSafeRequestValue(Request, "id", "65"));
        p = new Product(productId);

        DataTable dt = DBHelper.GetDataTable("select count(*) from order_online_detail left join order_online on order_online.[id] = order_online_id "
            + "where product_id = " + productId.ToString() + " and pay_state = 1 ");
        paidCount = int.Parse(dt.Rows[0][0].ToString().Trim());

    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>易龙雪聚-秒杀商品-<%=p._fields["name"].ToString() %></title>
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
    <div class="card">
        <div class="card-header" >
            <div class="card-title" ><%=p._fields["name"].ToString() %></div>
        </div>
        <div class="card-body" >
            价格：<%=Math.Round(double.Parse(p._fields["sale_price"].ToString()), 2).ToString() %><br />
            来源：<%=source %><br />
            已售：<%=paidCount.ToString() %><br />
            使用规则：<br />
            <%=p._fields["intro"].ToString().Trim() %>
            <button id="btn_place_order"  type="button"  onclick="place_order()" class="btn btn-xs btn-primary"> 立 刻 支 付 </button>
        </div>
    </div>
    <script type="text/javascript" >
        function place_order() {
            var cart_json = '{ "cart_array": [{ "product_id":' + <%=p._fields["id"].ToString()%> + ', "count": 1}], "memo": {"rent": 0, "use_date": "2019-11-2"}}';
            $.ajax({
                url: "/api/place_online_order.aspx",
                async: false,
                type: "GET",
                data: { "cart": cart_json, "token": "<%=userToken%>", "source": "<%=source.Trim()%>" },
                success: function(msg, status) {
                    var msg_object = eval("(" + msg + ")");
                    window.location.href = "../payment/payment.aspx?product_id=" + msg_object.order_id;
                }
            });
        }
    </script>
</body>
</html>
