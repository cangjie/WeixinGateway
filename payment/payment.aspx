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
    public string openId = "";
    public string appId = "";
    public string appSecret = "";
    public string mch_id = "";
    public string nonce_str = "";
    public string timeStamp = "";
    public string jsPatameter = "";
    public string shaStr = "";
    public string shaStrOri = "";
    protected void Page_Load(object sender, EventArgs e)
    {


        
        
        appId = System.Configuration.ConfigurationSettings.AppSettings["wxappid"].Trim();
        appSecret = System.Configuration.ConfigurationSettings.AppSettings["wxappsecret"].Trim();
        mch_id = System.Configuration.ConfigurationSettings.AppSettings["mch_id"].Trim();

        string userToken = ((Session["user_token"] == null) ? "" : Session["user_token"].ToString().Trim());
        string openId = WeixinUser.CheckToken(userToken).Trim();
        //openId = "";
        if (openId.Trim().Equals(""))
        {
            
            Response.Redirect("../authorize.aspx?callback=" + Server.UrlEncode("payment/payment.aspx?" + Request.QueryString.ToString().Trim() ), true);
        }
        else
        {
            Response.Write(Request["payment_callback"]);
            Response.End();
        }
       
        
        
        
        /*
        
        if (!IsPostBack)
        {
            if (Request["state"] == null)
            {
                string callBackUrl = (Request["callback"] == null) ? "" : Request["callback"].Trim();
                
                if (Request["product_id"] != null)
                    Session["product_id"] = Request["product_id"];
                if (callBackUrl.Trim().Equals(""))
                {
                    string body = (Request["body"] == null) ? "" : Request["body"].Trim();
                    body = Server.UrlDecode(body);
                    switch (body)
                    { 
                        case "“放飞梦想我能行”知心姐姐北京精品营再次出发":
                            callBackUrl = "http://www.luqinwenda.com/index.php?app=public&mod=Passport&act=paysuccess2&product_id=" + ((Request["product_id"] == null) ? "" : Request["product_id"].Trim());
                            break;
                        case "卢勤问答平台官方书城":
                            callBackUrl = "http://mall.luqinwenda.com/paySuccess.aspx?product_id=" + ((Request["product_id"] == null) ? "" : Request["product_id"].Trim()) ;
                            break;
                        case "卢勤问答平台官方夏令营":
                            callBackUrl = "http://mall.luqinwenda.com/paySuccess.aspx?product_id=" + ((Request["product_id"] == null) ? "" : Request["product_id"].Trim()) ;
                            break;
                        default:
                            callBackUrl = "http://www.luqinwenda.com/index.php?app=public&mod=Passport&act=paysuccess2&product_id=" + ((Request["product_id"] == null) ? "" : Request["product_id"].Trim());
                            break;
                    }
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
                string redirectUrl = "payment_goto_bank.aspx?timestamp=" + timeStamp.Trim()+product_id + "&noncestr="
                    + nonce_str.Trim() + "&prepayid=" + prepayId.Trim() + "&callback=" + callBackUrl;
                Response.Redirect(redirectUrl, true);
                
            }
        }
         */ 
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
        n.InnerText = Session["user_open_id"].ToString().Trim();
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
        rootXmlNode.AppendChild(n);
        
        string s = Util.ConverXmlDocumentToStringPair(xmlD);
        s = Util.GetMd5Sign(s, "jihuowangluoactivenetworkjarrodc");
        n = xmlD.CreateNode(XmlNodeType.Element, "sign", "");
        n.InnerText = s.Trim();
        rootXmlNode.AppendChild(n);

        try
        {
            Order.CreateOrder(
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
        catch
        { 
        
        }

        string prepayXml = Util.GetWebContent("https://api.mch.weixin.qq.com/pay/unifiedorder", "post", xmlD.InnerXml.Trim(), "raw");

        XmlDocument xmlDPrepayId = new XmlDocument();
        xmlDPrepayId.LoadXml(prepayXml);

        string prepayId = xmlDPrepayId.SelectSingleNode("//xml/prepay_id").InnerText.Trim();
        
        Order order = new Order(rootXmlNode.SelectSingleNode("out_trade_no").InnerText.Trim());
        order.PrepayId = prepayId.Trim();
        
        
        return prepayId.Trim();
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
