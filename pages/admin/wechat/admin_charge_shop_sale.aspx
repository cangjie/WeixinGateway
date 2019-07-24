﻿<%@ Page Language="C#" %>

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


    protected void Page_Load(object sender, EventArgs e)
    {
        
        string currentPageUrl = Server.UrlEncode("/pages/admin/wechat/admin_charge_shop_sale.aspx");
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
</head>
<body>
    <table class="table table-striped">
        <tr>
            <td colspan="2" >&nbsp;</td>
        </tr>
        <tr name="product_tr_0" >
            <td colspan="2" >商品1：<input type="text" id="product_name_0" onchange="get_product_list_json()" /> 数量：<input type="text" id="product_num_0" style="width:50px" value="1" onchange="get_product_list_json()"   /></td>
        </tr>
        <tr name="product_tr_0" >
            <td colspan="2" >零售价：<input type="text" id="market_price_0" style="width:75px" onchange="get_product_list_json()"  /> 成交价：<input type="text" id="sale_price_0" style="width:75px" onchange="get_product_list_json()"   /></td>
        </tr>
        <tr name="product_tr_0" >
            <td colspan="2" id="product_info_0" >&nbsp;</td>
        </tr>

        <tr style="display:none" name="product_tr_1" >
            <td colspan="2" >商品2：<input type="text" id="product_name_1" onchange="get_product_list_json()"  /> 数量：<input type="text" id="product_num_1" style="width:50px" value="1" onchange="get_product_list_json()"  /></td>
        </tr>
        <tr style="display:none" name="product_tr_1" >
            <td colspan="2" >零售价：<input type="text" id="market_price_1" style="width:75px" onchange="get_product_list_json()"  /> 成交价：<input type="text" id="sale_price_1" style="width:75px" onchange="get_product_list_json()"  /></td>
        </tr>
        <tr style="display:none" name="product_tr_1" >
            <td colspan="2"  id="product_info_1" >&nbsp;</td>
        </tr>

        <tr style="display:none" name="product_tr_2" >
            <td colspan="2" >商品3：<input type="text" id="product_name_2" onchange="get_product_list_json()"   /> 数量：<input type="text" id="product_num_2" style="width:50px" value="1" onchange="get_product_list_json()"   /></td>
        </tr>
        <tr style="display:none" name="product_tr_2" >
            <td colspan="2" >零售价：<input type="text" id="market_price_2" style="width:75px" onchange="get_product_list_json()"   /> 成交价：<input type="text" id="sale_price_2" style="width:75px" onchange="get_product_list_json()"  /></td>
        </tr>
        <tr style="display:none" name="product_tr_2" >
            <td colspan="2" id="product_info_2"  >&nbsp;</td>
        </tr>

        <tr style="display:none" name="product_tr_3" >
            <td colspan="2" >商品4：<input type="text" id="product_name_3" onchange="get_product_list_json()"   /> 数量：<input type="text" id="product_num_3" style="width:50px" value="1" onchange="get_product_list_json()"   /></td>
        </tr>
        <tr style="display:none" name="product_tr_3" >
            <td colspan="2" >零售价：<input type="text" id="market_price_3" style="width:75px" onchange="get_product_list_json()"   /> 成交价：<input type="text" id="sale_price_3" style="width:75px" onchange="get_product_list_json()"  /></td>
        </tr>
        <tr style="display:none" name="product_tr_3" >
            <td colspan="2" id="product_info_3" >&nbsp;</td>
        </tr>
        <tr style="display:none" name="product_tr_4" >
            <td colspan="2" >商品5：<input type="text" id="product_name_4" onchange="get_product_list_json()"  /> 数量：<input type="text" id="product_num_4" style="width:50px" value="1" onchange="get_product_list_json()"   /></td>
        </tr>
        <tr style="display:none" name="product_tr_4" >
            <td colspan="2" >零售价：<input type="text" id="market_price_4" style="width:75px" onchange="get_product_list_json()"  /> 成交价：<input type="text" id="sale_price_4" style="width:75px" onchange="get_product_list_json()"  /></td>
        </tr>
        <tr style="display:none" name="product_tr_4" >
            <td colspan="2" id="product_info_4" >&nbsp;</td>
        </tr>
        
        <tr>
            <td style="width:140px">零售价(元)：</td>
            <td style="white-space:nowrap; overflow:hidden">
                <input type="text" id="txt_market_price" style="width:100px"  oninput="compute_score()" readonly="1" />
                <span style="color:red; width:10px; word-wrap:break-word" ></span>
            </td>
        </tr>
        <tr>
            <td>成交价(元)：</td>
            <td>
                <input type="text" id="txt_sale_price"  style="width:100px"  oninput="compute_score()" readonly="1" />
                <span style="color:red; width:10px; word-wrap:break-word" ></span>
            </td>
        </tr>
        <tr>
            <td>使用代金券(元)：</td>
            <td>
                <input type="text" id="txt_ticket_amout" style="width:100px" oninput="compute_score()" />
                <span style="color:red; width:10px; word-wrap:break-word" ></span>
            </td>
        </tr>
        <tr>
            <td>实际支付金额(元)：</td>
            <td>
                <span style="color:red; width:10px; word-wrap:break-word;font-size:large"  id="real_pay_price"></span>
            </td>
        </tr>
        <tr>
            <td>龙珠系数：</td>
            <td>
                <span style="color:red; width:10px; word-wrap:break-word; font-size:large" id="lbl_score_rate" ></span>
            </td>
        </tr>
        <tr>
            <td>生成龙珠：</td>
            <td>
                <span style="color:red; width:10px; word-wrap:break-word; font-size:large" id="lbl_score" ></span>
            </td>
        </tr>
        <tr>
            <td>支付方式：</td>
            <td>
                <select id="pay_method" >
                    <option>现金</option>
                    <option>刷卡</option>
                    <option>微信</option>
                    <option>支付宝</option>
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
            <td>备注：</td>
            <td><textarea cols="30" rows="3" id="txt_memo" ></textarea></td>
        </tr>
        <tr>
            <td colspan="2" style="text-align:center"><button type="button" id="qrcodeBtn" class="btn btn-default"  >获取支付二维码</button></td>
        </tr>
        <tr>
            <td colspan="2" id="qrcode_td" style="text-align:center"></td>
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

        function compute_score() {
            if (check_valid()) {
                real_pay_price = sale_price - ticket_amount;
                discount_rate = real_pay_price / market_price;
                if (discount_rate == 1)
                    score_rate = 1;
                else if (discount_rate >= 0.95)
                    score_rate = 0.925;
                else if (discount_rate >= 0.9)
                    score_rate = 0.85;
                else if (discount_rate >= 0.85)
                    score_rate = 0.775;
                else if (discount_rate >= 0.8)
                    score_rate = 0.7;
                else if (discount_rate >= 0.75)
                    score_rate = 0.625;
                else if (discount_rate >= 0.7)
                    score_rate = 0.55;
                else if (discount_rate >= 0.65)
                    score_rate = 0.475;
                else if (discount_rate >= 0.6)
                    score_rate = 0.4;
                else if (discount_rate >= 0.55)
                    score_rate = 0.325;
                else if (discount_rate >= 0.5)
                    score_rate = 0.25;
                else if (discount_rate >= 0.45)
                    score_rate = 0.175;
                else if (discount_rate >= 0.4)
                    score_rate = 0.1;
                else
                    score_rate = 0;
                score = parseInt(real_pay_price * score_rate);
                document.getElementById("lbl_score").innerText = score.toString();
                document.getElementById("real_pay_price").innerText = real_pay_price;
                document.getElementById("lbl_score_rate").innerText = score_rate;
            }
            else {
                //alert("aa");
            }
        }

        function check_valid() {
            var valid = true;
            market_price = parseFloat(document.getElementById("txt_market_price").value);
            if (isNaN(market_price))
                valid = false;
            sale_price = parseFloat(document.getElementById("txt_sale_price").value);
            if (isNaN(sale_price))
                valid = false;
            ticket_amount = parseFloat(document.getElementById("txt_ticket_amout").value);
            if (isNaN(ticket_amount))
                ticket_amount = 0;
            return valid;
        }

        var temp_order_id = 0;
        var intervalId = 0;
        //获取二维码
        function get_qrcode() {
            //alert(get_product_list_json());
            //return;
            try{
                parseFloat(document.getElementById("txt_ticket_amout").value);
            }
            catch (err) {
                document.getElementById("txt_ticket_amout").value = "0";
            }
            compute_score();
            var ajax_url = "../../../api/create_shop_sale_charge_qrcode.aspx?token=<%=userToken%>&marketprice="
                + market_price.toString() + "&saleprice=" + sale_price.toString() + "&ticketamount=" + ticket_amount.toString()
                + "&memo=" + document.getElementById("txt_memo").value.trim() + "&paymethod=" + document.getElementById("pay_method").value.trim()
                + "&shop=" + document.getElementById("shop").value.trim() + "&reforderdetail=" + get_product_list_json();
            $.ajax({
                url: ajax_url,
                type: "GET",
                success: function (msg, status) {
                    var msg_object = eval("(" + msg + ")");
                    var qrcode_id = msg_object.charge_id;
                    var qr_code_url = "";
                    //if (qrcode_id != null) {
                    qr_code_url = "http://weixin.snowmeet.com/show_qrcode.aspx?sceneid=" + qrcode_id.trim();
                    //}
                    //else {
                    //    qr_code_url = "http://weixin.snowmeet.com/show_qrcode.aspx?qrcodetext=" + msg_object.qr_code_url.trim();
                    //}
                    var td_cell = document.getElementById("qrcode_td");
                    td_cell.innerHTML = "<img style='width:200px' src='" + qr_code_url + "' />";
                    temp_order_id = msg_object.temp_order_id;
                    if (temp_order_id > 0)
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
            $.ajax({
                url: "../../../api/get_order_temp_info.aspx?temporderid=" + temp_order_id,
                type: "GET",
                success: function (msg, status) {
                    var msg_object = eval("(" + msg + ")");
                    var order_id = 0;
                    try {
                        order_id = parseInt(msg_object.online_order_id);
                    }
                    catch (ex) {

                    }
                    if (order_id > 0) {
                        $.ajax({
                            url: "../../../api/get_online_order_info.aspx?orderid=" + order_id.toString(),
                            type: "GET",
                            success: function (msg, statue) {
                                var msg_object = eval("(" + msg + ")");
                                if (msg_object.pay_state == 1) {
                                    launch_pay_success_info();
                                }
                                if (msg_object.pay_method == "支付宝" && msg_object.pay_state == 0) {
                                    launch_alipay_qrcode(msg_object.id.toString());
                                }


                            }
                        });
                    }
                }
            });
        }



        function launch_alipay_qrcode(order_id) {
            if (alipay_qrcode_launched)
                return;
            var td_cell = document.getElementById("qrcode_td");
            td_cell.innerHTML = "<img style='width:200px' src='../../../payment/haojin_qrcode_pay_ali.aspx?orderid=" + order_id + "' />";
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
                        window.location = "admin_charge_shop_sale_finish.aspx";
                    },
                })
            }
        }

        $(function () {
            $("#qrcodeBtn").bind("click", function () {
                get_qrcode();
                
            });
        });
    </script>
</body>
</html>
<script type="text/javascript" >
    //alert(get_product_line_display_status(0));
</script>