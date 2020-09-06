﻿<%@ Page Language="C#" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>
<script runat="server">
    public string weixinPaymentJson = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        //Response.Write(Session["user_token"].ToString().Trim());
        //Response.End();


        int orderId = int.Parse(Util.GetSafeRequestValue(Request, "orderid", "204"));
        OnlineOrder order = new OnlineOrder(orderId);
        string mchid = Util.GetMchId(order);
        order.UpdateMchId(mchid);
        string paymentDomain = System.Configuration.ConfigurationSettings.AppSettings["payment_haojin_domain_name"];
        string md5Key = System.Configuration.ConfigurationSettings.AppSettings["haojin_key"];
        string appCode = System.Configuration.ConfigurationSettings.AppSettings["haojin_code"];
        string code = Util.GetSafeRequestValue(Request, "code", "081YvVAU1SsndV0yJPBU1ftKAU1YvVAa");//Request["code"].Trim();

        /*
        string jumpUrlOpenId = "https://" + paymentDomain + "/tool/v1/get_weixin_openid?code=" + code +"&mchid=" + mchid.Trim();
        HttpWebRequest reqOpenId = (HttpWebRequest)WebRequest.Create(jumpUrlOpenId);
        reqOpenId.Headers.Add("X-QF-APPCODE", appCode);
        reqOpenId.Headers.Add("X-QF-SIGN", Util.GetHaojinMd5Sign("code=" + code + "&mchid=" + mchid.Trim(), md5Key));
        HttpWebResponse resOpenId = (HttpWebResponse)reqOpenId.GetResponse();
        StreamReader srOpenId = new StreamReader(resOpenId.GetResponseStream());
        string strOpenId = srOpenId.ReadToEnd();
        srOpenId.Close();
        resOpenId.Close();
        reqOpenId.Abort();
        
        
        string openId = "";
        try
        {
            openId = Util.GetSimpleJsonValueByKey(strOpenId, "openid");
        }
        catch
        {
            Response.Write(strOpenId);
            Response.End();
        }
        
        */
        string openId = WeixinUser.CheckToken(Session["user_token"].ToString().Trim());

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

        if (order.OrderDetails.Length > 1)
            goods_name = goods_name + " 等" + order.orderDetails.Length.ToString() + "件商品";


        if (order.OrderDetails.Length > 1 && order.OrderDetails[1].productName.Trim().IndexOf("押金") >= 0)
        {

            goods_name = goods_name.Trim() + "-含雪具押金";
        }

        if (order.Type.Trim().Equals("店销"))
        {
            goods_name = order._fields["shop"].ToString().Trim() + " " + order._fields["type"].ToString() + " " + order._fields["pay_method"].ToString()
                + " " + order._fields["id"].ToString();
        }

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
                + Server.UrlEncode("http://weixin.snowmeet.top/payment/haojin_pay_finish.aspx?orderid=" + order._fields["id"].ToString())
                + "&package=" + Util.GetSimpleJsonValueByKey(weixinPaymentJson, "package")
                + "&timeStamp=" + Util.GetSimpleJsonValueByKey(weixinPaymentJson, "timeStamp")
                + "&signType=" + Util.GetSimpleJsonValueByKey(weixinPaymentJson, "signType")
                + "&paySign=" + Util.GetSimpleJsonValueByKey(weixinPaymentJson, "paySign")
                + "&appId=" + Util.GetSimpleJsonValueByKey(weixinPaymentJson, "appId")
                + "&nonceStr=" + Util.GetSimpleJsonValueByKey(weixinPaymentJson, "nonceStr");

            //Response.Write("<a href=\"" + jumpPayUrl + "\" >" + jumpPayUrl + "</a>");

           // Response.Redirect(jumpPayUrl, true);
        }
        catch(Exception err)
        {
            Response.Write(err.ToString().Trim() + "<br/>");
            Response.Write(postData.Trim() + "<br/>");
            Response.Write(sign + "<br/>");
            Response.Write(Encoding.Unicode.GetString(Encoding.Unicode.GetBytes(str.Trim())));
            Response.End();
        }
        
        
    }



</script>
<script type="text/javascript" >
    function onBridgeReady() {
        WeixinJSBridge.invoke(
            'getBrandWCPayRequest', {
                "appId": "<%=Util.GetSimpleJsonValueByKey(weixinPaymentJson, "appId")%>",     //公众号名称，由商户传入     
                "timeStamp": "<%=Util.GetSimpleJsonValueByKey(weixinPaymentJson, "timeStamp")%>",         //时间戳，自1970年以来的秒数     
                "nonceStr": "<%=Util.GetSimpleJsonValueByKey(weixinPaymentJson, "nonceStr")%>", //随机串     
                "package": "<%=Util.GetSimpleJsonValueByKey(weixinPaymentJson, "package")%>",
                "signType": "<%=Util.GetSimpleJsonValueByKey(weixinPaymentJson, "signType")%>",         //微信签名方式：     
                "paySign": "<%=Util.GetSimpleJsonValueByKey(weixinPaymentJson, "paySign")%>" //微信签名 
            },
            function (res) {
                if (res.err_msg == "get_brand_wcpay_request:ok") {
                    window.location.href = "/pages/ski_pass_list.aspx";
                }     // 使用以上方式判断前端返回,微信团队郑重提示：res.err_msg将在用户支付成功后返回    ok，但并不保证它绝对可靠。 
            }
        );
    }
    if (typeof WeixinJSBridge == "undefined") {
        if (document.addEventListener) {
            document.addEventListener('WeixinJSBridgeReady', onBridgeReady, false);
        } else if (document.attachEvent) {
            document.attachEvent('WeixinJSBridgeReady', onBridgeReady);
            document.attachEvent('onWeixinJSBridgeReady', onBridgeReady);
        }
    } else {
        onBridgeReady();
    }
</script>