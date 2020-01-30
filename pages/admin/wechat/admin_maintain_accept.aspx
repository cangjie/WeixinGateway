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
                    <input type="checkbox" id="need_edge" style="width:20px;height:20px" />修刃<input id="degree" style="width:60px;height:30px" type="text" />度&nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="checkbox" id="need_candle" style="width:20px;height:20px"  />打蜡&nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="checkbox" id="need_fix" style="width:20px;height:20px"  />补板底
                </td>
            </tr>
            <tr>
                <td style="text-align:right" >取板时间:</td>
                <td>
                    <input type="text" id="finish_date" style="width:130px;height:30px" />&nbsp;&nbsp;&nbsp;&nbsp; 
                    <input type="radio" id="finish_today" style="width:20px;height:20px" name="finish_radio" />立等&nbsp; 
                    <input type="radio" id="finish_tomorrow" style="width:20px;height:20px" name="finish_radio" />次日
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
                    <input type="radio"  style="width:20px;height:20px" name="card" disabled />保养寄存次卡(剩余<span id="times" >1</span>次)&nbsp;&nbsp;
                    <input type="radio"  style="width:20px;height:20px" name="card" disabled />修刃卡&nbsp;&nbsp;
                    <input type="radio"  style="width:20px;height:20px" name="card" disabled />修刃打蜡卡&nbsp;&nbsp;

                </td>
            </tr>
            <tr>
                <td style="text-align:right" >金额:</td>
                <td><input type="text" id="amount" style="width:130px;height:30px" /></td>
            </tr>
            <tr>
                <td style="text-align:right" >支付方式：</td>
                <td>
                    <select >
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
        check_cell_number();
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
            }
            );
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
    </script>
</body>
</html>
