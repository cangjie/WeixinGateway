﻿<%@ Page Language="C#" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>
<script runat="server">
    public string weixinPaymentJson = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        int orderId = int.Parse(Util.GetSafeRequestValue(Request, "orderid", "0"));
        OnlineOrder order = new OnlineOrder(orderId);

        string paymentDomain = System.Configuration.ConfigurationSettings.AppSettings["payment_haojin_domain_name"];
        string md5Key = System.Configuration.ConfigurationSettings.AppSettings["haojin_app_key"];
        string appCode = System.Configuration.ConfigurationSettings.AppSettings["haojin_app_id"];
        string code = Request["code"].Trim();
        string jumpUrl = "https://" + paymentDomain + "/tool/v1/get_weixin_openid?code=" + code;
        HttpWebRequest req = (HttpWebRequest)WebRequest.Create(jumpUrl);
        req.Headers.Add("X-QF-APPCODE", appCode);
        req.Headers.Add("X-QF-SIGN", Util.GetHaojinMd5Sign("code=" + code, md5Key));
        HttpWebResponse res = (HttpWebResponse)req.GetResponse();
        StreamReader sr = new StreamReader(res.GetResponseStream());
        string str = sr.ReadToEnd();
        sr.Close();
        res.Close();
        req.Abort();
        string openId = Util.GetSimpleJsonValueByKey(str, "openid");

        string txamt = (order.OrderPrice*100).ToString();
        string txcurrcd = "CNY";
        string pay_type = "800207";
        string out_trade_no = order._fields["id"].ToString().Trim();
        string txdtm = DateTime.Now.Year.ToString() + "-" + DateTime.Now.Month.ToString().PadLeft(2,'0') + "-"
            + DateTime.Now.Day.ToString().PadLeft(2,'0') + " " + DateTime.Now.Hour.ToString().PadLeft(2, '0') + ":"
            + DateTime.Now.Minute.ToString().PadLeft(2, '0') + ":" + DateTime.Now.Minute.ToString().PadLeft(2, '0');
        string sub_openid = openId;

        string goods_name = "易龙雪聚";

        if (order.OrderDetails.Length > 0)
            goods_name = order.OrderDetails[0].productName.Trim();

        string postData = "txamt=" + txamt + "&txcurrcd=" + txcurrcd + "&pay_type=" + pay_type + "&out_trade_no=" + out_trade_no
            + "&txdtm=" + txdtm + "&sub_openid=" + sub_openid + "&goods_name=" + goods_name;

        jumpUrl = "https://" + paymentDomain + "/trade/v1/payment";
        req = (HttpWebRequest)WebRequest.Create(jumpUrl);
        req.Method = "POST";
        req.ContentType = "application/x-www-form-urlencoded";
        req.Headers.Add("X-QF-APPCODE", appCode);
        req.Headers.Add("X-QF-SIGN", Util.GetHaojinMd5Sign(postData, md5Key));
        Stream requestStream = req.GetRequestStream();
        StreamWriter sw = new StreamWriter(requestStream);
        sw.Write(postData);
        sw.Close();
        res = (HttpWebResponse)req.GetResponse();
        sr = new StreamReader(res.GetResponseStream());
        str = sr.ReadToEnd();
        sr.Close();
        res.Close();
        req.Abort();
        //Response.Write(postData + "<br/>" + str);

        Dictionary<string, object> payParam = Util.GetObjectFromJsonByKey(str, "pay_params");
        KeyValuePair<string, object>[] keyValuePairArray = payParam.ToArray();

        weixinPaymentJson = Util.GetSimpleJsonStringFromKeyPairArray(keyValuePairArray);

        string jumpPayUrl = "https://o2.qfpay.com/q/direct?mchntnm=" + Server.UrlEncode("易龙雪聚")
            + "&txamt=" + txamt + "&goods_name=" + Server.UrlEncode(goods_name) + "&redirect_url="
            + Server.UrlEncode("http://weixin.snowmeet.com/payment/haojin_pay_finish.aspx?orderid=" + order._fields["id"].ToString())
            + "&package=" + Util.GetSimpleJsonValueByKey(weixinPaymentJson, "package")
            + "&timeStamp=" + Util.GetSimpleJsonValueByKey(weixinPaymentJson, "timeStamp")
            + "&signType=" + Util.GetSimpleJsonValueByKey(weixinPaymentJson, "signType")
            + "&paySign=" + Util.GetSimpleJsonValueByKey(weixinPaymentJson, "paySign")
            + "&appId=" + Util.GetSimpleJsonValueByKey(weixinPaymentJson, "appId")
            + "&nonceStr=" + Util.GetSimpleJsonValueByKey(weixinPaymentJson, "nonceStr");
        Response.Redirect(jumpPayUrl, true);
    }
</script>