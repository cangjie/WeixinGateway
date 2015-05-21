<%@ Page Language="C#" %>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string token = Util.GetSafeRequestValue(Request, "token", "");
        string openId = Util.GetSafeRequestValue(Request, "openid", "");
        string state = Util.GetSafeRequestValue(Request, "state", "");

        string operOpenId = WeixinUser.CheckToken(token);
        WeixinUser operUser = new WeixinUser(operOpenId.Trim());

        string msg = "";

        if (!operUser.IsAdmin)
        {
            msg = "必须是管理员才能操作";
        }
        else
        {
            try
            {
                WeixinUser user = new WeixinUser(openId.Trim());
                user.VipLevel = int.Parse(state);
            }
            catch (Exception err)
            {
                msg = err.ToString();
            }
            
        }
        if (msg.Trim().Equals(""))
        {
            Response.Write("{\"status\" : 0}");
        }
        else
        {
            Response.Write("{\"status\": 1 , \"message\":\""+msg.Trim()+"\"");
        }
    }
</script>