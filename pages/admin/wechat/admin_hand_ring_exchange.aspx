<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">
    public WeixinUser currentUser;
    public string openId = "";
    public string userToken = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        string currentPageUrl = Server.UrlEncode("/pages/admin/wechat/admin_hand_ring_exchange.aspx");
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
    <script type="text/javascript" >

        function get_qrcode() {
            var code = "";
            if (document.getElementById("txt_code_1").value != "")
                code = code + document.getElementById("txt_code_1").value + ",";
            if (document.getElementById("txt_code_2").value != "")
                code = code + document.getElementById("txt_code_2").value + ",";
            if (document.getElementById("txt_code_3").value != "")
                code = code + document.getElementById("txt_code_3").value + ",";
            if (document.getElementById("txt_code_4").value != "")
                code = code + document.getElementById("txt_code_4").value + ",";
            if (document.getElementById("txt_code_5").value != "")
                code = code + document.getElementById("txt_code_5").value + ",";
            if (code != "" && code.endsWith(","))
                code = code.substr(0, code.length - 1);

                
            
            var ajax_url = "../../../api/create_hand_ring_exchange_qrcode.aspx?token=<%=userToken%>&code=" + code;
               
            $.ajax({
                url: ajax_url,
                type: "GET",
                success: function (msg, status) {
                    var msg_object = eval("(" + msg + ")");
                    var qrcode_id = msg_object.exchange_id;
                    var td_cell = document.getElementById("qrcode_td");
                    td_cell.innerHTML = "<img style='width:200px' src='http://weixin.snowmeet.com/show_qrcode.aspx?sceneid=" + qrcode_id + "' />";
                }
            });
        }

    </script>
</head>
<body>
    <table class="table table-striped">
        <tr>
            <td colspan="2" >&nbsp;</td>
        </tr>
        <tr>
            <td style="width:140px">号码1：</td>
            <td style="white-space:nowrap; overflow:hidden">
                <input type="text" id="txt_code_1" style="width:100px" />
                <span style="color:red; width:10px; word-wrap:break-word" ></span>
            </td>
        </tr>
        <tr>
            <td style="width:140px">号码2：</td>
            <td style="white-space:nowrap; overflow:hidden">
                <input type="text" id="txt_code_2" style="width:100px"   />
                <span style="color:red; width:10px; word-wrap:break-word" ></span>
            </td>
        </tr>
        <tr>
            <td style="width:140px">号码3：</td>
            <td style="white-space:nowrap; overflow:hidden">
                <input type="text" id="txt_code_3" style="width:100px"  />
                <span style="color:red; width:10px; word-wrap:break-word" ></span>
            </td>
        </tr>
        <tr>
            <td style="width:140px">号码4：</td>
            <td style="white-space:nowrap; overflow:hidden">
                <input type="text" id="txt_code_4" style="width:100px" />
                <span style="color:red; width:10px; word-wrap:break-word" ></span>
            </td>
        </tr>
        <tr>
            <td style="width:140px">号码5：</td>
            <td style="white-space:nowrap; overflow:hidden">
                <input type="text" id="txt_code_5" style="width:100px"   />
                <span style="color:red; width:10px; word-wrap:break-word" ></span>
            </td>
        </tr>
         <tr>
            <td colspan="2" style="text-align:center"><button type="button" class="btn btn-default" onclick="get_qrcode()" >获取支付二维码</button></td>
        </tr>
        <tr>
            <td colspan="2" id="qrcode_td" style="text-align:center"></td>
        </tr>
    </table>
</body>
</html>
