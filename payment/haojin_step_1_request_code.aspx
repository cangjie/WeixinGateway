<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string paymentDomain = System.Configuration.ConfigurationSettings.AppSettings["payment_haojin_domain_name"];
        string currentDomain = System.Configuration.ConfigurationSettings.AppSettings["domain_name"];
        string appCode = System.Configuration.ConfigurationSettings.AppSettings["haojin_app_id"];
        string redirectUri = "http://" + currentDomain + "/payment/haojin_step_2_get_code.aspx";
        string jumpUrl = "https://" + paymentDomain + "/tool/v1/get_weixin_oauth_code?app_code=" + appCode.Trim()
            + "&redirect_uri=" + Server.UrlEncode(redirectUri.Trim());
        Response.Redirect(jumpUrl, true);
    }
</script>
