<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {

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
    <!-- jQuery文件。务必在bootstrap.min.js 之前引入 -->
    <script src="../../js/jquery.min.js"></script>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="../../js/bootstrap.min.js"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <style>
        table {
            border: 0px solid red;
            border-collapse: collapse;
         }
         td {
            border: 0px solid red;
         }
       
    </style>
</head>
<body>
    <div>
        <table class="table">
            <tr >
                <td style="align-items :center; vertical-align:middle;">
                    <img id="head_image" style="width:100px;height:100px; display:none" src="http://thirdwx.qlogo.cn/mmopen/qE9MKluetOmAdicYiaLTickd4PMHcyDxib5N36S1g8SAWoGZjvd8HSLRKcpibom0ZJzwDQt4ibuqFAhOnqicMW30FRPsWF6NCDsfpoB/132" />
                </td>
                <td>
                    <table class="table" >
                        <tr>
                            <td style="text-align:right">手机:</td>
                            <td><input type="tel" id="cell" value="13501177897" style="width:150px;height:30px"   oninput="check_cell_number()" /></td>
                        </tr>
                        <tr>
                            <td style="text-align:right">昵称:</td>
                            <td>
                                <input type="text" id="nick" style="width:100px;height:30px" /> 
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align:right">性别:</td>
                            <td>
                                &nbsp; &nbsp; 
                                <input type="radio" id="male" style="width:20px;height:20px" name="gender" />男  &nbsp; &nbsp;  
                                <input type="radio" id="female" style="width:20px;height:20px" name="gender" />女
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td style="text-align:right" >RFID:</td>
                <td><input type="text" id="rfid" style="width:200px;height:30px" /> <a href="#" onclick="generate_time_string()" >生成</a></td>
            </tr>
            <tr>
                <td style="text-align:right" >品牌:</td>
                <td>
                    <input type="text" id="brand" style="width:100px;height:30px" />&nbsp; &nbsp; 
                    <input type="radio" id="ski" style="width:20px;height:20px" name="ski_type" />双板  &nbsp; &nbsp;  
                    <input type="radio" id="board" style="width:20px;height:20px" name="ski_type" />单板
                </td>
            </tr>
            <tr>
                <td style="text-align:right" >系列:</td>
                <td><input type="text" id="serial" style="width:200px;height:30px" /></td>
            </tr>
            <tr>
                <td style="text-align:right" >年款:</td>
                <td><input type="text" id="year_of_made" style="width:200px;height:30px" /></td>
            </tr>
            <tr>
                <td style="text-align:right" >长度:</td>
                <td><input type="text" id="length" style="width:200px;height:30px" /></td>
            </tr>
            <tr>
                <td colspan="2" class="text-center">
                    <input type="checkbox" id="need_edge" style="width:20px;height:20px" onchange="service_select()" />修刃<input id="degree" style="width:60px;height:30px" type="text" value="89" onchange="degree_change()" />度&nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="checkbox" id="need_candle" style="width:20px;height:20px" onchange="service_select()" />打蜡&nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="checkbox" id="need_fix" style="width:20px;height:20px" onchange="need_fix_change()" />补板底
                </td>
            </tr>
            <tr>
                <td style="text-align:right" >取板时间:</td>
                <td>
                    <input type="text" id="finish_date" style="width:130px;height:30px" />&nbsp;&nbsp;&nbsp;&nbsp; 
                    <input type="radio" id="finish_today" style="width:20px;height:20px" name="finish_radio" onclick="set_finish_date()" />立等&nbsp; 
                    <input type="radio" id="finish_tomorrow" style="width:20px;height:20px" checked name="finish_radio" onclick="set_finish_date()"  />次日
                </td>
            </tr>
            <tr>
                <td style="text-align:right"  >备注:</td>
                <td>
                    <textarea style="width:250px;height:155px" ></textarea>
                </td>
            </tr>
            <tr>
                <td style="text-align:right"  >卡券:</td>
                <td>
                    <input type="radio" onchange="select_card(0)"  style="width:20px;height:20px" name="card" disabled />保养寄存次卡 <span id="times" ></span><br />
                    <input type="radio" onchange="select_card(1)"  style="width:20px;height:20px" name="card" disabled />修刃卡&nbsp;&nbsp;
                    <input type="radio" onchange="select_card(2)"  style="width:20px;height:20px" name="card" disabled />修刃打蜡卡<br />
                    <input type="checkbox" onchange="pay_cash()"  style="width:20px;height:20px"  id="pay_cash_box" checked  />支付现金&nbsp;&nbsp;
                </td>
            </tr>
            <tr>
                <td style="text-align:right" >金额:</td>
                <td><input type="text" id="amount" style="width:130px;height:30px" /></td>
            </tr>
            <tr>
                <td style="text-align:right" >支付方式：</td>
                <td>
                    <select id="pay_method" >
                        <option>微信</option>
                        <option>支付宝</option>
                        <option>现金</option>
                    </select>
                </td>
            </tr>
        </table>
    </div>
    <script type="text/javascript" >
        var customer_open_id = '';
        set_finish_date();
        check_cell_number();
        var product_id = 0;
        var card_no = '';


        function get_user_open_id() {
            $.ajax({
                url: '/api/user_info_get_by_cell_number.aspx',
                type: "get",
                data: 'cell=' + document.getElementById('cell').value.trim(),
                success: function (msg, status) {
                    var msg_obj = eval('(' + msg + ')');
                    if (msg_obj.status == 0) {
                        var head_image = document.getElementById("head_image");
                        head_image.style.display = 'block';
                        head_image.src = msg_obj.user_info.head_image;
                        document.getElementById('nick').value = msg_obj.user_info.nick.trim();
                        switch (msg_obj.user_info.gender) {
                            case '男':
                                document.getElementById('male').checked = true;
                                document.getElementById('female').checked = false;
                                break;
                            case '女':
                                document.getElementById('male').checked = false;
                                document.getElementById('female').checked = true;
                                break;
                            default:
                                document.getElementById('male').checked = false;
                                document.getElementById('female').checked = false;
                                break;
                        }
                        customer_open_id = msg_obj.user_info.open_id.trim();
                        set_user_card();
                    }
                    else {
                        reset_user_info();
                    }
                },
                error: function () {
                    reset_user_info();
                }
            });
        }
        function check_cell_number() {
            var cell = document.getElementById('cell').value.trim();
            if (cell.length == 11) {
                get_user_open_id();
            }
            else {
                reset_user_info();
            }
        }
        function reset_user_info() {
            customer_open_id = '';
            document.getElementById('male').checked = false;
            document.getElementById('female').checked = false;
            document.getElementById("head_image").style.display = 'none';
            document.getElementById('nick').value = '';
            var card_radio_arr = document.getElementsByName('card');
            for (var i = 0; i < card_radio_arr.length; i++) {
                var card_radio = card_radio_arr[i];
                card_radio.disabled = true;
            }
        }
        function generate_time_string() {
            var nowDate = new Date();
            document.getElementById('rfid').value = nowDate.valueOf();
        }
        function set_user_card() {
            disable_cards();
            if (customer_open_id.trim() != '') {
                $.ajax({
                    url: '/api/skis/ski_maintain_card_ticket_get_by_open_id.aspx',
                    type: 'get',
                    data: 'openid=' + customer_open_id.trim(),
                    success: function (msg, status) {
                        var msg_obj = eval('(' + msg + ')');
                        if (msg_obj.status == 0) {
                            var card_radio_arr = document.getElementsByName('card');
                            for (var i = 0; i < msg_obj.cards.length; i++) {
                                var card = msg_obj.cards[i];
                                if (card.card_no.length == 12 && card.memo.trim() != '') {
                                    card_radio_arr[0].disabled = false;
                                    card_radio_arr[0].id = card.card_no.trim();
                                    document.getElementById('times').innerText = card.memo.trim();
                                }
                                if (card.name == '万龙店修板打蜡券') {
                                    card_radio_arr[2].disabled = false;
                                    card_radio_arr[2].id = card.card_no.trim();
                                }
                                if (card.name == '万龙店修板券') {
                                    card_radio_arr[1].disabled = false;
                                    card_radio_arr[1].id = card.card_no.trim();
                                }
                            }
                        } 
                        
                        
                    }
                });
            }
        }

        function set_finish_date() {
            var now_date = new Date();
            var finish_date = document.getElementById('finish_date');
            if (document.getElementById('finish_today').checked) {
                finish_date.value = now_date.getFullYear().toString() + '-' + (now_date.getMonth() + 1).toString()
                    + '-' + now_date.getDate().toString() + ' 17:00';
            }
            else if (document.getElementById('finish_tomorrow').checked) {
                now_date.setDate(now_date.getDate() + 1);
                finish_date.value = now_date.getFullYear().toString() + '-' + (now_date.getMonth() + 1).toString()
                    + '-' + now_date.getDate().toString() + ' ' + now_date.getHours().toString()+':00';
            }
            service_select();
        }

        function service_select() {
            var need_edge = document.getElementById('need_edge').checked ? true : false;
            var need_candle = document.getElementById('need_candle').checked ? true : false;
            var need_fix = document.getElementById('need_fix').checked ? true : false;
            var degree = parseInt(document.getElementById('degree').value);
            var finish_tomorrow = document.getElementById('finish_tomorrow').checked ? true : false;
            var card_arr = document.getElementsByName('card');
            if (degree <= 87) {
                disable_cards();
            }
            if (need_candle) {
                card_arr[1].checked = false;
                card_arr[1].disabled = true;
            }
            if (!finish_tomorrow) {
                disable_cards();
            }
            var use_card = false;
            for (var i = 0; i < card_arr.length; i++) {
                if (!card_arr[i].disabled) {
                    if (card_arr[i].cheched) {
                        use_card = true;
                        break;
                    }
                }
            }
            
            
            var amount = document.getElementById('amount');
            if (use_card) {
                
                amount.value = 0;
                amount.disabled = true;
                document.getElementById('pay_method').selectedIndex = 0;
                document.getElementById('pay_method').disabled = true;
            }
            else {
                if (finish_tomorrow) {
                    if (need_edge && need_candle && degree > 87)
                    {
                        product_id = 139;
                    }
                    else if (need_edge && degree > 87) {
                        product_id = 140;
                    }
                    else if (need_candle) {
                        product_id = 143;
                    }
                    else {
                        product_id = 0;
                    }
                }
                else {
                    if (need_edge && need_candle && degree > 87) {
                        product_id = 137;
                    }
                    else if (need_edge && degree > 87) {
                        product_id = 138;
                    }
                    else if (need_candle) {
                        product_id = 142;
                    }
                    else {
                        product_id = 0;
                    }

                }
            }
            if (product_id != 0) {
                $.ajax({
                    url: '/api/get_product_info.aspx',
                    type: "get",
                    data: 'type=&id=' + product_id.toString(),
                    success: function (msg, status) {
                        var msg_obj = eval('(' + msg + ')');
                        if (msg_obj.status == 0) {
                            amount.value = msg_obj.product.sale_price.toString();
                            amount.readOnly = true;
                        }
                    }
                });
            }
            else {
                amount.readOnly = false;
            }
            if (need_fix) {
                amount.readOnly = false;
            }



        }
        function disable_cards() {
            var card_arr = document.getElementsByName("card");
            for (var i = 0; i < card_arr.length ; i++) {
                card_arr[i].checked = false;
                card_arr[i].disabled = true;
            }
            document.getElementById('times').innerText = '';
        }
        function select_card(i) {
            document.getElementById('pay_cash_box').checked = false;
            var card_arr = document.getElementsByName("card");
            if (!card_arr[i].disabled && card_arr[i].checked) {
                card_no = card_arr[i].id;
            }
            service_select();
        }
        function pay_cash() {
            var amount_box = document.getElementById('amount');
            var card_arr = document.getElementsByName("card");
            if (document.getElementById('pay_cash_box').checked) {
                amount_box.readOnly = false;
                for (var i = 0; i < card_arr.length ; i++) {
                    card_arr[i].checked = false;
                }
            }
            else {
                
                amount_box.value = 0;
                amount_box.readOnly = true;
            }
            service_select();
        }
        function need_fix_change() {
            var need_edge_box = document.getElementById('need_edge');
            var degree_box = document.getElementById('degree');
            
            if (document.getElementById('need_fix').checked) {
                var special_edge = false;
                try {
                    var degree = parseInt(document.getElementById('degree').value);
                    if (degree <= 87 && document.getElementById('need_edge').checked) {
                        special_edge = true;
                    }
                }
                catch (msg) {

                }
                need_edge_box.checked = false;
                need_edge_box.disabled = true;
                degree_box.disabled = true;
                set_service_only_pay_cash();
                if (special_edge) {
                    document.getElementById('need_edge').disabled = false;
                    document.getElementById('degree').disabled = false;
                    document.getElementById('need_edge').checked = true;
                }
            }
            else {
                unset_service_only_pay_cash();
                need_edge_box.disabled = false;
                degree_box.disabled = false;
            }
            service_select();
            document.getElementById('amount').focus();
        }
        function set_service_only_pay_cash() {
            var need_candle_box = document.getElementById('need_candle');
            var pay_cash_box = document.getElementById('pay_cash_box');
            need_candle_box.checked = false;
            need_candle_box.disabled = true;
            disable_cards();
            pay_cash_box.checked = true;
            pay_cash_box.readOnly = true;
            pay_cash_box.disabled = true;
        }
        function unset_service_only_pay_cash() {
            var need_candle_box = document.getElementById('need_candle');
            var pay_cash_box = document.getElementById('pay_cash_box');
            need_candle_box.disabled = false;
            pay_cash_box.readOnly = false;
            pay_cash_box.disabled = false;
            set_user_card();
        }
        function degree_change() {
            var degree = 89;
            var valid_degree = false;
            try{
                degree = parseInt(document.getElementById('degree').value);
                valid_degree = true;
            }
            catch (msg) {

            }
            if (valid_degree && degree <= 87 && document.getElementById('need_edge').checked) {
                set_service_only_pay_cash();
            }
            else {
                unset_service_only_pay_cash();
                var need_fix_box = document.getElementById('need_fix');
                need_fix_box.checked = false;
                need_fix_box.disabled = false;
                
            }
            service_select();
            document.getElementById('amount').focus();
        }
    </script>
</body>
</html>
