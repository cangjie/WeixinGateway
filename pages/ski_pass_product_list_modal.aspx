﻿<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    public string currentResort = "nanshan";

    public Product[] prodArr;

    public WeixinUser currentUser;

    public string openId = "";

    public string userToken = "";

    public KeyValuePair<DateTime, string>[] selectedDate = new KeyValuePair<DateTime, string>[5];

    

    protected void Page_Load(object sender, EventArgs e)
    {

        FillSelectedDate();
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

    public void FillSelectedDate()
    {
        DateTime startDate = DateTime.Now;
        if (DateTime.Now.Hour >= 8)
        {
            startDate = startDate.AddDays(1);
        }
        for (int i = 0; i < 5; i++)
        {
            string dayName = "今天";
            switch (startDate.DayOfWeek)
            {
                case DayOfWeek.Sunday:
                    dayName = "周日";
                    break;
                case DayOfWeek.Monday:
                    dayName = "周一";
                    break;
                case DayOfWeek.Tuesday:
                    dayName = "周二";
                    break;
                case DayOfWeek.Wednesday:
                    dayName = "周三";
                    break;
                case DayOfWeek.Thursday:
                    dayName = "周四";
                    break;
                case DayOfWeek.Friday:
                    dayName = "周五";
                    break;
                case DayOfWeek.Saturday:
                    dayName = "周六";
                    break;
                default:
                    break;
            }
            if (startDate.Day == DateTime.Now.AddDays(1).Day && !dayName.Equals("周六") && !dayName.Equals("周日"))
                dayName = "明天";
            if (startDate.Day == DateTime.Now.AddDays(2).Day && !dayName.Equals("周六") && !dayName.Equals("周日"))
                dayName = "后天";
            switch (startDate.Year.ToString()+"-"+startDate.Month.ToString()+"-"+startDate.Day.ToString())
            {
                case "2017-1-27":
                    dayName = "除夕";
                    break;
                case "2017-1-28":
                    dayName = "初一";
                    break;
                case "2017-1-29":
                    dayName = "初二";
                    break;
                case "2017-1-30":
                    dayName = "初三";
                    break;
                case "2017-1-31":
                    dayName = "初四";
                    break;
                case "2017-2-1":
                    dayName = "初五";
                    break;
                case "2017-2-2":
                    dayName = "初六";
                    break;
                default:
                    break;
            }
            selectedDate[i] = new KeyValuePair<DateTime, string>(startDate, dayName.Trim());
            startDate = startDate.AddDays(1);
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
    <script type="text/javascript" >

        var current_product_id = "0";
        var current_title = "";
        var current_date = "<%=selectedDate[0].Key.ToShortDateString()%>";
        var current_num = "1";
        var current_rent = "0";
        var current_day_name = "<%=selectedDate[0].Value%>";
        var current_price = 0;

        var product_id_work_day = 0;
        var product_title_work_day = "";
        var product_price_work_day = 0;

        var product_id_weekend = 0;
        var product_title_weekend = "";
        var product_price_weekend = 0;

        var product_id_holiday = 0;
        var product_title_holiday = "";
        var product_price_holiday = 0;
        

        function launch_book_modal(product_id, title) {
            $.ajax({
                url:        "/api/get_associate_product.aspx?productid=" + product_id,
                async:      false,
                type: "GET",
                success: function (msg, status) {
                    var msg_object = eval("(" + msg + ")");
                    if (msg_object.status == "0") {

                        product_id_holiday = msg_object.holiday_product.id;
                        product_title_holiday = msg_object.holiday_product.title;
                        product_price_holiday = msg_object.holiday_product.price;

                        product_id_weekend = msg_object.weekend_product.id;
                        product_title_weekend = msg_object.weekend_product.title;
                        product_price_weekend = msg_object.weekend_product.price;

                        product_id_work_day = msg_object.workday_product.id;
                        product_title_work_day = msg_object.workday_product.title;
                        product_price_work_day = msg_object.workday_product.price;

                    }
                }
            });
            fill_modal();
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

        function select_date(date, day_name) {
            current_date = date;
            current_day_name = day_name;
            if (day_name == "周六" || day_name == "周日" ) {
                current_product_id = product_id_weekend;
                current_title = product_title_weekend;
                current_price = product_price_weekend;
            }
            else if (day_name == "除夕" || day_name.indexOf("初") >=0 ) {
                current_product_id = product_id_holiday;
                current_title = product_title_holiday;
                current_price = product_price_holiday;
            }
            else {
                current_product_id = product_id_work_day;
                current_title = product_title_work_day;
                current_price = product_price_work_day;
            }
        }

        function select_num(num) {
            current_num = num;
        }

        function fill_modal() {
            var span_modal_header = document.getElementById("modal-header");
            var span_current_date = document.getElementById("current_date");
            var span_current_num = document.getElementById("current_num");
            span_modal_header.innerHTML = current_title + "&nbsp;&nbsp;&nbsp;&nbsp;单价：<font color='red' >" + current_price + "</font>元";

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
                                <button class="btn btn-default dropdown-toggle" type="button" id="dropdownSelectDate" data-toggle="dropdown">
                                    <span id="current_date" ><%=selectedDate[0].Key.ToShortDateString()%> <%=selectedDate[0].Value.Trim() %></span>
                                    <span class="caret"></span>
                                </button>
                                <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
                                    <li role="presentation"><a role="menuitem" tabindex="-1" href="#" onclick="select_date('<%= selectedDate[0].Key.ToShortDateString()%>', '<%= selectedDate[0].Value.Trim()%>')"><%=selectedDate[0].Key.ToShortDateString()%> <%=selectedDate[0].Value.Trim() %></a></li>
                                    <li role="presentation"><a role="menuitem" tabindex="-1" href="#" onclick="select_date('<%= selectedDate[1].Key.ToShortDateString()%>', '<%= selectedDate[1].Value.Trim()%>')"><%=selectedDate[1].Key.ToShortDateString()%> <%=selectedDate[1].Value.Trim() %></a></li>
                                    <li role="presentation"><a role="menuitem" tabindex="-1" href="#" onclick="select_date('<%= selectedDate[2].Key.ToShortDateString()%>', '<%= selectedDate[2].Value.Trim()%>')"><%=selectedDate[2].Key.ToShortDateString()%> <%=selectedDate[2].Value.Trim() %></a></li>
                                    <li role="presentation"><a role="menuitem" tabindex="-1" href="#" onclick="select_date('<%= selectedDate[3].Key.ToShortDateString()%>', '<%= selectedDate[3].Value.Trim()%>')"><%=selectedDate[3].Key.ToShortDateString()%> <%=selectedDate[3].Value.Trim() %></a></li>
                                    <li role="presentation"><a role="menuitem" tabindex="-1" href="#" onclick="select_date('<%= selectedDate[4].Key.ToShortDateString()%>', '<%= selectedDate[4].Value.Trim()%>')"><%=selectedDate[4].Key.ToShortDateString()%> <%=selectedDate[4].Value.Trim() %></a></li>
                                </ul>
                            </span>
                        </div>
			            <br/>
                        <div>
                            人数：<span class="dropdown" >
                                <button class="btn btn-default dropdown-toggle" type="button" id="dropdownSelectNum" data-toggle="dropdown">
                                    <span id="current_num" >1</span>
                                    <span class="caret"></span>
                                </button>
                                <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
                                    <li role="presentation"><a role="menuitem" tabindex="-1" href="#" onclick="select_num(1)" >1</a></li>
                                    <li role="presentation"><a role="menuitem" tabindex="-1" href="#" onclick="select_num(2)" >2</a></li>
                                    <li role="presentation"><a role="menuitem" tabindex="-1" href="#" onclick="select_num(3)" >3</a></li>
                                    <li role="presentation"><a role="menuitem" tabindex="-1" href="#" onclick="select_num(4)" >4</a></li>
                                    <li role="presentation"><a role="menuitem" tabindex="-1" href="#" onclick="select_num(5)" >5</a></li>
                                </ul>
                            </span>
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
