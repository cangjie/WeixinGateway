<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    public string timeStamp = "";
    public string nonceStr = "";
    public string prepayId = "";
    public string ticket = "";
    public string shaParam = "";
    public string appId = System.Configuration.ConfigurationSettings.AppSettings["wxappid"];
    public string jsPatameter = "";
    public string jsMd5 = "";
    public string signType = "MD5";
    public Order order;

    public int jsVersion = 1;

    public string callBackUrl = "";

    public int tryGetTicketTimes = 0;

    public string GetTicket()
    {
        string ticket = "";
        if (tryGetTicketTimes > 0)
        {
            System.Threading.Thread.Sleep(1000);
        }
        if (tryGetTicketTimes > 10)
        {
            return "";
        }
        tryGetTicketTimes++;
        try
        {
            string jsonStrForTicket = Util.GetWebContent("https://api.weixin.qq.com/cgi-bin/ticket/getticket?access_token="
                + Util.GetToken() + "&type=jsapi", "get", "", "form-data");
            ticket = Util.GetSimpleJsonValueByKey(jsonStrForTicket, "ticket");
        }
        catch
        {

        }
        if (ticket.Trim().Equals(""))
        {
            ticket = GetTicket();
        }
        return ticket;
    }

    protected void Page_Load(object sender, EventArgs e)
    {

        string no = Util.GetSafeRequestValue(Request, "no", "");
        WeixinPaymentOrder payOrder = new WeixinPaymentOrder(no.Trim());
        string jsApi = payOrder._fields["order_prepay_id"].ToString().Trim();



        timeStamp = Util.GetSimpleJsonValueByKey(jsApi.Trim(), "timeStamp").Trim();
        WeixinPaymentOrder order = new WeixinPaymentOrder(timeStamp);
        nonceStr = Util.GetSimpleJsonValueByKey(jsApi.Trim(), "nonceStr").Trim();
        prepayId = Util.GetSimpleJsonValueByKey(jsApi.Trim(), "package").Trim().Split('=')[1].Trim();
        appId = Util.GetSimpleJsonValueByKey(jsApi.Trim(), "appId").Trim();
        signType = Util.GetSimpleJsonValueByKey(jsApi.Trim(), "signType").Trim();
        jsMd5 = Util.GetSimpleJsonValueByKey(jsApi.Trim(), "paySign").Trim();
        shaParam = jsMd5;
        /*
        string jsonStrForTicket = Util.GetWebContent("https://api.weixin.qq.com/cgi-bin/ticket/getticket?access_token="
            + Util.GetToken() + "&type=jsapi", "get", "", "form-data");
        ticket = Util.GetSimpleJsonValueByKey(jsonStrForTicket, "ticket");
         */
        
        /*
        ticket = GetTicket();
        string shaString = "jsapi_ticket=" + ticket.Trim() + "&noncestr=" + nonceStr.Trim()
            + "&timestamp=" + timeStamp.Trim() + "&url=" + Request.Url.ToString().Trim();
        shaParam = Util.GetSHA1(shaString);



        string jsParameterStr = "timeStamp=" + timeStamp.Trim() + "&nonceStr=" + nonceStr.Trim()
                    + "&package=prepay_id=" + prepayId.Trim() + "&signType="+signType.Trim();
        if (jsVersion == 0)
            jsParameterStr = jsParameterStr.Replace("timeStamp", "timestamp");
        else
            jsParameterStr = "appId=" + appId.Trim() + "&" + jsParameterStr.Trim();

        jsParameterStr = Util.GetSortedArrayString(jsParameterStr);
        if (signType.Trim().Equals("MD5"))
            jsMd5 = Util.GetMd5Sign(jsParameterStr.Trim(), "ubsyrgj6wy1fn8qbyjx68lgmvli6eod0").ToUpper();
        else
            jsMd5 = Util.GetSHA1(jsParameterStr.Trim() + "&key=ubsyrgj6wy1fn8qbyjx68lgmvli6eod0");
        */


        order.Status = 1;

        callBackUrl = (Request["callback"] == null) ? "" : Request["callback"].Trim();
        callBackUrl = Server.UrlDecode(callBackUrl);
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <%
        if (jsVersion==0) 
        {
         %>
    <script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js" ></script>
    <%
    }
         %>
    <script type="text/javascript" >
<% if (jsVersion==0)
   {
       %>
        wx.config({
            debug: false,
            appId: '<%=appId%>',
                timestamp: '<% =timeStamp%>',
                nonceStr: '<%=nonceStr%>',
                signature: '<% =shaParam %>',
                jsApiList: ['chooseWXPay']
        });

        
        wx.ready(function() {
            //alert("config ready, start payment.");

            wx.chooseWXPay({
                timestamp:'<%=timeStamp%>',
                nonceStr:'<%=nonceStr%>',
                package:'prepay_id=<%=prepayId.Trim()%>',
                signType:'<%=signType%>',
                paySign:'<%=jsMd5.Trim()%>',
                success: function (res) {
                    alert(res.err_code + "!" + res.err_desc + "!" + res.err_msg);
                }
            });
        });
        
        <%}
        else
        {
   %>
        function callpay() {
            if (typeof WeixinJSBridge == "undefined") {
                if (document.addEventListener) {
                    document.addEventListener('WeixinJSBridgeReady', jsApiCall, false);
                } else if (document.attachEvent) {
                    document.attachEvent('WeixinJSBridgeReady', jsApiCall);
                    document.attachEvent('onWeixinJSBridgeReady', jsApiCall);
                }
            } else {
                jsApiCall();
            }
        }


        function jsApiCall() {
            //alert('prepare to pay');

            alert('<%=prepayId.Trim()%>');

            WeixinJSBridge.invoke('getBrandWCPayRequest',
                                {
                                    "appId": "<%=appId%>",
                                    "timeStamp": "<%=timeStamp%>",
                                    "nonceStr": "<%=nonceStr%>",
                                    "package": "prepay_id=<%=prepayId%>",
                                    "signType": "<%=signType%>",
                                    "paySign": "<%=jsMd5%>"
                                },
                function (res) {
                    //alert(res.err_code + "!" + res.err_desc + "!" + res.err_msg);
                    if (res.err_msg == "get_brand_wcpay_request:ok") {

                        var call_back_url = "<%=callBackUrl%>";
                        if (call_back_url=="") {
                            alert("Payment Success");
                        }
                        else {
                            window.location.href = call_back_url;
                        }
                    }
                }

                );
        }

        document.onload = callpay();
        
           
        <%
   }%>
        </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
    </div>
    </form>
</body>
</html>
