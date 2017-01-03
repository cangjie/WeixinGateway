<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    public string currentResort = "nanshan";

    public Product[] prodArr;

    public WeixinUser currentUser;

    public string openId = "";

    public string userToken = "";

    protected void Page_Load(object sender, EventArgs e)
    {

        string currentPageUrl = Server.UrlEncode("/pages/ski_pass_product_list.aspx");
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
        

        string resort = Util.GetSafeRequestValue(Request, "resort", "");
        if (!resort.Trim().Equals(""))
        {
            currentResort = resort;
            Session["default_resort"] = currentResort;
        }
        else
        {
            if (Session["default_resort"] != null && !Session["default_resort"].ToString().Equals(""))
            {
                currentResort = Session["default_resort"].ToString().Trim();
            }
            else
            {
                currentResort = "nanshan";
                Session["default_resort"] = currentResort;
            }
        }

        prodArr = Product.GetSkiPassList(currentResort);
        /*
        if (Session["default_resort"] == null || Session["default_resort"].ToString().Equals("") || resort.Trim().Equals(""))
        {
            Session["default_resort"] = "nanshan";
        }
        */
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

        var current_product_id = "0";
        var current_title = "";
        var current_date = "<% = ((DateTime.Now.Hour < 8)? (DateTime.Now.ToShortDateString()+"今日") : (DateTime.Now.AddDays(1)+"明日"))%>";
        var current_num = "";
        var current_rent = "0";

        document.getElementById("current_date").innerText = current_date;

        function launch_book_modal(product_id, title) {
            document.getElementById("modal-header").innerText = title;
            $("#booking_modal").modal();
        }

        function book_ski_pass(product_id) {
            var cart_json = '{"cart_array" : [{"product_id" : "' + product_id + '", "count" : "1"}]}';
            $.ajax({
                url:    "/api/place_online_order.aspx",
                async:  false,
                type:   "GET",
                data:   {"cart":cart_json,"token":"<%=userToken%>"},
                success: function(msg, status) {
                    var msg_object = eval("(" + msg + ")");
                    window.location.href = "../payment/haojin_pay_online_order.aspx?orderid=" + msg_object.order_id;
            }
            });
        }

    </script>
</head>
<body>
    <div>
        <ul class="nav nav-tabs" role="tablist">
            <li role="presentation" <%if (currentResort.Trim().Equals("nanshan"))
                { %> class="active" <%}  %> ><a href="ski_pass_product_list.aspx?resort=nanshan">南山</a></li>
            <li role="presentation" <%if (currentResort.Trim().Equals("bayi"))
                { %> class="active" <%}  %> ><a href="ski_pass_product_list.aspx?resort=bayi">八易</a></li>
        </ul>
        <%
            foreach (Product p in prodArr)
            {



             %>
        <br />
        <div id="ticket-1" name="ticket" class="panel panel-success" style="width:350px" onclick="launch_book_modal('<%=p._fields["id"].ToString() %>','<%=p._fields["name"].ToString() %>' )" >
            <div class="panel-heading">
                <h3 class="panel-title"><%=p._fields["name"].ToString() %></h3>
            </div>
            <div class="panel-body">
                <ul>
                    <li>价格：<font color="red" ><%=p._fields["sale_price"].ToString() %></font>元。</li>
                    <li><font color="red" >购买后第二日自动出票。</font></li>
                    <li>请看清雪票的使用时段。</li>
                    <li>一旦下单，不退不换。</li>
                    <%
                        if (currentResort.Trim().Equals("nanshan"))
                        {
                            %>
                    <li>如需租赁雪具，请带好足够的押金或者证件。</li>
                    <li>门票自理，自行到店出票。</li>
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
        <%} %>

        <div id="booking_modal" class="modal fade bs-example-modal-lg" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header" id="modal-header" >测试</div>
                    <div class="modal-body" >
                        <div>日期：<span class="dropdown">
                                <button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown">
                                    <span id="current_date" >2017-1-3 今日</span>
                                    <span class="caret"></span>
                                </button>
                                <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
                                    <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Action</a></li>
                                    <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Another action</a></li>
                                    <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Something else here</a></li>
                                    <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Separated link</a></li>
                                </ul>
                            </span>
                        </div>
			            <br/>
                        <div>
                            人数：<input id="num" value="1" style="width:50px" type="text" />
                        </div>
			            <br/>
                        <div><input type="checkbox" id="rent" />我要租板</div>
                    </div>
                    <div class="modal-footer" ><button type="button" class="btn btn-default"> 确 认 预 定 </button></div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
