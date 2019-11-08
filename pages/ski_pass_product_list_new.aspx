<%@ Page Language="C#" %>
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

        //userToken = "efa86b2cb53ff14b4500298208effda1652c863ac117668953d4ef93f807351b4ff11040";
        openId = WeixinUser.CheckToken(userToken);
        if (openId.Trim().Equals(""))
        {
            Response.Redirect("../authorize.aspx?callback=" + currentPageUrl, true);
        }
        currentUser = new WeixinUser(WeixinUser.CheckToken(userToken));

        /*
        if (currentUser.CellNumber.Trim().Equals("") || currentUser.VipLevel < 1)
            Response.Redirect("register_cell_number.aspx?refurl=" + currentPageUrl, true);
            */

        string resort = Util.GetSafeRequestValue(Request, "resort", "万龙");
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
                currentResort = "qiaobo";
                Session["default_resort"] = currentResort;
            }
        }

        prodArr = Product.GetSkiPassList(currentResort);
    }

    


</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <!-- 新 Bootstrap 核心 CSS 文件 -->
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="css/normalize.css" />
    <!-- 可选的Bootstrap主题文件（一般不用引入） -->
    <link rel="stylesheet" href="css/bootstrap-theme.min.css">

    <script type="text/javascript" src="js/popper.min.js" ></script>
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
        var current_rent = false;
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


        function launch_book_modal(product_id) {
            fill_modal_new(product_id);
            //fill_modal();
            $("#booking_modal").modal();
        }

        function get_day_name(date) {

            var now = new Date();
            var day_name = "";
            if (now.getYear() == date.getYear() && now.getMonth() == date.getMonth() && now.getDate() == date.getDate()) {
                day_name = "今天";
            }
            now = new Date(now.valueOf() + 1000 * 3600 * 24);
            if (now.getYear() == date.getYear() && now.getMonth() == date.getMonth() && now.getDate() == date.getDate()) {
                day_name = "明天";
            }
            now = new Date(now.valueOf() + 1000 * 3600 * 24);
            if (now.getYear() == date.getYear() && now.getMonth() == date.getMonth() && now.getDate() == date.getDate()) {
                day_name = "后天";
            }
            now = new Date(now.valueOf() + 1000 * 3600 * 24);
            if (now.getYear() == date.getYear() && now.getMonth() == date.getMonth() && now.getDate() == date.getDate()) {
                day_name = "大后天";
            }
            if (date.getMonth() == 11 && date.getDate() == 30) {
                day_name = day_name + " 元旦";
            }
            if (date.getMonth() == 1 && date.getDate() == 2) {
                day_name = day_name + " 平日";
            }
            if (date.getMonth() == 1 && date.getDate() == 3) {
                day_name = day_name + " 平日";
            }
            if (date.getMonth() == 1 && date.getDate() == 4) {
                day_name =  "除夕";
            }
            if (date.getMonth() == 1 && date.getDate() == 5) {
                day_name = "初一";
            }
            if (date.getMonth() == 1 && date.getDate() == 6) {
                day_name = "初二";
            }
            if (date.getMonth() == 1 && date.getDate() == 7) {
                day_name = "初三";
            }
            if (date.getMonth() == 1 && date.getDate() == 8) {
                day_name = "初四";
            }
            if (date.getMonth() == 1 && date.getDate() == 9) {
                day_name = "初五";
            }
            if (date.getMonth() == 1 && date.getDate() == 10) {
                day_name = "初六";
            }





            return day_name;
        }

        function get_week_day(date) {
            var now = new Date();
            var week_day_name = "周一";
            switch (date.getDay()) {
                case 0:
                    week_day_name = "周日";
                    break;
                case 1:
                    week_day_name = "周一";
                    break;
                case 2:
                    week_day_name = "周二";
                    break;
                case 3:
                    week_day_name = "周三";
                    break;
                case 4:
                    week_day_name = "周四";
                    break;
                case 5:
                    week_day_name = "周五";
                    break;
                case 6:
                    week_day_name = "周六";
                    break;
                default:
                    break;
            }
            return week_day_name;
        }

        function book_ski_pass() {

            var cart_json = '';

            var pass_json = '{ "product_id": "' + current_product_id + '", "count": "' + current_num + '" }';
            var rent_json = '';
            if (current_rent) {
                var rent_productid = "14";
                if (current_title.indexOf("南山") >= 0) {
                    rent_productid = "14";
                }
                if (current_title.indexOf("乔波") >= 0) {
                    rent_productid = "8";
                }

                rent_json = '{ "product_id": "' + rent_productid + '", "count": "' + current_num + '" }';
            }

            cart_json = '{"cart_array" : [' + pass_json + ((rent_json != '') ? (', ' + rent_json) : '') + '], "memo" : {'
                + '"rent" : "' + (current_rent ? '1' : '0') + '", "use_date" : "' + current_date + '"   }}';

            

            $.ajax({
                url: "/api/place_online_order.aspx",
                async: false,
                type: "GET",
                data: { "cart": cart_json, "token": "<%=userToken%>" },
                success: function(msg, status) {
                    var msg_object = eval("(" + msg + ")");
                    window.location.href = "../payment/payment.aspx?product_id=" + msg_object.order_id;
                }
            });
        }

        function select_date(date, day_name, title) {
            current_date = date;
            current_day_name = day_name;
            if ((day_name.indexOf("周六") >=0 || day_name.indexOf("周日") >= 0) && (day_name.indexOf("平日") < 0) ) {
            //if (day_name.indexOf("周日") >= 0) {
                current_product_id = product_id_weekend;
                current_title = product_title_weekend;
                current_price = product_price_weekend;
            }
            else if (day_name.indexOf("除夕") >= 0 || day_name.indexOf("初") >= 0 || day_name.indexOf("元旦") >= 0) {
                current_product_id = product_id_holiday;
                current_title = product_title_holiday;
                current_price = product_price_holiday;
            }
            else {
                current_product_id = product_id_work_day;
                current_title = product_title_work_day;
                current_price = product_price_work_day;
            }


            if (title.indexOf("夜场") >= 0 && title.indexOf("八易") >= 0) {
                if (day_name.indexOf("周五") >= 0) {
                    current_product_id = product_id_weekend;
                    current_title = product_title_weekend;
                    current_price = product_price_weekend;
                }
                if (day_name.indexOf("周日") >= 0) {
                    current_product_id = product_id_work_day;
                    current_title = product_title_work_day;
                    current_price = product_price_work_day;
                }
            }


            fill_modal();
        }

        function select_num(num) {
            current_num = num;
            fill_modal();
        }

        function select_rent() {
            var rent_box = document.getElementById("rent_box");
            if (rent_box.checked) {
                current_rent = true;
            }
            else {
                current_rent = false;
            }
            fill_modal()
        }

        function fill_modal_new(product_id) {

            $.ajax({
                url: "/api/get_product_info.aspx?type=resort_ski_pass&id=" + product_id,
                method: "GET",
                async: false,
                success: function (msg, status) {
                    var msg_obj = eval("(" + msg + ")");
                    if (msg_obj.status == 0) {
                        product_obj = msg_obj.resort_ski_pass;
                    }
                }
            });
            var today_is_available = false;
            var current_date_time = new Date();
            var end_sale_time_string_arr = product_obj.end_sale_time.split(':');
            var end_sale_time = new Date();
            end_sale_time.setMinutes(60 * parseInt(end_sale_time_string_arr[0]) + parseInt(end_sale_time[1]));
            if (current_date_time < end_sale_time) {
                today_is_available = true;
            }
            var start_selected_date = current_date_time;
            if (!today_is_available) {
                start_selected_date.setDate(current_date_time.getDate() + 1);
            }
            document.getElementById("current_date").innerHTML = start_selected_date.getFullYear().toString() + '-'
                + (start_selected_date.getMonth() + 1).toString() + '-' + start_selected_date.getDate().toString();
            var temp_inner_html = '';
            for (var i = 0; i < 5; i++) {
                temp_inner_html = temp_inner_html + '<a href="#" class="dropdown-item"  >' + start_selected_date.getFullYear().toString() + '-'
                    + (start_selected_date.getMonth() + 1).toString() + '-' + start_selected_date.getDay().toString() + '</a>';
                start_selected_date.setDate(start_selected_date.getDate() + 1);
            }
            document.getElementById("drop-down-date-menu").innerHTML = temp_inner_html;
        }

        function fill_modal() {




            var span_modal_header = document.getElementById("modal-header");
            var span_current_num = document.getElementById("current_num");
            span_modal_header.innerHTML = current_title + "&nbsp;&nbsp;&nbsp;&nbsp;单价：<font color='red' >" + current_price + "</font>元";
            
                
            span_current_num.innerHTML = current_num;
            var rent_box = document.getElementById("rent");
            rent_box.checked = current_rent;
            var div_summary = document.getElementById("summary");
            var rent_cash = current_title.indexOf("南山") >= 0 ? 200 : 400;
            if (current_title.indexOf("八易") >= 0) {
                document.getElementById("rent").disabled = true;
            }
            if (current_title.indexOf("乔波") >= 0) {
                current_rent = true;
                rent_cash = 200;
            }
            var summary_amount = (parseInt(current_price) + (current_rent ? rent_cash : 0)) * parseInt(current_num);
            if (current_title.indexOf("南山") >= 0) {
                div_summary.innerHTML = "(雪票￥" + (parseInt(current_price) - 100).toString() + (current_rent ? (" + 押金￥" + (parseInt(rent_cash) + 100).toString()) : " + 押金￥100") + ") x " + current_num + "人 = <font color='red' >" + summary_amount + "</font>";
            }
            if (current_title.indexOf("八易") >= 0) {
                if (current_title.indexOf("租") >= 0) {
                    div_summary.innerHTML = "(雪票￥" + (parseInt(current_price) - 200).toString() + " + 押金￥200" + ") x " + current_num + "人 = <font color='red' >" + summary_amount + "</font>";
                }
                else {
                    div_summary.innerHTML = "雪票￥" + parseInt(current_price).toString() + " x " + current_num + "人 = <font color='red' >" + summary_amount + "</font>";
                    
                }
            }
            if (current_title.indexOf("乔波") >= 0) {
                document.getElementById("rent").style.display = "none";
            }
        }
    </script>
