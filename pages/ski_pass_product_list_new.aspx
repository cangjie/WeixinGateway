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


        function launch_book_modal(product_id, title) {
            $.ajax({
                url: "/api/get_associate_product.aspx?productid=" + product_id,
                async: false,
                type: "GET",
                success: function(msg, status) {
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

            var now = new Date();
            /*
            if (title.indexOf("八易")>=0) {
                if (title.indexOf("夜场") >= 0) {
                    if (now.getHours() >= 17) {
                        now = new Date(now.valueOf() + 3600 * 24 * 1000);
                    }
                }
                else {
                    
                    if (now.getHours() > 8 || (now.getHours() == 8 && now.getMinutes() >= 30)) {
                        now = new Date(now.valueOf() + 3600 * 24 * 1000);
                    }
                    
                }
            }
            */
            if (title.indexOf("南山") >= 0) {
                if (title.indexOf("夜场") >= 0) {
                    if (title.indexOf("下午") >= 0) {
                        if (now.getHours() > 7 || (now.getHours == 7 && now.getMinutes() >= 30)) {
                            now = new Date(now.valueOf() + 3600 * 24 * 1000);
                        }
                    }
                    else {
                        if (now.getHours() >= 15) {
                            now = new Date(now.valueOf() + 3600 * 24 * 1000);
                        }
                    }
                }
                else {
                    if (now.getHours() > 7 || (now.getHours() == 7 && now.getMinutes() >= 30)) {
                        now = new Date(now.valueOf() + 3600 * 24 * 1000);
                    }
                }
            }

            if (title.indexOf("八易") >= 0) {
                if (title.indexOf("夜场") >= 0) {
                    if ((now.getHours() == 15 && now.getMinutes() >= 30) || now.getHours() > 15) {
                            now = new Date(now.valueOf() + 3600 * 24 * 1000);
                    }
                    
                }
                else {
                    if ((now.getHours() == 8 && now.getMinutes() >= 30) || now.getHours() > 8) {
                        now = new Date(now.valueOf() + 3600 * 24 * 1000);
                    }
                }
            }

            var day_name = get_day_name(now);
            var week_day = get_week_day(now);


            var drop_down_date = document.getElementById("drop-down-date");


            drop_down_date.innerHTML = "";

            if (title.indexOf("海选") >= 0) {
                var iDate = new Date(Date.parse("2019-1-24"));
                if (title.indexOf("24") >= 0) {
                    iDate = new Date(Date.parse("2019-1-24"));
                }
                if (title.indexOf("26") >= 0) {
                    iDate = new Date(Date.parse("2019-1-26"));
                }
                if (title.indexOf("27") >= 0) {
                    iDate = new Date(Date.parse("2019-1-27"));
                }
                if (title.indexOf("30") >= 0) {
                    iDate = new Date(Date.parse("2019-1-30"));
                }
                var iDayName = get_day_name(iDate);
                current_date = iDate.getFullYear() + "/" + (iDate.getMonth() + 1) + "/" + iDate.getDate();
                current_day_name = get_week_day(iDate) + (iDayName == "" ? "" : "(" + iDayName + ")");
                drop_down_date.innerHTML = drop_down_date.innerHTML
                        + "<li role=\"presentation\" ><a role=\"menuitem\" tabindex=\"-1\" href=\"#\" onclick=\"select_date('"

                        + iDate.getFullYear() + "/" + (iDate.getMonth() + 1) + "/" + iDate.getDate() + "', '"
                        + get_week_day(iDate) + (iDayName == "" ? "" : "(" + iDayName + ")")
                        + "', '" + title + "')\" >" + +iDate.getFullYear() + "/" + (iDate.getMonth() + 1) + "/" + iDate.getDate() + " "
                        + get_week_day(iDate) + (iDayName == "" ? "" : "(" + iDayName + ")") + "</a></li>";
                current_date = iDate.getFullYear() + "/" + (iDate.getMonth() + 1) + "/" + iDate.getDate();
                current_day_name = get_week_day(iDate) + (iDayName == "" ? "" : "(" + iDayName + ")");
                document.getElementById("current_date").innerHTML = current_date + " " + current_day_name;
                select_date(iDate, current_day_name, title);
            }
            else {
                for (var i = 0; i < 5; i++) {
                    var iDate = new Date(now.valueOf() + 1000 * 3600 * 24 * i);
                    var iDayName = get_day_name(iDate);

                    drop_down_date.innerHTML = drop_down_date.innerHTML
                        + "<li role=\"presentation\" ><a role=\"menuitem\" tabindex=\"-1\" href=\"#\" onclick=\"select_date('"

                        + iDate.getFullYear() + "/" + (iDate.getMonth() + 1) + "/" + iDate.getDate() + "', '"
                        + get_week_day(iDate) + (iDayName == "" ? "" : "(" + iDayName + ")")
                        + "', '" + title + "')\" >" + +iDate.getFullYear() + "/" + (iDate.getMonth() + 1) + "/" + iDate.getDate() + " "
                        + get_week_day(iDate) + (iDayName == "" ? "" : "(" + iDayName + ")") + "</a></li>";
                    if (i == 0) {
                        current_date = iDate.getFullYear() + "/" + (iDate.getMonth() + 1) + "/" + iDate.getDate();
                        current_day_name = get_week_day(iDate) + (iDayName == "" ? "" : "(" + iDayName + ")");
                        document.getElementById("current_date").innerHTML = current_date + " " + current_day_name;
                    }

                }
                select_date(current_date, current_day_name, title);
                
            }
           
            
            fill_modal();
            
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

        function fill_modal() {
            var span_modal_header = document.getElementById("modal-header");
            var span_current_date = document.getElementById("current_date");
            var span_current_num = document.getElementById("current_num");
            span_modal_header.innerHTML = current_title + "&nbsp;&nbsp;&nbsp;&nbsp;单价：<font color='red' >" + current_price + "</font>元";
            try{
                span_current_date.innerHTML = current_date.toLocaleDateString() + " " + current_day_name;
            }
            catch(err){
                span_current_date.innerHTML = current_date + " " + current_day_name;
            }
                
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
        <div id="ticket-1" name="ticket" class="panel panel-<%
            if (p._fields["name"].ToString().Trim().IndexOf("夜场") >= 0)
            {
                Response.Write("info");
            }
            else
            {
                Response.Write("success");
            }%>" style="width:350px" onclick="launch_book_modal('<%=p._fields["id"].ToString().Trim() %>','<%=p._fields["name"].ToString().Trim() %>' )" >
            <div class="panel-heading">
                <h3 class="panel-title"><%=p._fields["name"].ToString() %></h3>
            </div>
            <div class="panel-body">
                
                <%
                    if (p._fields["name"].ToString().IndexOf("南山")>=0)
                    {


                     %>
                <p>雪票价格：<font color="red" ><%=int.Parse(p._fields["sale_price"].ToString()) - 100 %></font>元。</p>
                <p><font color="red" ><b>自带板，押金100元。</b></font></p>
                <p>租板，押金300元。</p>
                <p>价格包括：门票、滑雪、<font color='red' ><b>押金100元</b></font>、缆车、拖牵、魔毯费用、（如租板，则包含雪具使用）。</p>
                <p>如需租用雪板、雪鞋、雪杖以外的物品，如头盔、雪镜、雪服等物品，请额外准备现金，押金 100元/件。</p>
                <p>使用说明：</p>
                <ul>
                    <li><font color="red" >出票日自动出票。</font></li>
                    <li>到达代理商入口请拨打：13693171170，将有工作人员接您入场。</li>
                    <li>来店请出示二维码验票、取票。</li>
                    <li>此票售出后不予退换。</li>
                </ul>
                <p>雪场地址：<br />北京市密云区河南寨镇圣水头村南山滑雪场<br />客服电话：13693171170</p>
                <%
                    }
                    if (p._fields["name"].ToString().IndexOf("八") >= 0)
                    {

                        %>
                
                <%
                    if (p._fields["name"].ToString().IndexOf("租") >= 0)
                    {
                        %>
                <p>雪票价格：<%=int.Parse(p._fields["sale_price"].ToString()) - 200 %></p>
                <p>租板押金：200元</p>
                            <%
                                }
                                else
                                {
                                    %>
                <p>雪票价格：<%=p._fields["sale_price"].ToString().Trim() %></p>
                                        <%
                                }
                     %>
                <p>价格包括：滑雪、缆车、拖牵、魔毯费用。（不包含保险，保险请在窗口另行购买）</p>
                <p>使用说明：</p>
                <ul>
                    <%
                        if (p._fields["name"].ToString().IndexOf("海选") >= 0)
                        {
                            %>
                    <li><font color="red" >参加八易单板平花海选用户购票专用，其他人员购票无效且不退换。</font></li>
                    <%
                        }
                         %>
                    <li><font color="red" >出票日自动出票。</font></li>
                    <li>前往易龙雪聚八易店出示二维码验票、取票。</li>
                    <li>此票售出后不予退换。</li>
                    <%
                        if (p._fields["name"].ToString().IndexOf("半天") >= 0)
                        {
                            %>
                    <li>滑雪时间：刷第一次门禁（缆车/魔毯）开始计时
                                <%
                                    }
                                    if (p._fields["name"].ToString().IndexOf("全天") >= 0)
                                    {
                                        %>
                    <li>滑雪时间：9:00-18:00
                    <%
                        }
                        if (p._fields["name"].ToString().Trim().IndexOf("夜场") >= 0)
                        {
                            %>
                    <li>滑雪时间：17:30-22:00
                                <%
                                    }
                                    if (p._fields["shop"].ToString().IndexOf("八易租") >= 0)
                                    {

                                        %>
                        。滑雪结束后，请及时归还雪具，若超出租赁时间，按1元/分钟/套收取超时费。</li>
                        <li>
                            <%
                                if (p._fields["shop"].ToString().IndexOf("单") >= 0)
                                {
                                 %>
                            租单板雪卡只可用于单板器材使用，不可调换双板器材。雪具使用过程中造成损坏、丢失，需按照雪场相关规定进行赔偿。
                        <%
                                }
                                else
                                {
                                    %>
                            租单板雪卡只可用于双板器材使用，不可调换单板器材。雪具使用过程中造成损坏、丢失，需按照雪场相关规定进行赔偿。
                            <%
                                }
                            }
                                    %>
                        </li>
                        <%
                                    if (p._fields["name"].ToString().IndexOf("自助餐") >= 0)
                                    {
                                        %>
                    <li>用餐时间：17:00-21:00</li>
                                            <%
                                    }
                         %>

                    
                </ul>
                <p>雪场地址：<br />北京市丰台区射击场路甲12号万龙八易滑雪场<br />客服电话：13714100910<br />日场时间：09:00-18:00<br />夜场时间：17:30-22:00（周日-周四）；
                    <br />&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 17:30-22:30（周五、周六、
                    <br />&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 春节初一到初六、<font color='red' >除夕不营业</font>）</p>
                <%
                    }
                    if (p._fields["name"].ToString().IndexOf("乔波") >= 0)
                    {
                        %>
                    <p>押金200元。</p>
                    <p>价格包括：门票，滑雪，魔毯，拖牵，雪板，雪鞋，雪杖等费用。</p>
                    <p>注：如需租用雪服，头盔，雪镜等物品需单独从押金里面扣除相关费用。</p>
                    <p>预定须知：提前一天预定。</p>
                    <p>使用说明：</p>
                    <ul>
                        <li><font color="red" >出票日自动出票。</font></li>
                        <li>来店请出示二维码验票、取票。</li>
                        <li>滑雪结束后凭押金单在雪馆前台办理退押金手续。</li>
                        <li>此票售出后不予退换。</li>
                    </ul>
                    <p>雪场地址：<br />北京市顺义区顺安路6号<br />客服电话：15701179221</p>
                <%
                    }
                     %>
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
                                <div class="dropdown-menu" aria-labelledby="dropdownMenuButton" id="drop-down-date" ></div>
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
        var date_to_be_selected_start = new Date();
        date_to_be_selected_start = date_to_be_selected_start.setDate(date_to_be_selected_start.getDate() + 1);
        var resort = '<%=currentResort%>';
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
                    var end_sale_time = current_date_time.setHours(parseInt(end_sale_time_str_arr[0])).setMinutes(parseInt(end_sale_time_str_arr[1]));
                    if (current_date < end_sale_time) {
                        date_to_be_selected_start = date_to_be_selected_start.setDate(date_to_be_selected_start.getDate() - 1);
                        break;
                    }

                }
                
            }
        });
    </script>
</body>
</html>
