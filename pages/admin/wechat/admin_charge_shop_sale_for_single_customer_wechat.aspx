<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    public WeixinUser currentUser;
    public string openId = "";
    public string userToken = "";


    public string timeStamp = "";
    public string nonceStr = "e4bf6e00dd1f0br0fcab93bd5ae8f";
    public string ticketStr = "";
    public string shaParam = "";
    public string appId = System.Configuration.ConfigurationManager.AppSettings["wxappid"];
    public string customerOpenId = "";
    public WeixinUser customerUser;
    public string cellNumber = "";

    public Ticket[] tickets;

    protected void Page_Load(object sender, EventArgs e)
    {
        customerOpenId = "";
        
        string currentPageUrl = Request.Url.ToString();
        if (!Util.GetSafeRequestValue(Request, "cell", "").Trim().Equals(""))
        {
            currentPageUrl = currentPageUrl + "?cell=" + Util.GetSafeRequestValue(Request, "cell", "").Trim();
        }

        
        if (Session["user_token"] == null || Session["user_token"].ToString().Trim().Equals(""))
        {
            Response.Redirect("../../../authorize.aspx?callback=" + currentPageUrl, true);
        }
        userToken = Session["user_token"].ToString();
        openId = WeixinUser.CheckToken(userToken);
        if (openId.Trim().Equals(""))
        {
            Response.Redirect("../../../authorize.aspx?callback=" + currentPageUrl, true);
        }
        currentUser = new WeixinUser(WeixinUser.CheckToken(userToken));

        if (!currentUser.IsAdmin)
            Response.End();
        


        timeStamp = Util.GetTimeStamp().Trim();
        ticketStr = Util.GetTicket();
        string shaString = "jsapi_ticket=" + ticketStr.Trim() + "&noncestr=" + nonceStr.Trim()
            + "&timestamp=" + timeStamp.Trim() + "&url=" + Request.Url.ToString().Trim();
        shaParam = Util.GetSHA1(shaString);
    }

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <!-- 新 Bootstrap 核心 CSS 文件 -->
    <link rel="stylesheet" href="../../css/bootstrap.min.css">
    <link rel="stylesheet" href="../../css/normalize.css" />
    <!-- 可选的Bootstrap主题文件（一般不用引入） -->
    <link rel="stylesheet" href="../../css/bootstrap-theme.min.css">
    <link type="text/css" href="../../third/alertjs/alert.css" rel="stylesheet"/>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.2.0.js" ></script>
    <script type="text/javascript" >
        var ticket_id = "";
        function select_ticket(id) {
            var ori_ticket_id = ticket_id;
            //un_select_tickets();
            var ticket = document.getElementById("ticket" + id.trim());
            if (ori_ticket_id.indexOf(id) < 0) {
                
                ticket.className = "panel panel-danger";
                ticket_id = ticket_id + ((ticket_id.trim() == '') ? '' : ',') + id;
            }
            else {
                ticket.className = "panel panel-default";
                ticket_id = ticket_id.replace(id + ",", "");
                ticket_id = ticket_id.replace("," + id, "");
                ticket_id = ticket_id.replace(id, "");
            }
        }
        function un_select_tickets() {
            var div_tickets = document.getElementsByName("ticket");
            ticket_id = "";
            for (var i = 0; i < div_tickets.length; i++) {
                div_tickets[i].className = "panel panel-default";
            }
        }

        function compute_sale_price(id) {
            var market_price = parseFloat(document.getElementById("market_price_" + id.trim()).value);
            var discount_rate = parseFloat(document.getElementById("discount_rate_" + id.trim()).value);
            if (!isNaN(market_price) && !isNaN(discount_rate)) {
                var sale_price = discount_rate * market_price / 10;
                var txt_sale_price = document.getElementById("sale_price_" + id.trim());
                txt_sale_price.value = Math.round(sale_price * 100) / 100;
                //get_product_list_json();
            }
        }

    </script>
