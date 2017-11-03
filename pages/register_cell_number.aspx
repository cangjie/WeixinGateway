<%@ Page Language="C#"%>

<!DOCTYPE html>

<script runat="server">

    public string headImage = "";

    public string openId = "";

    public WeixinUser currentUser;

    public string nick = "";

    public string fatherCellNumber = "";

    public string refUrl = "/pages/ski_pass_product_list.aspx";

    protected void Page_Load(object sender, EventArgs e)
    {
        string currentPageUrl = Server.UrlEncode("/pages/register_cell_number.aspx");

        refUrl = Server.UrlDecode(Util.GetSafeRequestValue(Request, "refurl", "/pages/ski_pass_product_list.aspx"));

        if (Session["user_token"] == null || Session["user_token"].ToString().Trim().Equals(""))
        {
            Response.Redirect("../authorize.aspx?callback=" + currentPageUrl, true);

        }
        string userToken = Session["user_token"].ToString();
        openId = WeixinUser.CheckToken(userToken);
        if (openId.Trim().Equals(""))
        {
            Response.Redirect("../authorize.aspx?callback=" + currentPageUrl, true);
        }

        refUrl = Util.GetSafeRequestValue(Request, "refurl", refUrl);

        currentUser = new WeixinUser(WeixinUser.CheckToken(userToken));

        if (currentUser.VipLevel == 0)
        {

            string userInfoJson = Util.GetWebContent("http://" + Util.domainName.Trim() + "/get_user_info.aspx?openid=" + openId.Trim(), "GET", "", "text/html");
            headImage = Util.GetSimpleJsonValueByKey(userInfoJson, "headimgurl");
            nick = Util.GetSimpleJsonValueByKey(userInfoJson, "nickname");
            string fatherOpenId = currentUser.FatherOpenId.Trim();
            if (fatherOpenId.Trim().Equals(""))
            {
                fatherOpenId = currentUser.LastScanedOpenId;
                if (fatherOpenId.Trim().Equals(""))
                {
                    fatherOpenId = Util.GetSafeRequestValue(Request, "fatheropenid", "");
                }
            }
            if (!fatherOpenId.Trim().Equals(""))
            {
                WeixinUser fatherUser = new WeixinUser(fatherOpenId);
                fatherCellNumber = fatherUser.CellNumber.Trim();
            }
        }
        else
        {
            Response.Redirect(refUrl, true);
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

</head>
<body>
   
        <div class="container" >
            <div ><br /></div>
            <div class="row" >
                <div class="col-xs-12" ><p class="text-center"><strong>请先绑定手机号码</strong></p></div>
            </div>
            <div class="row" >
                <div class="col-xs-12">
                    <img style="width:100px;height:100px;" class="center-block img-circle" src="<%=headImage %>" />
                </div>
            </div>
            <div class="row" >
                <div class="col-xs-12" ><br /></div>
            </div>
            <div class="row" >
                <div class="col-xs-4" ><p class="text-right">昵称：</p></div>
                <div class="col-xs-8" ><input  readonly="yes" type="text" style="width:150px" value="<%=nick %>"  /></div>
            </div>
            <div class="row" >
                <div class="col-xs-4" ><p class="text-right">手机号：</p></div>
                <div class="col-xs-8" ><input type="text" id="cell_number" style="width:150px" />
                    <button id="btn_get_verify_code"  type="button"  onclick="send_validate_sms_button_on_click()" class="btn btn-xs btn-primary">获取验证码</button></div>
            </div>
            <div class="row" >
                <div class="col-xs-4" ><p class="text-right">验证码：</p></div>
                <div class="col-xs-8" ><input type="text" id="verify_code"  style="width:150px" /></div>
            </div>
            <div class="row" >
                <div class="col-xs-4" ><p class="text-right">推荐人手机号(若没有，可不填)：</p></div>
                <div class="col-xs-8" ><input type="text" id="father_cell_number"  style="width:150px" value="<%=fatherCellNumber %>"/></div>
            </div>
            <div class="row" >
                <div class="col-xs-12 center-block"><button id="bind_cell_number_button" style="width:100px;" type="button"  onclick="bind_cell_number_button_on_click()" class="center-block btn btn-xs btn-primary">绑定手机号码</button></div>
            </div>
        </div>
    <script type="text/javascript" >
        var sendValidateSmsButton = document.getElementById("send_validate_sms_button");

        var last_send_verify_code_seconds = 60;

        var int = 0;

        function send_validate_sms_button_on_click()
        {
            var btnGetVerifyCode = document.getElementById("btn_get_verify_code");
            btnGetVerifyCode.disabled = true;
            var int = setInterval("reset_send_verify_code_button_text()", 1000);
            var cell = document.getElementById("cell_number").value;
            
            $.ajax({
                url: "../api/verify_code_send.aspx",
                data:{cellnumber:cell},
                success: function () {
                    //alert("aa");
                }
            });
        }



        function reset_send_verify_code_button_text() {
            var btnGetVerifyCode = document.getElementById("btn_get_verify_code");
            if (last_send_verify_code_seconds == 0) {
                btnGetVerifyCode.innerText = "获取验证码";
                btnGetVerifyCode.disabled = false;
                clearInterval(int);
            }
            else {
                last_send_verify_code_seconds--;
                
                btnGetVerifyCode.innerText = last_send_verify_code_seconds + "s 后重发。";
            }
        }

        function bind_cell_number_button_on_click() {
            var cell = document.getElementById("cell_number").value.trim();
            var verify_code = document.getElementById("verify_code").value.trim();
            var father_cell_number = document.getElementById("father_cell_number").value.trim();
            var token = "<%=Session["user_token"].ToString()%>";
            $.ajax({
                url: "../api/verify_code_bind_cell_number.aspx",
                data: { cellnumber: cell, verifycode: verify_code, token: token, father_cell_number: father_cell_number },
                async: false,
                success: function (msg, status) {
                    var msg_object = eval("(" + msg + ")");
                    if (status == "success" && msg_object.status == 0 && msg_object.result == 1) {
                        alert("手机绑定成功");
                        window.location.href = "<%=refUrl%>";
                    }
                    else {
                        alert(msg_object.error_message);
                    }

                }
            });
        }


    </script>
</body>
</html>
