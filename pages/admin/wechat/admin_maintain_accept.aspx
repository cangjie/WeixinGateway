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
                    <img style="width:100px;height:100px" src="http://thirdwx.qlogo.cn/mmopen/qE9MKluetOmAdicYiaLTickd4PMHcyDxib5N36S1g8SAWoGZjvd8HSLRKcpibom0ZJzwDQt4ibuqFAhOnqicMW30FRPsWF6NCDsfpoB/132" />
                </td>
                <td>
                    <table class="table" >
                        <tr>
                            <td style="text-align:right">手机:</td>
                            <td><input type="text" id="cell" value="13501177897" style="width:150px;height:30px"/></td>
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
                <td><input type="text" id="rfid" style="width:200px;height:30px" /> <a href="#" >生成</a></td>
            </tr>
            <tr>
                <td style="text-align:right" >品牌:</td>
                <td>
                    <input type="text" id="brand" style="width:100px;height:30px" />&nbsp; &nbsp; 
                    <input type="radio" id="ski" style="width:20px;height:20px" name="gender" />双板  &nbsp; &nbsp;  
                    <input type="radio" id="board" style="width:20px;height:20px" name="gender" />单板
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

</body>
</html>
