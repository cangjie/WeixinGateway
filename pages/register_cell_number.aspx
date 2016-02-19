﻿<%@ Page Language="C#"%>

<!DOCTYPE html>

<script runat="server">

    public string headImage = "";

    public string openId = "";

    public WeixinUser currentUser;

    public string nick = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        string currentPageUrl = Server.UrlEncode("/pages/home_page.aspx");

        //Session["user_token"] = "3fc3e61137a7d36cbef5b96e6284a80f6956b62b1be61299b9cf566060aaa0cf74cc9b3c";
        
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

        currentUser = new WeixinUser(WeixinUser.CheckToken(userToken));

       
        

        string userInfoJson = Util.GetWebContent("http://" + Util.domainName.Trim() + "/get_user_info.aspx?openid=" + openId.Trim(), "GET", "", "text/html");
        headImage = Util.GetSimpleJsonValueByKey(userInfoJson, "headimgurl");
        nick = Util.GetSimpleJsonValueByKey(userInfoJson, "nickname");
        
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
                <div class="col-xs-8" ><input type="text"  style="width:150px" /></div>
            </div>
            <div class="row" >
                <div class="col-xs-12 center-block"><button id="send_validate_sms_button" style="width:100px;" type="button"  onclick="send_validate_sms_button_on_click()" class="center-block btn btn-xs btn-primary">绑定手机号码</button></div>
            </div>
        </div>
    <script type="text/javascript" >
        var sendValidateSmsButton = document.getElementById("send_validate_sms_button");
        function send_validate_sms_button_on_click()
        {
            var btnGetVerifyCode = document.getElementById("btn_get_verify_code");
            btnGetVerifyCode.disabled = true;
            var cell = document.getElementById("cell_number").value;
            $.ajax({
                url: "../api/verify_code_send.aspx",
                data:{cellnumber:cell},
                success: function () {
                    //alert("aa");
                }
            });
        }
    </script>
</body>
</html>
