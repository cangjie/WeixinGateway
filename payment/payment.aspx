<%@ Page Language="C#" %>
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
    public string appId = "";
    public string appSecret = "";
    public string mch_id = "";
    public string nonce_str = "";
    public string timeStamp = "";
    public string jsPatameter = "";
    public string shaStr = "";
    public string shaStrOri = "";

    public string openId = "aaa";
    
    protected void Page_Load(object sender, EventArgs e)
    {


        
        
        appId = System.Configuration.ConfigurationSettings.AppSettings["wxappid"].Trim();
        appSecret = System.Configuration.ConfigurationSettings.AppSettings["wxappsecret"].Trim();
        mch_id = System.Configuration.ConfigurationSettings.AppSettings["mch_id"].Trim();
        timeStamp = Util.GetLongTimeStamp(DateTime.Now).Trim();
        
        string userToken = ((Session["user_token"] == null) ? "" : Session["user_token"].ToString().Trim());
        openId = WeixinUser.CheckToken(userToken).Trim();
        //openId = "aaa";
        if (openId.Trim().Equals(""))
        {
            
            Response.Redirect("../authorize.aspx?callback=" + Server.UrlEncode("payment/payment.aspx?" + Request.QueryString.ToString().Trim() ), true);
        }
        else
        {
            Response.Write(Request["payment_callback"]);
            string callBackUrl = Util.GetSafeRequestValue(Request, "payment_callback", "");
            string orderId = "";
            string prepayId = GetPrepayId(out orderId);
            string redirectUrl = "payment_goto_bank.aspx?timestamp=" + timeStamp.Trim() + "&noncestr="
                + nonce_str.Trim() + "&prepayid=" + prepayId.Trim() + "&callback=" + callBackUrl;
            Response.Redirect(redirectUrl, true);
            //Response.End();
        }
       
    }

    


    public string GetPrepayId(out string orderId)
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


        n = xmlD.CreateNode(XmlNodeType.Element, "body", "");
        n.InnerText = Util.GetSafeRequestValue(Request, "body", "test");
        rootXmlNode.AppendChild(n);

        
        
        n = xmlD.CreateNode(XmlNodeType.Element, "out_trade_no", "");
        
        //orderId = rootXmlNode.SelectSingleNode("product_id").InnerText.Trim().PadLeft(6, '0');
        n.InnerText = timeStamp;
        rootXmlNode.AppendChild(n);
        
        
        
        n = xmlD.CreateNode(XmlNodeType.Element, "notify_url", "");
        n.InnerText = Request.Url.ToString().Trim().Replace("payment.aspx", "payment_callback.aspx").Trim();
        rootXmlNode.AppendChild(n);

        n = xmlD.CreateNode(XmlNodeType.Element, "openid", "");
        n.InnerText = openId;
        rootXmlNode.AppendChild(n);

        n = xmlD.CreateNode(XmlNodeType.Element, "spbill_create_ip", "");
        n.InnerText = Request.UserHostAddress.Trim();
        rootXmlNode.AppendChild(n);

        n = xmlD.CreateNode(XmlNodeType.Element, "total_fee", "");
        n.InnerText = Util.GetSafeRequestValue(Request, "total_fee", "1");
        rootXmlNode.AppendChild(n);

        n = xmlD.CreateNode(XmlNodeType.Element, "product_id", "");
        n.InnerText = Util.GetSafeRequestValue(Request, "product_id", "-1");
        rootXmlNode.AppendChild(n);
        
        
        n = xmlD.CreateNode(XmlNodeType.Element, "trade_type", "");
        n.InnerText = "JSAPI";
        rootXmlNode.AppendChild(n);

        
        
        
       

        
        
        string s = Util.ConverXmlDocumentToStringPair(xmlD);
        s = Util.GetMd5Sign(s, System.Configuration.ConfigurationSettings.AppSettings["payment_md5_key"].Trim());
        n = xmlD.CreateNode(XmlNodeType.Element, "sign", "");
        n.InnerText = s.Trim();
        rootXmlNode.AppendChild(n);

        File.AppendAllText(Server.MapPath("log/payment_test.txt"), xmlD.InnerXml.Trim() + "\r\n");
        
        
      
            Order.CreateOrder(
                rootXmlNode.SelectSingleNode("out_trade_no").InnerText.Trim(),
                rootXmlNode.SelectSingleNode("appid").InnerText.Trim(),
                rootXmlNode.SelectSingleNode("mch_id").InnerText.Trim(),
                rootXmlNode.SelectSingleNode("nonce_str").InnerText.Trim(),
                rootXmlNode.SelectSingleNode("openid").InnerText.Trim(),
                rootXmlNode.SelectSingleNode("body").InnerText.Trim(),
                "",
                rootXmlNode.SelectSingleNode("product_id").InnerText.Trim(),
                int.Parse(rootXmlNode.SelectSingleNode("total_fee").InnerText.Trim()),
                rootXmlNode.SelectSingleNode("spbill_create_ip").InnerText.Trim());
            
                
       

        
        
        
        
        string prepayXml = Util.GetWebContent("https://api.mch.weixin.qq.com/pay/unifiedorder", "post", xmlD.InnerXml.Trim(), "raw");

        File.AppendAllText(Server.MapPath("log/payment_test.txt"), prepayXml.Trim() + "\r\n");

        //Response.End();

        
        
        XmlDocument xmlDPrepayId = new XmlDocument();
        xmlDPrepayId.LoadXml(prepayXml);

        string prepayId = xmlDPrepayId.SelectSingleNode("//xml/prepay_id").InnerText.Trim();
        
        Order order = new Order(rootXmlNode.SelectSingleNode("out_trade_no").InnerText.Trim());
        order.PrepayId = prepayId.Trim();

        orderId = order._fields["order_out_trade_no"].ToString().Trim();
        
        return prepayId.Trim();
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
