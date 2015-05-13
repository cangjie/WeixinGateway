<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        WeixinUser u = new WeixinUser("ocTHCuPdHRCPZrcJb2qWOE_EYjeI");
        
        string token = Util.GetSafeRequestValue(Request, "token", "");
        string openId = Util.GetSafeRequestValue(Request, "openid", "");
        string strClassId = Util.GetSafeRequestValue(Request, "classid", "0");
        string action = Util.GetSafeRequestValue(Request, "classid", "register");

    }
</script>