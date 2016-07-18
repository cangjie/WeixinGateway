<%@ Page Language="C#" %>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string token = Util.GetSafeRequestValue(Request, "token", "5390c5d9569f72db0cb4b7393203e1a5a85a17c1f1a9b75c4abea87acd772e19f38ce2d6");
        string actionName = Util.GetSafeRequestValue(Request, "actionname", "");
        int articleId = int.Parse(Util.GetSafeRequestValue(Request, "articleid", "0"));
        string openId = Util.GetSafeRequestValue(Request, "openid", "");
        int sceneId = int.Parse(Util.GetSafeRequestValue(Request, "sceneid", "0"));
        string currentUserOpenId = WeixinUser.CheckToken(token);
        if (!currentUserOpenId.Equals(""))
        {
            UserAction.AddUserAction(currentUserOpenId, articleId.ToString(), openId.Trim(), 0, actionName.Trim());
        }
    }
</script>