</head>
<body>
    <div>
        <ul class="nav nav-tabs" >
            <li class="nav-item">
                <a class=nav-link" href="ski_pass_product_list.aspx?resort=<%=Server.UrlEncode("万龙") %>" >万龙</a>
            </li>
           
        </ul>
        <%
            foreach (Product p in prodArr)
            {
             %>
        <br />
        <div id="ticket-1" name="ticket" class="panel panel-success" style="width:350px" onclick="launch_book_modal('<%=p._fields["id"].ToString().Trim() %>')" >
            <div class="panel-heading">
                <h3 class="panel-title"><%=p._fields["name"].ToString() %></h3>
            </div>
            <div class="panel-body">
                <%=p._fields["rules"].ToString().Trim() %>
            </div>
        </div>
        <%} %>

        <div id="booking_modal" class="modal fade bs-example-modal-lg" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header" id="modal-header" >测试</div>
                    <div class="modal-body" >
                        <div>日期：<span class="dropdown">
                                <button class="btn btn-secondary btn-sm dropdown-toggle" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" id="dropdownSelectDate" >
                                    <span id="current_date" ></span>
                                    <span class="caret"></span>
                                </button>
                                <div class="dropdown-menu" aria-labelledby="dropdownMenuButton" id="drop-down-date-menu" ></div>
                            </span>
                        </div>
			            <br/>
                        <div>
                            人数：<%if (!currentResort.Trim().Equals("haixuan"))
                                   { %><span class="dropdown" >
                                <button class="btn btn-default dropdown-toggle" type="button" id="dropdownSelectNum" data-toggle="dropdown">
                                    <span id="current_num" >1</span>
                                    <span class="caret"></span>
                                </button>
                                <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1"  >
                                    <li role="presentation"><a role="menuitem" tabindex="-1" href="#" onclick="select_num(1)" >1</a></li>
                                    <li role="presentation"><a role="menuitem" tabindex="-1" href="#" onclick="select_num(2)" >2</a></li>
                                    <li role="presentation"><a role="menuitem" tabindex="-1" href="#" onclick="select_num(3)" >3</a></li>
                                    <li role="presentation"><a role="menuitem" tabindex="-1" href="#" onclick="select_num(4)" >4</a></li>
                                    <li role="presentation"><a role="menuitem" tabindex="-1" href="#" onclick="select_num(5)" >5</a></li>
                                </ul>
                            </span>
                            <%}
                                else
                                {
                                    %>
                            <span id="current_num" >1</span>
                                        <%
                                } %>
                        </div>
			            <br/>
                      
                        <div id="rent"  <% if (currentResort.Trim().Equals("nanshan"))
                            { %> style="display:block" <%}
                            else {%>  style="display:none" <% } %> ><input type="checkbox" id="rent_box" onclick="select_rent()" />我要租板</div>
                       
                        <div id="summary" >小计：</div>
                    </div>
                    <div class="modal-footer" ><button type="button" class="btn btn-default" onclick="book_ski_pass()"> 确 认 预 定 </button></div>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript" >

        /*
        var product_obj;

        var date_to_be_selected_start = new Date();
        date_to_be_selected_start.setDate(date_to_be_selected_start.getDate() + 1);
        */
        //var resort = '<%=currentResort%>';
        /*
        var current_date_time = new Date();
        var url = "/api/get_ski_pass_product.aspx?skidate=" + current_date_time.getFullYear().toString() + "-"
            + (current_date_time.getMonth() + 1).toString() + "-" + current_date_time.getDay().toString()
            + "&resort=" + resort;

        $.ajax({
            url: url,
            method: "GET",
            success: function (msg, status) {
                var msg_obj = eval("(" + msg + ")");
                for (var i = 0; i < msg_obj.product_arr.length; i++) {
                    var end_sale_time_str_arr = msg_obj.product_arr[i].end_sale_time.toString().split(':');
                    var end_sale_time = current_date_time.setMinutes(60 * parseInt(end_sale_time_str_arr[0]) + parseInt(end_sale_time_str_arr[1]));
                    //end_sale_time = end_sale_time.setMinutes(parseInt(end_sale_time_str_arr[1]));
                    if (current_date < end_sale_time) {
                        date_to_be_selected_start = date_to_be_selected_start.setDate(date_to_be_selected_start.getDate() - 1);
                        break;
                    }
                    var drop_down_date_menu = document.getElementById("drop-down-date-menu");
                    var temp_inner_html = "";
                    document.getElementById("current_date").innerHTML = date_to_be_selected_start.getFullYear().toString()
                        + '-' + (1+date_to_be_selected_start.getMonth()).toString() + '-' + date_to_be_selected_start.getDay().toString();
                    for (var i = 0; i < 5; i++) {
                        temp_inner_html = temp_inner_html + '<a href="#" class="dropdown-item"  >' + date_to_be_selected_start.getFullYear().toString() + '-'
                            + (date_to_be_selected_start.getMonth() + 1).toString() + '-' + date_to_be_selected_start.getDay().toString() + '</a>';
                        date_to_be_selected_start.setDate(date_to_be_selected_start.getDay() + 1);
                    }
                    drop_down_date_menu.innerHTML = temp_inner_html;
                    
                }
                
            }
        });*/
    </script>
</body>
</html>