</head>
<body>
    <table class="table table-striped">
       
        <tr>
            <td colspan="2">顾客备注：<input id="customer_memo" type="text" width="95%" value="" /></td>
        </tr>

        <tr>
            <td colspan="2" >&nbsp;</td>
        </tr>

        <tr>
            <td>收款(元)：</td>
            <td>
                <input type="text" id="txt_sale_price"  style="width:100px"    />
                <span style="color:red; width:10px; word-wrap:break-word" ></span>
            </td>
        </tr>
        
     
        <tr>
            <td>支付方式：</td>
            <td>
                <select id="pay_method" >
                    <option>微信</option>
                </select>
            </td>
        </tr>
        <tr>
            <td>门店：</td>
            <td>
                <select id="shop" >
                    <option>乔波</option>
                    <option selected >南山</option>
                    <option>八易</option>
                    <option>万龙</option>
                </select>
            </td>
        </tr>
        <tr>
            <td>订单类型：</td>
            <td>
                <select id="order_type" >
                    <option selected >店销</option>
                    <option>服务</option>
                </select>
            </td>
        </tr>
        <tr>
            <td>订单备注：</td>
            <td><textarea cols="30" rows="3" id="txt_memo" ></textarea></td>
        </tr>
        <tr>
            <td colspan="2" style="text-align:center"><button type="button" id="qrcodeBtn" class="btn btn-default" onclick="get_qrcode()"  >获取支付二维码</button></td>
        </tr>
        <tr>
            <td colspan="2" id="qrcode_td" style="text-align:center; height:300px"></td>
        </tr>
    </table>
    <!-- jQuery文件。务必在bootstrap.min.js 之前引入 -->
    <script src="../../js/jquery.min.js"></script>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="../../js/bootstrap.min.js"></script>
    <script src="../../third/alertjs/alert.js?3"></script>

    <script type="text/javascript" >


        wx.config({
            debug: false, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
            appId: '<%=appId%>', // 必填，公众号的唯一标识
            timestamp: '<%=timeStamp%>', // 必填，生成签名的时间戳
            nonceStr: '<%=nonceStr%>', // 必填，生成签名的随机串
            signature: '<%=shaParam %>', // 必填，签名，见附录1
            jsApiList: [
                    'openLocation',
                    'getLocation']
        });

        wx.ready(function () {
            wx.getLocation({
                type: 'wgs84', // 默认为wgs84的gps坐标，如果要返回直接给openLocation用的火星坐标，可传入'gcj02'
                success: function (res) {
                    var shop = document.getElementById("shop");
                    var latitude = res.latitude; // 纬度，浮点数，范围为90 ~ -90
                    var longitude = res.longitude; // 经度，浮点数，范围为180 ~ -180。
                    var speed = res.speed; // 速度，以米/每秒计
                    var accuracy = res.accuracy; // 位置精度
                    var done = false;
                    if (longitude < 115.75 && latitude > 40) {
                        //alert("万龙" + " " + longitude + " " + latitude);
                        //done = true;
                        shop.selectedIndex = 3;
                    }
                    if (longitude > 115.75 && longitude < 116.25 && latitude < 40) {
                        //alert("八易" + " " + longitude + " " + latitude);
                        //done = true;
                        shop.selectedIndex = 2;
                    }
                    if (longitude > 116.5 && longitude < 116.75 && latitude > 40 && latitude < 40.25) {
                        //alert("乔波" + " " + longitude + " " + latitude);
                        //done = true;
                        shop.selectedIndex = 0;
                    }
                    if (longitude > 116.75 && latitude > 40.25) {
                        //alert("南山" + " " + longitude + " " + latitude);
                        //done = true;
                        shop.selectedIndex = 1;
                    }
                    if (!done) {
                        //alert(longitude + " " + latitude);
                        //alert("万龙" + " " + longitude + " " + latitude);
                    }
                    //alert(latitude + " " + longitude);
                }
            });
        });

        var market_price = 0.00;
        var sale_price = 0.00;
        var ticket_amount = 0.00;
        var real_pay_price = 0.00;
        var discount_rate = 1.0;
        var score_rate = 1.0;
        var score = 0;
        var alipay_qrcode_launched = false;
        var launch_successed_info = false;
        var dialog;

        function check_valid() {
            var valid = true;
    
            sale_price = parseFloat(document.getElementById("txt_sale_price").value);
            if (isNaN(sale_price)) {
                valid = false;
            }
            
            return valid;
        }

        var order_id = 0;
        var temp_order_id = 0;
        var intervalId = 0;
        //获取二维码

        

        function get_qrcode() {
            check_valid();
            //alert(get_product_list_json());
            //return;
            
            
            var ajax_url = "../../../api/create_shop_sale_charge_qrcode.aspx?token=<%=userToken%>&marketprice="
                + sale_price.toString() + "&saleprice=" + sale_price.toString() + "&ticketamount=0" 
                + "&memo=" + document.getElementById("txt_memo").value.trim() + "&paymethod=微信"
                + "&shop=" + document.getElementById("shop").value.trim() + "&reforderdetail="  //get_product_list_json()
                + "&ticketcode=" + ticket_id.trim() + "&openid=<%=customerOpenId%>&cell=" //+ document.getElementById("cell").value.trim()
                + "&customermemo=" + document.getElementById("customer_memo").value.trim() + "&order_type=" + document.getElementById("order_type").value.trim();
          
            //alert(ajax_url);
            $.ajax({
                url: ajax_url,
                type: "GET",
                success: function (msg, status) {
                    var msg_object = eval("(" + msg + ")");
                    temp_order_id = msg_object.temp_order_id;
                    order_id = msg_object.order_id;
                    var pay_method = msg_object.pay_method;
                    var pay_url = "";
                    var qr_code_url = "";
                    var scene_text = "";
        
                    if (order_id == undefined) {
                        scene_text = "pay_temp_order_id_" + temp_order_id.toString().trim();
                    }
                    else {
                        scene_text = "pay_order_id_" + order_id.toString().trim();
                    }
                    



                    qr_code_url = "http://weixin.snowmeet.com/show_wechat_temp_qrcode.aspx?scene=" + scene_text + "&expire=300";
                    
                    
                    var td_cell = document.getElementById("qrcode_td");
                    td_cell.innerHTML = "<img style='width:200px' src='" + qr_code_url + "' />";
                    //temp_order_id = msg_object.temp_order_id;
                    if (temp_order_id != undefined || order_id != undefined)
                        intervalId = setInterval("refresh_order_state()", 1000);
                }
            });
        }

        function get_product_list_json() {
            var json = "";
            var display_new = false;
            var sum_market_price = 0;
            var sum_deal_price = 0;
            var count = 1;
            for (var i = 0; i < 5; i++) {
                var product_json = get_product_json(i);
                if (product_json.trim() == "") {
                    if (get_product_line_display_status(i) == "none" && !display_new) {
                        set_product_line_display_status(i, true);
                        document.getElementById("product_info_" + i.toString()).innerHTML = "";
                    }
                    display_new = true;
                }
                else {
                    json = json + ((json.trim() != '') ? ", " : "") + product_json.trim();
                    var product_object = eval("(" + product_json + ")");
                    count = parseInt(product_object.num);
                    sum_market_price = sum_market_price + parseFloat(product_object.market_price);
                    sum_deal_price = sum_deal_price + parseFloat(product_object.deal_price);

                }
            }

            document.getElementById("txt_market_price").value = sum_market_price;
            document.getElementById("txt_sale_price").value = sum_deal_price;

            return "{\"order_details\" : [" + json + "] }";
        }

        function get_product_json(i) {
            var json = "";
            var name = "";
            var num = 1;
            var sale_price = 0;
            var deal_price = 0;
            var info_lable = document.getElementById("product_info_" + i.toString());
            var message = "";
            try {
                name = document.getElementById("product_name_" + i.toString()).value.trim();
                if (name.trim() == "") {
                    message = "请填写正确的商品信息。";
                }
            }
            catch (err) {
                message = "请填写正确的商品信息。";
            }
            try {
                num = parseInt(document.getElementById("product_num_" + i.toString()).value);
            }
            catch (err) {
                message = "请填写正确的商品数量。";
            }
            try {
                sale_price = parseFloat(document.getElementById("market_price_" + i.toString()).value);
                if (isNaN(sale_price) || sale_price.toString() != document.getElementById("market_price_" + i.toString()).value.trim()) {
                    message = "请填写正确的零售价。";
                }
            }
            catch (err) {
                message = "请填写正确的零售价。";
            }
            try {
                deal_price = parseFloat(document.getElementById("sale_price_" + i.toString()).value);
                if (isNaN(deal_price) || deal_price != document.getElementById("sale_price_" + i.toString()).value.trim()) {
                    message = "请填写正确的成交价。";
                }
            }
            catch (err) {
                message = "请填写正确的成交价。";
            }
            if (name.trim() == "" && isNaN(sale_price) && isNaN(deal_price)) {
                document.getElementById("product_info_" + i.toString()).innerHTML
                    = "<font color='red' >" + message + "</font>";
            }
            else {
                message = "";
            }
            if (message == "") {
                json = "{\"name\": \"" + name.trim() + "\", \"num\": \"" + num.toString() + "\", \"market_price\": \"" + sale_price.toString() + "\", \"deal_price\": \"" + deal_price.toString() + "\" }";
            }
            else {
                json = "";
            }
            if (!isNaN(sale_price) && !isNaN(deal_price)) {
                document.getElementById("discount_rate_" + i.toString()).value = Math.round(100 * deal_price / sale_price) / 10;
            }
            return json;
        }

        function set_product_line_display_status(i, display_status) {
            var tr_obj_arr = document.getElementsByName("product_tr_" + i.toString());
            for (var i = 0; i < tr_obj_arr.length; i++) {
                tr_obj_arr[i].style.display = display_status ? "" : "none";
            }
        }

        function get_product_line_display_status(i) {
            var status = "unknown";
            var tr_obj_arr = document.getElementsByName("product_tr_" + i.toString());
            if (tr_obj_arr.length > 0) {
                status = tr_obj_arr[0].style.display;
            }
            return status;
        }

        function refresh_order_state() {
            var ajax_url = "";
            if (order_id != undefined) {
                ajax_url = "../../../api/get_online_order_info.aspx?orderid=" + order_id.toString();
            }
            else {
                ajax_url = "../../../api/get_online_order_info.aspx?temporderid=" + temp_order_id.toString();
            }
            $.ajax({
                url: ajax_url,
                type: "GET",
                success: function (msg, statue) {
                    var msg_object = eval("(" + msg + ")");
                    order_id = msg_object.id;
                    if (msg_object.pay_state == 1) {
                        launch_pay_success_info();
                    }
                    
                    if (msg_object.pay_method == "支付宝" && msg_object.pay_state == 0) {
                        launch_alipay_qrcode(msg_object.id.toString());
                    }
                    

                }
            });
        }



        function launch_alipay_qrcode(order_id) {
            if (alipay_qrcode_launched)
                return;
            var td_cell = document.getElementById("qrcode_td");
            td_cell.innerHTML = "<img style='width:200px' src='../../../payment/payment_ali.aspx?orderid=" + order_id + "' />";
            alert("已更新为支付宝二维码，请顾客扫描。");
            alipay_qrcode_launched = true;
        }

        //付款成功
        function launch_pay_success_info() {
            if (launch_successed_info)
                return;
            clearInterval(intervalId);
            launch_successed_info = true;
            if (dialog) {
                dialog.show();
            } else {
                dialog = jqueryAlert({
                    'style': 'wap',
                    'content': '支付成功,自动跳转',
                    'closeTime': 2000,
                    'closeFunction': function () {
                        window.location = "admin_charge_shop_sale_finish.aspx?orderid=" + order_id.toString().trim();
                    },
                })
            }
        }
        /*
        $(function () {
            $("#qrcodeBtn").bind("click", function () {
                alert("请等待生成支付二维码。");
                get_qrcode();
                
            });
        });
        */
    </script>
</body>
</html>
<script type="text/javascript" >
    //alert(get_product_line_display_status(0));
</script>