<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string paymentDomain = System.Configuration.ConfigurationSettings.AppSettings["payment_haojin_domain_name"];
        string currentDomain = System.Configuration.ConfigurationSettings.AppSettings["domain_name"];
        string appCode = System.Configuration.ConfigurationSettings.AppSettings["haojin_app_id"];
        string md5Key = System.Configuration.ConfigurationSettings.AppSettings["haojin_app_key"];
        string redirectUri = "http://" + currentDomain + "/payment/haojin_step_2_get_code.aspx";
        string keyValuePair = "app_code=" + appCode.Trim() + "&redirect_uri=" + Server.UrlEncode(redirectUri.Trim());
        string jumpUrl = "https://" + paymentDomain + "/tool/v1/get_weixin_oauth_code?" + keyValuePair.Trim()
            + "&sign=" + Util.GetMd5Sign(keyValuePair,md5Key);
        Response.Redirect(jumpUrl, true);
    }
</script>
