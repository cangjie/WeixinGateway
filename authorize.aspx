<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    public string redirectUrl = "";
    public string callBack = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        callBack = Util.GetSafeRequestValue(Request, "callback",
            ((Request.UrlReferrer==null) ? "" : Request.UrlReferrer.ToString().Trim()));

        callBack = Server.UrlEncode(callBack);
        
        redirectUrl = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=" 
            + System.Configuration.ConfigurationSettings.AppSettings["wxappid"].Trim()   
            + "&redirect_uri=" + Server.UrlEncode("http://"
            + System.Configuration.ConfigurationSettings.AppSettings["domain_name"].Trim()
            + "/authorize_callback.aspx?callback=" + callBack) 
            + "&scope=snsapi_userinfo&response_type=code&state=1000#wechat_redirect";
        
        
        
        //Response.Write("<a href='" + redirectUrl + "'  >"+redirectUrl + "</a>");
        
        //Response.Redirect(redirectUrl, true);


	//Response.Write(redirectUrl);
	//Response.End();
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript" src="../js/jquery-1.3.2.min.js" ></script>
    <script type="text/javascript" >
        function getItemFromLocalStorage(itemName) {
            var value = "";
            try {
                value = window.localStorage.getItem(itemName).toString();
            }
            catch (errMsg){

            }
            return value;
        }

        var redirectUrl = "<%=redirectUrl%>";

        var open_id = "";

        var weixin_user_access_token = "";

        var weixin_user_refresh_token = getItemFromLocalStorage("weixin_user_refresh_token");
        var weixin_user_refresh_token_time_stamp = 0;
        try {
            weixin_user_refresh_token_time_stamp = parseInt(getItemFromLocalStorage("weixin_user_refresh_token_time_stamp"));
        }
        catch (errMsg) {
        }
        
        var currentTimeStamp = Date.parse(new Date());

        if (currentTimeStamp - weixin_user_refresh_token_time_stamp > 3600000 * 24 * 20) {

alert("aaa");
            window.location.href = redirectUrl;

        }
        else {

alert("weixin_user_refresh_token:"+weixin_user_refresh_token);
            var refresh_token_json_str = $.ajax({
                url: "api/weixin_token_refresh.aspx?refreshtoken=" + weixin_user_refresh_token,
                type: "get",
                async: false
            }).responseText.trim();
alert(refresh_token_json_str);
            if (refresh_token_json_str.indexOf("errcode") < 0) {
//alert("bbb");
                var refresh_token_json = JSON.parse(refresh_token_json_str);
                open_id = refresh_token_json.openid;
                weixin_user_access_token = refresh_token_json.access_token;
                weixin_user_refresh_token = refresh_token_json.refresh_token;
                weixin_user_refresh_token_time_stamp = currentTimeStamp;
                window.localStorage.setItem("weixin_user_refresh_token", weixin_user_refresh_token);
                window.localStorage.setItem("weixin_user_refresh_token_time_stamp", weixin_user_refresh_token_time_stamp);
                window.location.href = "authorize_jump.aspx?callback=<%=callBack.Trim()%>";

            }
            else {
                window.location.href = redirectUrl;
            }
            

        }




    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
    </div>
    </form>
</body>
</html>
