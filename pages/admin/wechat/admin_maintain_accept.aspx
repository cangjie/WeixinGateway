<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    string token = "1645531824d36c565bb3cbed6d7e87b6e2c963b86fabd623b7dd850c7536b8238e1a51c6";

    public WeixinUser currentUser;
    public string openId = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        /*
        string currentPageUrl = Request.Url.ToString();
        if (!Util.GetSafeRequestValue(Request, "cell", "").Trim().Equals("") && currentPageUrl.IndexOf("?cell") < 0 )
        {
            currentPageUrl = currentPageUrl + "?cell=" + Util.GetSafeRequestValue(Request, "cell", "").Trim();
        }


        if (Session["user_token"] == null || Session["user_token"].ToString().Trim().Equals(""))
        {
            Response.Redirect("../../../authorize.aspx?callback=" + currentPageUrl, true);
        }
        token = Session["user_token"].ToString();
        openId = WeixinUser.CheckToken(token);
        if (openId.Trim().Equals(""))
        {
            Response.Redirect("../../../authorize.aspx?callback=" + currentPageUrl, true);
        }
        currentUser = new WeixinUser(WeixinUser.CheckToken(token));

        if (!currentUser.IsAdmin)
            Response.End();
        */
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
            <tr><td colspan="2" ><font color="red" id="msg_1" >&nbsp;</font></td></tr>
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
                    <select id="drp_brand" onchange="fill_in_brand()" >
                        <option value="" >请选择……</option>
                        <option value="APO" >APO</option>
                        <option value="Armada" >Armada</option>
                        <option value="Atomic" >Atomic</option>
                        <option value="Burton" >Burton</option>
                        <option value="Capita" >Capita</option>
                        <option value="Fischer" >Fischer</option>
                        <option value="Head" >Head</option>
                        <option value="Nitro" >Nitro</option>
                        <option value="Nordica" >Nordica</option>
                        <option value="Rossignol" >Rossignol</option>
                        <option value="StockLi" >StockLi</option>
                        <option value="Volki" >Volki</option>
                        <option value="其它" >其它</option>   
                    </select>
                    <input type="text" id="brand" style="width:100px;height:30px; display:none"  />&nbsp; &nbsp; 
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
                    <input type="checkbox" id="need_edge" style="width:20px;height:20px" onchange="service_changed()" />修刃<input id="degree" style="width:60px;height:30px" type="text" value="89" onchange="service_changed()" />度&nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="checkbox" id="need_candle" style="width:20px;height:20px" onchange="service_changed()" />打蜡&nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="checkbox" id="need_more" style="width:20px;height:20px" onchange="service_changed()" />更多
                </td>
            </tr>
            <tr id="tr_more" style="display:none">
                
                <td colspan="2">
                    <table id="table_more">
                        <tr>
                            <td>项目</td>
                            <td>金额</td>
                            <td>说明</td>
                        </tr>
                        <tr id="table_line_template">
                            <td>
                                <select name="service_item_name"  id="service_item_name_0" onchange="table_drp_changed()" >
                                    <option value="" >请选择...</option>
                                    <option value="87度以下" >87度以下</option>
                                    <option value="补板底" >补板底</option>
                                    <option value="改刃" >改刃</option>
                                    <option value="开蜡" >开蜡</option>
                                    <option value="粘合" >粘合</option>
                                    <option value="快速生涂" >快速生涂</option>
                                    <option value="其它" >其它</option>
                                </select>
                                <input type="text" name="service_item_name_input" id="service_item_name_input_0" onchange="service_changed()" style="width:80px;display:none" />
                            </td>
                            <td><input type="text" name="service_item_amount" id="service_item_amount_0" style="width:40px" onchange="service_changed()" /></td>
                            <td><input type="text" name="service_item_memo" id="service_item_memo_0" style="width:175px" onchange="service_changed()" /></td>
                        </tr>
                    </table>
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
                    <textarea style="width:250px;height:155px" id="memo" ></textarea>
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
                <td><input type="text" id="amount" style="width:130px;height:30px" readonly disabled /></td>
            </tr>
            <tr>
                <td style="text-align:right" >特殊调整:</td>
                <td><input type="text" id="delta_amount" style="width:130px;height:30px" value="0" onchange="delta_amount_changed()" /></td>
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
            <tr>
                <td style="text-align:right" >实际支付:</td>
                <td><input type="text" id="real_pay" style="width:130px;height:30px" readonly disabled /></td>
            </tr>
            <tr><td colspan="2" ><font color="red" id="msg_2" >&nbsp;</font></td></tr>
            <tr>
                <td colspan="2" style="text-align: center;" ><button id="submit_button" class="btn btn-default" onclick="submit()" > 生 成 二 维 码 </button></td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: center;" ><img id="qrcode" style="display:none;width:200px" /></td>
            </tr>
        </table>
    </div>
    <script type="text/javascript" >
        var customer_open_id = '';
        
        check_cell_number();
        var product_id = 0;
        var card_no = '';
        var ski_id = 0;
        var task_id = 0;

        var table_drp_service_item_name_arr = document.getElementsByName('service_item_name');
        var table_txt_service_item_name_arr = document.getElementsByName('service_item_name_input');
        var table_more = document.getElementById('table_more');
        var table_line_template = document.getElementById('table_line_template');
        var chk_need_edge = document.getElementById('need_edge');
        var chk_need_candle = document.getElementById('need_candle');
        var chk_need_more = document.getElementById('need_more');
        var txt_degree = document.getElementById('degree');
        var tr_more = document.getElementById('tr_more');
        var more_service_item_json_obj = [];
        var more_service_item_name_arr = table_more.getElementsByTagName('select');
        var txt_amount = document.getElementById('amount');
        var rdo_finish_today = document.getElementById('finish_today');
        var rdo_finish_tomorrow = document.getElementById('finish_tomorrow');
        var txt_delta_amount = document.getElementById('delta_amount');
        var txt_real_pay = document.getElementById('real_pay');
        var drp_brand = document.getElementById('drp_brand');
        var txt_brand = document.getElementById('brand');
        //var extend_service_json_str = '{"extend_service":[]}';
        var extend_serivice_json_str = '';
        set_finish_date();

        function fill_in_brand() {
            if (drp_brand.options[drp_brand.selectedIndex].value == '其它') {
                txt_brand.style.display = '';
            }
            else {
                txt_brand.style.display = 'none';
            }
        }

        function get_brand() {

            if (drp_brand.options[drp_brand.selectedIndex].value == '其它') {
                return txt_brand.value.trim();
            }
            else if (drp_brand.options[drp_brand.selectedIndex].value == '') {
                return '';
            }
            else {
                return drp_brand.options[drp_brand.selectedIndex].value.trim();
            }
        }

        function delta_amount_changed() {
            var delta_amount = 0;
            try{
                delta_amount = parseInt(txt_delta_amount.value.trim());
            }
            catch (msg) {

            }
            if (delta_amount != 0) {
                document.getElementById('memo').focus();
                service_changed();
                var amount = 0;
                try {
                    amount = parseInt(txt_amount.value.trim());
                }
                catch (msg) {
                    
                }
                txt_real_pay.value = amount + delta_amount;
            }
        }

        function get_more_service_item_json_obj() {
            more_service_item_json_obj = [];
            for (var i = 0; i < more_service_item_name_arr.length; i++) {
                var drp = more_service_item_name_arr[i];
                if (drp.selectedIndex > 0) {
                    var service_name = drp.options[drp.selectedIndex].value.toString();
                    var amount = 0;
                    try{
                        amount = parseInt(document.getElementById('service_item_amount_' + i.toString()).value);
                    }
                    catch (msg) {

                    }
                    if (service_name.trim() == '其它') {
                        service_name = document.getElementById('service_item_name_input_' + i.toString()).value;
                    }
                    var memo = document.getElementById('service_item_memo_' + i.toString()).value;
                    if (service_name.trim() != '') {
                        more_service_item_json_obj.push({ "service_name": service_name.trim(), "amount": amount.toString(), "memo": memo.trim() });
                    }
                }
            }
        }

        function delete_more_service_item(service_name) {
            for (var i = 0; i < more_service_item_json_obj.length; i++) {
                if (more_service_item_json_obj[i].service_name.trim() == service_name.trim()) {
                    more_service_item_json_obj.splice(i, 1);
                    break;
                }
            }
        }

        function add_more_service_item(service_name, amount, memo) {
            var found = false;
            for (var i = 0; i < more_service_item_json_obj.length; i++) {
                if (more_service_item_json_obj[i].service_name.trim() == service_name.trim()) {
                    more_service_item_json_obj[i].amount = amount;
                    more_service_item_json_obj[i].memo = memo;
                    found = true;
                    break;
                }
            }
            if (!found) {
                more_service_item_json_obj.push({ "service_name": service_name.trim(), "amount": amount, "memo":memo.trim() });
            }
        }

        function render_more_service_item() {
            //table_more = document.getElementById('table_more');
            var tr_arr = table_more.getElementsByTagName('tr');
            var max_index = tr_arr.length - 2;
            var html_template = tr_arr[tr_arr.length - 1].innerHTML.trim();
            var html_header = tr_arr[0].innerHTML.trim();
            table_more.innerHTML = '<tr>' + html_header + '</tr>';
            for (var i = 0; i <= more_service_item_json_obj.length; i++) {
                
                var drp = document.createElement('select');
                drp.setAttribute('name', 'service_item_name');
                drp.setAttribute('id', 'service_item_name_' + i.toString());
                drp.setAttribute('onchange', 'table_drp_changed()');

                var option = document.createElement('option');
                option.setAttribute('value', '');
                option.innerText = '请选择...';
                drp.appendChild(option);

                option = document.createElement('option');
                option.setAttribute('value', '87度以下');
                option.innerText = '87度以下';
                drp.appendChild(option);

                option = document.createElement('option');
                option.setAttribute('value', '补板底');
                option.innerText = '补板底';
                drp.appendChild(option);

                option = document.createElement('option');
                option.setAttribute('value', '改刃');
                option.innerText = '改刃';
                drp.appendChild(option);

                option = document.createElement('option');
                option.setAttribute('value', '开蜡');
                option.innerText = '开蜡';
                drp.appendChild(option);

                option = document.createElement('option');
                option.setAttribute('value', '粘合');
                option.innerText = '粘合';
                drp.appendChild(option);

                option = document.createElement('option');
                option.setAttribute('value', '快速生涂');
                option.innerText = '快速生涂';
                drp.appendChild(option);

                option = document.createElement('option');
                option.setAttribute('value', '其它');
                option.innerText = '其它';
                drp.appendChild(option);

                var txt_etc = document.createElement('input');
                txt_etc.setAttribute('type', 'text');
                txt_etc.setAttribute('name', 'service_item_name_input');
                txt_etc.setAttribute('id', 'service_item_name_input_' + i.toString());
                txt_etc.setAttribute('style', 'width:80px;display:none');

                var txt_amount = document.createElement('input');
                txt_amount.setAttribute('type', 'text');
                txt_amount.setAttribute('name', 'service_item_amount');
                txt_amount.setAttribute('id', 'service_item_amount_' + i.toString());
                txt_amount.setAttribute('style', 'width:40px');
                txt_amount.setAttribute('onChange', 'service_changed()');

                var txt_memo = document.createElement('input');
                txt_memo.setAttribute('type', 'text');
                txt_memo.setAttribute('name', 'service_item_memo');
                txt_memo.setAttribute('id', 'service_item_memo_' + i.toString());
                txt_memo.setAttribute('style', 'width:175px');
                txt_memo.setAttribute('onChange', 'service_changed()');

                if (i < more_service_item_json_obj.length) {
                    var selected_index = 0;
                    for (var j = 1; j < drp.options.length; j++) {
                        if (drp.options[j].value == more_service_item_json_obj[i].service_name.trim()) {
                            selected_index = j;
                            break;
                        }
                    }
                    if (selected_index == 0 && more_service_item_json_obj[i].service_name.trim() != '') {
                        drp.selectedIndex = drp.options.length - 1;
                        selected_index = drp.options.length - 1;
                        txt_etc.style.display = '';
                        txt_etc.value = more_service_item_json_obj[i].service_name.trim();
                    }
                    drp.options[selected_index].setAttribute('selected', '1');
                    if (drp.options[selected_index].value.trim() == '其它') {
                        txt_etc.style.display = '';
                        txt_etc.setAttribute('value', more_service_item_json_obj[i].service_name.trim());
                    }
                    txt_amount.setAttribute('value', more_service_item_json_obj[i].amount.toString());
                    txt_memo.setAttribute('value', more_service_item_json_obj[i].memo.trim());
                }
                table_more.innerHTML = table_more.innerHTML + '<tr><td>' + drp.outerHTML.trim() + txt_etc.outerHTML.trim() + '</td><td>' + txt_amount.outerHTML 
                    + '</td><td>' + txt_memo.outerHTML + '</td></tr>';
            }
        }

        function service_changed() {
            get_more_service_item_json_obj();
            var degree = 89;
            var product_id = 0;
            try{
                degree = parseInt(txt_degree.value);
            }
            catch (msg) {

            }
            if (chk_need_edge.checked) {
                if (degree <= 87) {
                    add_more_service_item('87度以下', 50, '');
                    need_more.checked = true;
                    need_more.disabled = true;
                    tr_more.style.display = '';
                }
                else {
                    delete_more_service_item('87度以下');
                    need_more.disabled = false;
                }
            }
            else {
                delete_more_service_item('87度以下');
                need_more.disabled = false;
            }
            if (chk_need_more.checked) {
                tr_more.style.display = '';
                set_service_only_pay_cash();
            }
            else {
                tr_more.style.display = 'none';
                unset_service_only_pay_cash();
            }
            render_more_service_item();
            if (chk_need_edge.checked) {
                if (chk_need_candle.checked) {
                    if (rdo_finish_today.checked) {
                        //修板打蜡立等
                        product_id = 137;
                    }
                    else {
                        //修板打蜡隔日
                        product_id = 139;
                    }
                }
                else {
                    if (rdo_finish_today.checked) {
                        //修板立等
                        product_id = 138;
                    }
                    else {
                        //修板隔日
                        product_id = 140;
                    }
                }
            }
            else if (chk_need_candle.checked) {
                if (rdo_finish_today.checked) {
                    //打蜡立等
                    product_id = 142;
                }
                else {
                    //打蜡隔日
                    product_id = 143;
                }
            }

            var total_amount = parseInt(get_product_price(product_id));
            for (var i = 0; i < more_service_item_json_obj.length; i++) {
                total_amount = parseInt(total_amount) + parseInt(more_service_item_json_obj[i].amount);
            }
            
            txt_amount.value = total_amount.toString();

            try {
                txt_real_pay.value = parseFloat(txt_amount.value) + parseFloat(delta_amount.value);
            }
            catch (err_msg) {

            }
        }

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
            document.getElementById('rfid').value = '';
            document.getElementById('brand').value = '';
            document.getElementById('ski').checked = false;
            document.getElementById('board').checked = false;
            document.getElementById('serial').value = '';
            document.getElementById('year_of_made').value = '';
            document.getElementById('length').value = '';
            ski_id = 0;
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
                    + '-' + now_date.getDate().toString() + ' ' + (now_date.getHours() + 2).toString() + ':00';
            }
            else if (document.getElementById('finish_tomorrow').checked) {
                now_date.setDate(now_date.getDate() + 1);
                finish_date.value = now_date.getFullYear().toString() + '-' + (now_date.getMonth() + 1).toString()
                    + '-' + now_date.getDate().toString() + ' 8:00';
            }
            service_changed();
        }

        function service_select() {
            var need_edge = document.getElementById('need_edge').checked ? true : false;
            var need_candle = document.getElementById('need_candle').checked ? true : false;
            var need_more = document.getElementById('need_more').checked ? true : false;
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
                    if (card_arr[i].checked) {
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
            if (need_more) {
                amount.readOnly = false;
            }



        }

        function get_product_price(product_id) {
            var product_price = 0;
            if (product_id != 0) {
                $.ajax({
                    url: '/api/get_product_info.aspx',
                    type: "get",
                    data: 'type=&id=' + product_id.toString(),
                    async:false,
                    success: function (msg, status) {
                        var msg_obj = eval('(' + msg + ')');
                        if (msg_obj.status == 0) {
                            product_price = msg_obj.product.sale_price
                        }
                    }
                });
            }
            return product_price;
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
        function need_more_change() {
            var need_edge_box = document.getElementById('need_edge');
            var degree_box = document.getElementById('degree');
            
            if (document.getElementById('need_more').checked) {
                document.getElementById('tr_more').style.display = '';
                var special_edge = false;
                try {
                    var degree = parseInt(document.getElementById('degree').value);
                    if (degree <= 87 && document.getElementById('need_edge').checked) {
                        special_edge = true;
                    }
                }
                catch (msg) {

                }
                //need_edge_box.checked = false;
                //need_edge_box.disabled = true;
                //degree_box.disabled = true;
                set_service_only_pay_cash();
                if (special_edge) {
                    document.getElementById('need_edge').disabled = false;
                    document.getElementById('degree').disabled = false;
                    document.getElementById('need_edge').checked = true;
                }
            }
            else {
                document.getElementById('tr_more').style.display = 'none';
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
            //need_candle_box.checked = false;
            //need_candle_box.disabled = true;
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
                add_special_edge_item();
                document.getElementById('need_more').checked = true;
                document.getElementById('tr_more').style.display = '';
            }
            else {
                del_special_edge_item();
                unset_service_only_pay_cash();
                var need_more_box = document.getElementById('need_more');
                need_more_box.checked = false;
                need_more_box.disabled = false;
                
            }
            service_select();
            document.getElementById('amount').focus();
        }
        function check_valid() {
            var msg = '';
            var cell = document.getElementById('cell');
            var rfid = document.getElementById('rfid');
            var brand = document.getElementById('brand');
            var finish_date = document.getElementById('finish_date');
            var amount = document.getElementById('amount');
            
            if (customer_open_id == '' && cell.value.trim() == '') {
                msg = '请填写顾客手机号。';
                cell.focus();
            }
            else if (!document.getElementById('male').checked && !document.getElementById('female').checked) {
                msg = '请选择顾客性别。';
            }
            else if (rfid.value.trim() == '') {
                msg = '请生成RFID';
                rfid.focus();
            }
            else if (get_brand().trim() == '') {
                msg = '请填写品牌。';
                brand.focus();
            }
            else if (!document.getElementById('ski').checked && !document.getElementById('board').checked) {
                msg = '是单板还是双板？';
            }
            else if (!document.getElementById('need_edge').checked && !document.getElementById('need_candle').checked
                && !document.getElementById('need_more').checked) {
                msg = '请选择服务项目。';
            }
            else if (finish_date.value.trim() == '') {
                msg = '请填写取板时间。';
                finish_date.focus();
            }
            else if (document.getElementById('pay_cash_box').checked) {
                /*
                if (isNaN(parseFloat(amount.value.trim()))) {
                    msg = '请填写正确的金额';
                    amount.focus();
                }
                */
                if (isNaN(parseFloat(txt_delta_amount.value))) {
                    msg = '请填写正确的特殊调整金额。'
                }
                if (need_more.checked) {
                    var service_item_name_arr = document.getElementsByName('service_item_name');
                    var service_item_name_input_arr = document.getElementsByName('service_item_name_input');
                    var service_item_amount_arr = document.getElementsByName('service_item_amount');
                    var service_item_memo_arr = document.getElementsByName('service_item_memo');
                    for (var i = 0; i < service_item_name_arr.length; i++) {
                        var service_name = ((service_item_name_arr[i].options[service_item_name_arr[i].selectedIndex].value.trim() == '其它') ?
                            service_item_name_input_arr[i].value.trim() : service_item_name_arr[i].options[service_item_name_arr[i].selectedIndex].value.trim());
                        var item_amount = service_item_amount_arr[i].value.trim();
                        if (service_name.trim() != '' && isNaN(parseFloat(item_amount))) {
                            msg = '更多服务第' + (i + 1).toString() + '行，请填写正确的金额。';
                            //break;
                        }
                        if (service_name.trim() == '' && !isNaN(parseFloat(item_amount))) {
                            msg = '更多服务第' + (i + 1).toString() + '行，请填写选择服务项目。';
                            //break;
                        }
                        if (msg == '' && service_name.trim() != '' && item_amount.trim() != '' && item_amount.trim() != '0') {
                            var sub_extend_json_str = '{"service_name": "' + service_name.trim() + '", "amount" :' + item_amount.toString()
                                + ', "memo": "' + service_item_memo_arr[i].value.trim() + '"}';
                            extend_serivice_json_str = extend_serivice_json_str + ((extend_serivice_json_str.trim() == '') ? '' : ', ')
                                + sub_extend_json_str;
                                
                        }
                    }
                }
            }
            else {
                var have_select_card = false;
                var card_arr  =  document.getElementsByName('card');
                for (var i=0; i < card_arr.length; i++) {
                    if (card_arr[i].checked) {
                        have_select_card = true;
                        break;
                    }
                }
                if (!have_select_card) {
                    msg = '请选择核销的卡券。';
                }
            }
            return msg.trim();
        }
        function submit() {
            var btn = document.getElementById('submit_button');
            btn.disabled = true;
            var msg = check_valid();
            if (msg.trim() == '') {
                if (customer_open_id == '') {
                    create_customer_open_id();
                }
                if (customer_open_id != '') {
                    if (ski_id == 0) {
                        create_ski_id();
                    }
                    if (ski_id != 0) {
                        document.getElementById('msg_1').innerText = '';
                        document.getElementById('msg_2').innerText = '';
                        create_task();
                    }
                }
            }
            else {
                document.getElementById('msg_1').innerText = msg.trim();
                document.getElementById('msg_2').innerText = msg.trim();
                btn.disabled = false;
            }
        }
        
        function create_ski_id() {
            var rfid = document.getElementById('rfid').value.trim();
            var brand = document.getElementById('brand').value.trim();
            var ski_type = (document.getElementById('ski').checked ? '双板' : '');
            ski_type = ((ski_type == '' && document.getElementById('board').checked) ? '单板' : ski_type.trim());
            var serial = document.getElementById('serial').value.trim();
            var year_of_made = document.getElementById('year_of_made').value.trim();
            var length = document.getElementById('length').value.trim();
            $.ajax({
                url: '/api/skis/ski_create.aspx',
                type: 'get',
                data: 'token=<%=token%>&rfid=' + rfid + '&ski_type=' + ski_type + '&brand=' + brand + '&serial_name=' + serial
                    + '&year_of_made=' + year_of_made + '&length=' + length,
                async: false,
                success: function (msg, status) {
                    var msg_obj = eval('(' + msg + ')');
                    if (msg_obj.status == 0) {
                        ski_id = msg_obj.ski_id;
                    }
                }
            });

        }
        function create_customer_open_id() {
            var cell = document.getElementById('cell').value.trim();
            $.ajax({
                url: '/api/user_open_id_get_by_cell.aspx',
                type: 'get',
                data: 'token=<%=token.Trim()%>&cell=' + cell,
                async: false,
                success: function (msg, status) {
                    var msg_obj = eval('(' + msg + ')');
                    if (msg_obj.status == 0) {
                        if (msg_obj.open_id.trim() == '') {
                            customer_open_id = msg_obj.temp_open_id.trim();
                        }
                        else {
                            customer_open_id = msg_obj.open_id.trim();
                        }
                       
                    }
                }
            });
        }

        function create_task() {
            var edge = document.getElementById('need_edge').checked ? document.getElementById('degree').value : '0';
            var need_candle = document.getElementById('need_candle').checked ? '1' : '0';
            var need_more = document.getElementById('need_more').checked ? '1' : '0';
            var finish_date = document.getElementById('finish_date').value.trim();
            var memo = document.getElementById('memo').value.trim();
            var card_no = '';
            var pay_method = '';
            var amount = 0;
            if (document.getElementById('pay_cash_box').checked) {
                pay_method = document.getElementById('pay_method').value.trim();
                amount = parseInt(document.getElementById('amount').value);
            }
            else {
                var card_no_arr = document.getElementsByName('card');
                for (var i = 0; i < card_no_arr.length; i++) {
                    if (!card_no_arr[i].disabled && card_no_arr[i].checked) {
                        card_no = card_no_arr[i].id;
                        break;
                    }
                }
            }
            extend_serivice_json_str = '{"extend_service": [' + extend_serivice_json_str + ']}';
            $.ajax({
                url: '/api/skis/ski_maintain_task_create.aspx?' + 'token=<%=token%>&customer=' + customer_open_id + '&ski_id=' + ski_id.toString().trim() + '&edge=' + edge.toString().trim()
                    + '&candle=' + need_candle + '&fix=' + need_more + '&memo=' + memo + '&finish_date=' + finish_date.trim()
                    + 'card_no=' + card_no.trim() + '&pay_method=' + pay_method.trim() + '&amount=' + amount,
                type: 'post',
                data: extend_serivice_json_str,
                success: function (msg, status) {
                    var msg_obj = eval('(' + msg + ')');
                    if (msg_obj.status == 0) {
                        var scene_text = 'pay_maintain_task_id_' + msg_obj.task_id.toString();
                        var img = document.getElementById('qrcode');
                        img.src = 'http://weixin.snowmeet.com/show_wechat_temp_qrcode.aspx?scene=' + scene_text.trim() + '&&expire=300';
                        img.style.display = 'block';

                    }
                }
            });
        }

        function table_drp_changed() {
            for (var i = 0; i < table_drp_service_item_name_arr.length; i++) {
                if (table_drp_service_item_name_arr[i].value == '其它') {
                    table_txt_service_item_name_arr[i].style.display = '';
                }
                else {
                    table_txt_service_item_name_arr[i].style.display = 'none';
                }
            }
            //service_changed();
        }

        function table_more_insert() {
            var newIndex = table_more.getElementsByTagName('tr').length;
            table_more.innerHTML = table_more.innerHTML + '<tr>'
                + table_line_template.innerHTML.replace('_0', '_' + newIndex.toString()) + '</tr>'
        }
        function add_special_edge_item() {
            var find_empty_line = false;
            var tr_arr = table_more.getElementsByTagName('tr');
            for (var i = 1; i < tr_arr.length; i++) {
                var drp = tr_arr[i].getElementsByTagName('select')[0];
                if (drp.options[drp.selectedIndex].value == '') {
                    drp.options[1].selected = true;
                    document.getElementById('service_item_amount_' + (i-1).toString()).value = '50';
                    find_empty_line = true;
                    break;
                }
            }
            if (!find_empty_line) {
                table_more_insert();
                tr_arr = table_more.getElementsByTagName('tr');
                var drp = tr_arr[tr_arr.length - 1].getElementsByTagName('select')[0];
                drp.options[1].selected = true;
                document.getElementById('service_item_amount_' + (tr_arr.length-2).toString()).value = '50';
            }
        }
        function del_special_edge_item() {

        }

        //table_more_insert();
    </script>
</body>
</html>
