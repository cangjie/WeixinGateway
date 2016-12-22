﻿<%@ Page Language="C#" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>
<script runat="server">

    public string weixinPaymentJson = "";


    protected void Page_Load(object sender, EventArgs e)
    {
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

        string txamt = "1";
        string txcurrcd = "CNY";
        string pay_type = "800207";
        string out_trade_no = "sn00001";
        string txdtm = DateTime.Now.Year.ToString() + "-" + DateTime.Now.Month.ToString().PadLeft(2,'0') + "-"
            + DateTime.Now.Day.ToString().PadLeft(2,'0') + " " + DateTime.Now.Hour.ToString().PadLeft(2, '0') + ":"
            + DateTime.Now.Minute.ToString().PadLeft(2, '0') + ":" + DateTime.Now.Minute.ToString().PadLeft(2, '0');
        string sub_openid = openId;
        string goods_name = "易龙雪聚测试商品";

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

        weixinPaymentJson = "{ " + Util.GetSimpleJsonStringFromKeyPairArray(keyValuePairArray) + " } ";

        //Response.Write(weixinPaymentJson );
    }
</script>
<%=weixinPaymentJson %>
<script type="text/javascript" >
    var json_str = '<%=weixinPaymentJson %>'; 
    var json = JSON.parse(json_str);
    function jsApiCall() {
        var payInvokeParam = {
            "appId": json.appId,
            "timeStamp": json.timeStamp,
            "nonceStr": json.nonceStr,
            "package": json.package,
            "signType": json.signType,
            "paySign": json.paySign
        };
        WeixinJSBridge.invoke('getBrandWCPayRequest', payInvokeParam, function (res) {
            if (res.err_msg == "get_brand_wcpay_request:ok") {
                alert("success");
            }
        });
    }
</script>