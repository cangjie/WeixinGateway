<%@ Page Language="C#" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string paymentDomain = System.Configuration.ConfigurationSettings.AppSettings["payment_haojin_domain_name"];
        string md5Key = System.Configuration.ConfigurationSettings.AppSettings["haojin_app_key"];
        string code = Request["code"].Trim();
        string jumpUrl = "https://" + paymentDomain + "/tool/v1/get_weixin_openid?code=" + code;
        HttpWebRequest req = (HttpWebRequest)WebRequest.Create(jumpUrl);
        req.Headers.Add("sign", Util.GetHaojinMd5Sign("code=" + code, md5Key));
        HttpWebResponse res = (HttpWebResponse)req.GetResponse();
        StreamReader sr = new StreamReader(res.GetResponseStream());
        string str = sr.ReadToEnd();
        sr.Close();
        res.Close();
        req.Abort();
        Response.Write(str);
    }
</script>