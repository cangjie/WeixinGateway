<%@ Page Language="C#" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>
<!DOCTYPE html>

<script runat="server">

    public string token = "a7319737ab87e79b9e651457c01ffec4274da233b0881e3a3ef91d9225acba6e9125f67f";

    public string openId = "";

    public int familyId = 1;

    public string sceneId = "0".PadLeft(32,'0');

    protected void Page_Load(object sender, EventArgs e)
    {
        //Authorize();
        familyId = int.Parse(Util.GetSafeRequestValue(Request,"family_id", "1"));
        sceneId = "4" + familyId.ToString().PadLeft(6, '0')+"000";
        //sceneId = sceneId.PadRight(16, '0');
        string wechatToken = Util.GetToken();

        string ticketJson = Util.GetWebContent("https://api.weixin.qq.com/cgi-bin/qrcode/create?access_token=" + wechatToken.Trim(),
            "POST",
            "{\"expire_seconds\": 604800, \"action_name\": \"QR_SCENE\", \"action_info\": {\"scene\": {\"scene_id\": "
            + sceneId.Trim() + "}}}", "text/json");

        string ticket = Util.GetSimpleJsonValueByKey(ticketJson, "ticket");

        byte[] bArr = Util.GetQrCodeByTicket(ticket);

        Response.ContentType = "image/jpeg";
        Response.BinaryWrite(bArr);
        
        
    }

    public void Authorize()
    {
        token = Session["user_token"] == null ? "" : Session["user_token"].ToString();
        if (token.Trim().Equals(""))
        {
            Response.Redirect("../authorize.aspx?callback="
                + Server.UrlEncode(Request.Url.ToString().Trim()), true);
        }
        openId = WeixinUser.CheckToken(token);
        if (openId.Trim().Equals(""))
        {
            Response.Redirect("../authorize.aspx?callback="
                + Server.UrlEncode(Request.Url.ToString().Trim()), true);
        }
        token = Session["user_token"].ToString().Trim();
        openId = WeixinUser.CheckToken(token);
    }
</script>