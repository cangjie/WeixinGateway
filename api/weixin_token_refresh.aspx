<%@ Page Language="C#" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string refreshToken = Util.GetSafeRequestValue(Request, "refreshtoken", "");
        string jsonStr = WeixinUser.GetNewWeixinToken(refreshToken.Trim());
        if (jsonStr.IndexOf("errcode") < 0)
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            Dictionary<string, object> json = (Dictionary<string, object>)serializer.DeserializeObject(jsonStr);
            object openId;
            json.TryGetValue("openid", out openId);
            object accessToken;
            json.TryGetValue("access_token",out accessToken);
            WeixinUser user = new WeixinUser(openId.ToString());

            string jsonUserInfoStr = Util.GetWebContent("https://api.weixin.qq.com/sns/userinfo?access_token="
                + accessToken.ToString().Trim() + "&openid=" + openId.ToString() + "&lang=zh_CN");
            Dictionary<string, object> jsonUserInfo = (Dictionary<string, object>)serializer.DeserializeObject(jsonUserInfoStr);
            object nick;
            object headImage;
            jsonUserInfo.TryGetValue("nickname", out nick);
            jsonUserInfo.TryGetValue("headimgurl", out headImage);

            user.Nick = nick.ToString();
            user.HeadImage = headImage.ToString();
            
            string token = WeixinUser.CreateToken(openId.ToString(), DateTime.Now.AddMinutes(100));
            Session["user_token"] = token;
            object weixinToken;
            json.TryGetValue("access_token", out weixinToken);
            
            
        }
        Response.Write(jsonStr);
    }
</script>