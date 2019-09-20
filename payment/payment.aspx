<%@ Page Language="C#" Debug="true" %>
<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.IO" %>
<!DOCTYPE html>

<script runat="server">

    public string body = "";
    public string detail = "";
    public string out_trade_no = "";
    public string fee = "";
    public string product_id = "";
    public string userAccessToken = "";
    public string openId = "";
    public string appId = "";
    public string appSecret = "";
    public string mch_id = "";
    public string nonce_str = "";
    public string timeStamp = "";
    public string jsPatameter = "";
    public string shaStr = "";
    public string shaStrOri = "";

    public string jsApi = "";

    protected void Page_Load(object sender, EventArgs e)
    {

        appId = System.Configuration.ConfigurationSettings.AppSettings["wxappid"].Trim();
        appSecret = System.Configuration.ConfigurationSettings.AppSettings["wxappsecret"].Trim();
        mch_id = System.Configuration.ConfigurationSettings.AppSettings["mch_id"].Trim();



        if (!IsPostBack)
        {
            if (Request["state"] == null)
            {
                string productId = Util.GetSafeRequestValue(Request, "product_id", "0");
                string callBackUrl = Util.GetSafeRequestValue(Request, "callback", "payment_get_result.aspx?token="
                    + Util.GetSafeRequestValue(Request, "token", "") + "&orderid=" + productId.Trim()); //(Request["callback"] == null) ? "" : Request["callback"].Trim();

                if (Request["product_id"] != null)
                    Session["product_id"] = Request["product_id"];


                try
                {
                    OnlineOrder order = new OnlineOrder(int.Parse(Session["product_id"].ToString().Trim()));
                    string openId = WeixinUser.CheckToken(Request["token"].Trim());

                    if (!order._fields["owner"].ToString().Trim().Equals(openId))
                    {
                        Response.Write("Invalid token");
                        Response.End();
                    }
                    int totalFee = int.Parse(Request["total_fee"].Trim());
                    int realPay = (int)Math.Round(100 * double.Parse(order._fields["real_pay"].ToString().Trim()), 0);
                    if (totalFee != realPay)
                    {
                        Response.Write(order._fields["real_pay"].ToString().Trim() + "!" + Request["total_fee"].Trim());
                        Response.Write("Fee wrong");
                        Response.End();
                    }
                }
                catch
                {

                }


                Session["call_back_url"] = callBackUrl+"&paymethod=wechat";

                GetUserAccessTokenAndOpneId();
            }
            else
            {
                string callBackUrl = (Session["call_back_url"] == null) ? "" : Session["call_back_url"].ToString().Trim();
                Session["call_back_url"] = "";
                callBackUrl = Server.UrlEncode(callBackUrl);
                string product_id = "";
                string prepayId = GetPrepayId(out product_id);

                Response.Write(prepayId.Trim());

                string redirectUrl = "payment_goto_bank.aspx?no=" + out_trade_no.Trim() + "&callback=" + callBackUrl;
                Response.Redirect(redirectUrl, true);


            }
        }
    }




    public string GetPrepayId(out string product_id)
    {
        XmlDocument xmlD = new XmlDocument();
        xmlD.LoadXml("<xml/>");
        XmlNode rootXmlNode = xmlD.SelectSingleNode("//xml");

        XmlNode n = xmlD.CreateNode(XmlNodeType.Element, "appid", "");
        n.InnerText = appId.Trim();
        rootXmlNode.AppendChild(n);

        n = xmlD.CreateNode(XmlNodeType.Element, "mch_id", "");
        n.InnerText = mch_id.Trim();
        rootXmlNode.AppendChild(n);

        string nonceStr = Util.GetNonceString(32);

        //nonceStr = "jihuo";

        nonce_str = nonceStr.Trim();
        n = xmlD.CreateNode(XmlNodeType.Element, "nonce_str", "");
        n.InnerText = nonceStr;
        rootXmlNode.AppendChild(n);

        n = xmlD.CreateNode(XmlNodeType.Element, "notify_url", "");
        n.InnerText = Request.Url.ToString().Trim().Replace("payment.aspx", "payment_callback.aspx").Trim();
        rootXmlNode.AppendChild(n);

        n = xmlD.CreateNode(XmlNodeType.Element, "openid", "");
        try
        {
            n.InnerText = Session["user_open_id"].ToString().Trim();
        }
        catch
        {
            n.InnerText = "";
        }
        rootXmlNode.AppendChild(n);

        n = xmlD.CreateNode(XmlNodeType.Element, "spbill_create_ip", "");
        n.InnerText = Request.UserHostAddress.Trim();
        rootXmlNode.AppendChild(n);



        n = xmlD.CreateNode(XmlNodeType.Element, "trade_type", "");
        n.InnerText = "JSAPI";
        rootXmlNode.AppendChild(n);

        if (Request["state"] != null)
        {
            string[] stateArr = Request["state"].Trim().Split('|');
            foreach (string statePair in stateArr)
            {
                string key = statePair.Split(':')[0].Trim();
                string v = "";
                try
                {
                    v = statePair.Split(':')[1].Trim();
                }
                catch
                {

                }
                if (!key.Equals("action"))
                {
                    n = xmlD.CreateNode(XmlNodeType.Element, key, "");
                    n.InnerText = v;
                    rootXmlNode.AppendChild(n);
                }

            }
        }

        n = xmlD.CreateNode(XmlNodeType.Element, "out_trade_no", "");
        timeStamp = Util.GetTimeStamp();
        product_id = rootXmlNode.SelectSingleNode("product_id").InnerText.Trim().PadLeft(6,'0');
        n.InnerText = timeStamp + rootXmlNode.SelectSingleNode("product_id").InnerText.Trim().PadLeft(6, '0');
        out_trade_no = n.InnerText.Trim();
        rootXmlNode.AppendChild(n);

        OnlineOrder onlineOrder = new OnlineOrder(int.Parse(product_id.Trim()));
        string body = onlineOrder._fields["shop"].ToString() + " " + onlineOrder._fields["type"].ToString().Trim();
        string detail = "";
        if (onlineOrder.OrderDetails.Length >= 1)
        {
            detail = onlineOrder.OrderDetails[0].productName.Trim();
        }
        else
        {
            detail = "店销备注：" + onlineOrder.Memo.Trim();
        }
        n = xmlD.CreateNode(XmlNodeType.Element, "body", "");
        n.InnerText = body.Trim();
        rootXmlNode.AppendChild(n);
        n = xmlD.CreateNode(XmlNodeType.Element, "detail", "");
        n.InnerText = detail.Trim();
        rootXmlNode.AppendChild(n);

        n = xmlD.CreateNode(XmlNodeType.Element, "total_fee", "");
        n.InnerText = ((int)Math.Round(100 * double.Parse(onlineOrder._fields["order_real_pay_price"].ToString()), 0)).ToString();
        rootXmlNode.AppendChild(n);



        string s = Util.ConverXmlDocumentToStringPair(xmlD);
        //     s = Util.GetMd5Sign(s, "jihuowangluoactivenetworkjarrodc");
        s = Util.GetMd5Sign(s, "ubsyrgj6wy1fn8qbyjx68lgmvli6eod0");
        n = xmlD.CreateNode(XmlNodeType.Element, "sign", "");
        n.InnerText = s.Trim();
        rootXmlNode.AppendChild(n);



        try
        {


            WeixinPaymentOrder.CreateOrder(
                rootXmlNode.SelectSingleNode("out_trade_no").InnerText.Trim(),
                rootXmlNode.SelectSingleNode("appid").InnerText.Trim(),
                rootXmlNode.SelectSingleNode("mch_id").InnerText.Trim(),
                rootXmlNode.SelectSingleNode("nonce_str").InnerText.Trim(),
                rootXmlNode.SelectSingleNode("openid").InnerText.Trim(),
                rootXmlNode.SelectSingleNode("body").InnerText.Trim(),
                rootXmlNode.SelectSingleNode("detail").InnerText.Trim(),
                rootXmlNode.SelectSingleNode("product_id").InnerText.Trim(),
                int.Parse(rootXmlNode.SelectSingleNode("total_fee").InnerText.Trim()),
                rootXmlNode.SelectSingleNode("spbill_create_ip").InnerText.Trim());
            


        }
        catch(Exception err)
        {
            Response.Write(err.ToString());
            Response.Write("<br/>" + xmlD.InnerXml.Trim().Replace("<", "&lt;").Replace(">", "&gt;"));
            Response.End();
        }

        string prepayXml = Util.GetWebContent("https://payapi.mch.weixin.semoor.cn/4.0/pay/unifiedorder", "post", xmlD.InnerXml.Trim(), "raw");

        //Response.Write(xmlD.InnerXml.Replace("<", "&lt;").Replace(">", "&gt;"));
        //Response.End();

        XmlDocument xmlDPrepayId = new XmlDocument();
        xmlDPrepayId.LoadXml(prepayXml);

        try
        {
            string prepayId = xmlDPrepayId.SelectSingleNode("//xml/prepay_id").InnerText.Trim();
            jsApi = xmlDPrepayId.SelectSingleNode("//xml/jsapi").InnerText.Trim();
            WeixinPaymentOrder order = new WeixinPaymentOrder(rootXmlNode.SelectSingleNode("out_trade_no").InnerText.Trim());
            order.PrepayId = jsApi;


            //Session["jsapi"] = jsApi;
            return jsApi.Trim();
        }
        catch(Exception err)
        {
            Response.Write(err.ToString() + "<br/>");
            Response.Write(rootXmlNode.InnerXml.Trim().Replace("<", "&lt;").Replace(">", "&gt;") + "<br/>");
            Response.Write(prepayXml.Trim().Replace("<", "&lt;").Replace(">", "&gt;"));
            Response.End();
            return "";
        }
    }

    public string GetStateStr()
    {
        string s = "action:payment";
        if (Request["body"] != null)
            s = s + "|body:" + Request["body"].Trim();
        if (Request["detail"] != null)
            s = s + "|detail:" + Request["detail"].Trim();
        if (Request["total_fee"] != null)
            s = s + "|total_fee:" + Request["total_fee"].Trim();
        if (Request["product_id"] != null)
            s = s + "|product_id:" + Request["product_id"].Trim();

        return Server.UrlEncode(s);
    }

    public void GetUserAccessTokenAndOpneId()
    {
        string stateStr = GetStateStr();
        string redirectUri = Server.UrlEncode(Request.Url.ToString().Trim().Replace("payment.aspx", "oauth20.aspx")).Replace(stateStr, "");
        if (redirectUri.EndsWith("?"))
            redirectUri = redirectUri.Remove(redirectUri.Length - 1, 1);
        string callBackUrl = (Request["callback"] == null) ? "" : Request["callback"].Trim();
        //redirectUri = redirectUri + "&callback=" + callBackUrl;
        //redirectUri = Server.UrlEncode(redirectUri);
        string getCodeUrl = "https://open.weixin.qq.com/connect/oauth2/authorize?"
            + "appid=" + appId.Trim() + "&redirect_uri=" +  redirectUri.Trim()
            + "&response_type=code&scope=snsapi_base&state=" + GetStateStr() + "#wechat_redirect";
        //Response.Write(getCodeUrl);
        Response.Redirect(getCodeUrl);
    }

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <%
       
        string jsonStrForTicket = Util.GetWebContent("https://api.weixin.qq.com/cgi-bin/ticket/getticket?access_token="
            + Util.GetToken() + "&type=jsapi","get","","form-data");
        string ticket = Util.GetSimpleJsonValueByKey(jsonStrForTicket, "ticket");
        shaStrOri = "jsapi_ticket=" + ticket.Trim() + "&noncestr=" + nonce_str.Trim()
            + "&timestamp=" + timeStamp.Trim() + "&url=" + Request.Url.ToString().Trim().Split('?')[0].Trim();
        shaStr = Util.GetSHA1(shaStrOri);
        
         %>
    
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <%=shaStrOri %><br />
        <%=nonce_str.Trim() %>
    </div>
    </form>
</body>
</html>
