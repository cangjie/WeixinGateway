<%@ Page Language="C#" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>

<script runat="server">
    public string weixinPaymentJson = "";
    protected void Page_Load(object sender, EventArgs e)
    {





        string shop = Util.GetSafeRequestValue(Request, "shop", "南山");
        string type = Util.GetSafeRequestValue(Request, "type", "雪票");

        int amnt = 0;
        string mchid = "";

        //int orderId = 0;
        if (shop.Trim().Equals("南山"))
        {
            if (type.Trim().Equals("雪票"))
            {
                amnt = 1;
                mchid = "rGrVYFadKD";
            }
            if (type.Trim().Equals("货品"))
            {
                amnt = 2;
                mchid = "DdAjZF6rrY";
            }
        }
        if (shop.Trim().Equals("乔波"))
        {
            if (type.Trim().Equals("雪票"))
            {
                amnt = 3;
                mchid = "wQ2V3sdZ95";
            }
            if (type.Trim().Equals("货品"))
            {
                amnt = 4;
                mchid = "eA8qkhmq2M";
            }
        }
        if (shop.Trim().Equals("八易"))
        {
            if (type.Trim().Equals("雪票"))
            {
                amnt = 5;
                mchid = "29dx6UlV5k";
            }
            if (type.Trim().Equals("货品"))
            {
                amnt = 6;
                mchid = "wQ2V3sMj71";
            }
        }
        if (shop.Trim().Equals("万龙"))
        {
            if (type.Trim().Equals("雪票"))
            {
                amnt = 7;
                mchid = "7BR7rSr3Kx";
            }
            if (type.Trim().Equals("货品"))
            {
                amnt = 8;
                mchid = "g6VB7srLmY";
            }
        }
        if (shop.Trim().Equals("总公司"))
        {
            amnt = 9;
            mchid = "K3nJAilYDN";
        }
        if (type.Trim().Equals("活动"))
        {
            if (shop.Trim().Equals("崇礼"))
            {
                mchid = "dPBJ1CL17v";
                amnt = 10;
            }
            if (shop.Trim().Equals("东北"))
            {
                amnt = 11;
                mchid = "1OLzAfWMD5";
            }
            if (shop.Trim().Equals("浆板"))
            {
                amnt = 12;
                mchid = "OdjrKFADv2";
            }
        }


        string paymentDomain = System.Configuration.ConfigurationSettings.AppSettings["payment_haojin_domain_name"];
        string md5Key = System.Configuration.ConfigurationSettings.AppSettings["haojin_key"];
        string appCode = System.Configuration.ConfigurationSettings.AppSettings["haojin_code"];

        string openId = "oZBHkjhdFpC5ScK5FUU7HKXE3PJM";

        string txamt = amnt.ToString();
        string txcurrcd = "CNY";
        string pay_type = "800207";
        string out_trade_no = Util.GetTimeStamp() + "0" + txamt.PadLeft(2,'0');
        string txdtm = DateTime.Now.Year.ToString() + "-" + DateTime.Now.Month.ToString().PadLeft(2,'0') + "-"
            + DateTime.Now.Day.ToString().PadLeft(2,'0') + " " + DateTime.Now.Hour.ToString().PadLeft(2, '0') + ":"
            + DateTime.Now.Minute.ToString().PadLeft(2, '0') + ":" + DateTime.Now.Minute.ToString().PadLeft(2, '0');
        string sub_openid = openId;
        string goods_name = "易龙雪聚 " + shop + " " + type ; 

        string postData = "txamt=" + txamt + "&txcurrcd=" + txcurrcd + "&pay_type=" + pay_type + "&out_trade_no=" + out_trade_no
            + "&txdtm=" + txdtm + "&sub_openid=" + sub_openid + "&goods_name=" + goods_name.Replace(" ", "") +"&mchid=" + mchid.Trim();

        string jumpUrl = "https://" + paymentDomain + "/trade/v1/payment";
        HttpWebRequest req = (HttpWebRequest)WebRequest.Create(jumpUrl);
        req.Method = "POST";
        req.ContentType = "application/x-www-form-urlencoded";
        req.Headers.Add("X-QF-APPCODE", appCode);
        string sign = Util.GetHaojinMd5Sign(postData, md5Key);
        req.Headers.Add("X-QF-SIGN", sign.Trim());
        Stream requestStream = req.GetRequestStream();
        StreamWriter sw = new StreamWriter(requestStream);
        sw.Write(postData);
        sw.Close();
        HttpWebResponse res = (HttpWebResponse)req.GetResponse();
        StreamReader sr = new StreamReader(res.GetResponseStream());
        string str = sr.ReadToEnd();
        sr.Close();
        res.Close();
        req.Abort();
        //Response.Write(appCode + "<br/>" + md5Key + "<br/>" + postData + "<br/>" + str);
        //Response.End();
        try
        {


            Dictionary<string, object> payParam = Util.GetObjectFromJsonByKey(str, "pay_params");
            KeyValuePair<string, object>[] keyValuePairArray = payParam.ToArray();

            weixinPaymentJson = Util.GetSimpleJsonStringFromKeyPairArray(keyValuePairArray);

            string jumpPayUrl = "https://o2.qfpay.com/q/direct?mchntnm=" + Server.UrlEncode("易龙雪聚")
                + "&txamt=" + txamt + "&goods_name=" + Server.UrlEncode(goods_name) + "&redirect_url="
                + Server.UrlEncode("http://weixin.snowmeet.com/payment/haojin_pay_finish.aspx?orderid=")// + order._fields["id"].ToString())
                + "&package=" + Util.GetSimpleJsonValueByKey(weixinPaymentJson, "package")
                + "&timeStamp=" + Util.GetSimpleJsonValueByKey(weixinPaymentJson, "timeStamp")
                + "&signType=" + Util.GetSimpleJsonValueByKey(weixinPaymentJson, "signType")
                + "&paySign=" + Util.GetSimpleJsonValueByKey(weixinPaymentJson, "paySign")
                + "&appId=" + Util.GetSimpleJsonValueByKey(weixinPaymentJson, "appId")
                + "&nonceStr=" + Util.GetSimpleJsonValueByKey(weixinPaymentJson, "nonceStr");

            //Response.Write("<a href=\"" + jumpPayUrl + "\" >" + jumpPayUrl + "</a>");

            Response.Redirect(jumpPayUrl, true);
        }
        catch(Exception err)
        {
            Response.Write(err.ToString().Trim() + "<br/>");
            Response.Write(postData.Trim() + "<br/>");
            Response.Write(sign + "<br/>");
            Response.Write(str.Trim());
        }

    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
    </div>
    </form>
</body>
</html>
