﻿<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        int orderId = int.Parse(Util.GetSafeRequestValue(Request, "orderid", "0"));
        //OnlineOrder order = new OnlineOrder(orderId);

        string paymentDomain = System.Configuration.ConfigurationSettings.AppSettings["payment_haojin_domain_name"];
        string currentDomain = System.Configuration.ConfigurationSettings.AppSettings["domain_name"];
        string appCode = System.Configuration.ConfigurationSettings.AppSettings["haojin_app_id"];
        string md5Key = System.Configuration.ConfigurationSettings.AppSettings["haojin_app_key"];
        string redirectUri = "http://" + currentDomain + "/payment/haojin_pay_online_order_go_to_bank.aspx?orderid=" + orderId.ToString();
        string keyValuePair = "app_code=" + appCode.Trim() + "&redirect_uri=" + redirectUri.Trim() ;
        string keyValuePairEncode = keyValuePair.Replace(redirectUri, Server.UrlEncode(redirectUri));
        string jumpUrl = "https://" + paymentDomain + "/tool/v1/get_weixin_oauth_code?" + keyValuePairEncode.Trim()
            + "&sign=" + Util.GetHaojinMd5Sign(keyValuePair,md5Key);
        //Response.Redirect(jumpUrl, true);
        //Response.Write("<a href=\"" + jumpUrl + "\" >" + jumpUrl + "</a>");
        Response.Redirect(jumpUrl);


    }
</script>