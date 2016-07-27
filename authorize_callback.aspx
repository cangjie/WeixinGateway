<%@ Page Language="C#" %>
<%@ Import Namespace="System.Runtime.Serialization" %>
<%@ Import Namespace="System.Runtime.Serialization.Json" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>
<!DOCTYPE html>

<script runat="server">

    public int tryGetOpenIdTimes = 0;

    public object userAccessToken = "";

    public string callBackUrl = "";
    
    public object refreshToken = "";
    
    public string jsonStr = "";

    public string userInfoJsonStr  = "";


    public string GetOpenId(string code)
    {
        if (tryGetOpenIdTimes > 0)
        {
            System.Threading.Thread.Sleep(1000);
        }
        if (tryGetOpenIdTimes > 10)
        {
            return "";
        }
        tryGetOpenIdTimes++;
        
        string openIdStr = "";

        try
        {

            jsonStr = "";
            string jsonStrUrl = "https://api.weixin.qq.com/sns/oauth2/access_token?appid="
                + System.Configuration.ConfigurationSettings.AppSettings["wxappid"].Trim()
                + "&secret=" + System.Configuration.ConfigurationSettings.AppSettings["wxappsecret"].Trim()
                + "&code=" + code + "&grant_type=authorization_code";

            jsonStr = Util.GetWebContent(jsonStrUrl, "GET", "", "text/htm");

            JavaScriptSerializer serializer = new JavaScriptSerializer();
            Dictionary<string, object> json = (Dictionary<string, object>)serializer.DeserializeObject(jsonStr);
            object openId;
            json.TryGetValue("openid", out openId);

            
            json.TryGetValue("access_token", out userAccessToken);
            
            
            json.TryGetValue("refresh_token", out refreshToken);

            string userInfoJsonStr = WeixinUser.GetUserInfoJsonStr(openId.ToString().Trim(), userAccessToken.ToString().Trim(), refreshToken.ToString().Trim());



            object nick = "";
            object headImage = "";

            Dictionary<string, object> jsonUserInfo = (Dictionary<string, object>)serializer.DeserializeObject(userInfoJsonStr.Trim());
            jsonUserInfo.TryGetValue("nickname", out nick);
            jsonUserInfo.TryGetValue("headimgurl", out headImage);
            WeixinUser user = new WeixinUser(openId.ToString());
            user.Nick = nick.ToString().Trim();
            user.HeadImage = headImage.ToString().Trim();
            
            //Session["user_access_token"] = userAccessToken.ToString().Trim();
            //Session["refresh_token"] = refreshToken.ToString().Trim();
            
            openIdStr = openId.ToString().Trim();

        }
        catch
        { 
        
        }
        if (openIdStr.Trim().Equals(""))
        {
            return GetOpenId(code);
        }
        else
        {
            return openIdStr.Trim();
        }
        
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        string code = Request["code"].Trim();
        string state = Request["state"].Trim();
        string openId = GetOpenId(code);
        string callBack = Request["callback"].Trim();
        callBack = Server.UrlDecode(callBack);
        
        
        string token = WeixinUser.CreateToken(openId,DateTime.Now.AddMinutes(100));
        Session["user_token"] = token;

    
        if (callBack.IndexOf("?") > 0)
            callBack = callBack + "&token=" + token.Trim();
        else
            callBack = callBack + "?token=" + token.Trim();
        
        //Response.Redirect(callBack);

        callBackUrl = callBack;
        
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript" >
        window.localStorage.setItem("weixin_user_refresh_token", "<%=refreshToken.ToString()%>");
        window.localStorage.setItem("weixin_user_refresh_token_time_stamp", Date.parse(new Date()).toString());
	    window.location.href = "<%=callBackUrl%>";
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
    </div>
    </form>
</body>
</html>
