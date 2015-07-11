<%@ Page Language="C#" %>
<%@ Import Namespace="Gma.QrCodeNet.Encoding.Windows.Render" %>
<%@ Import Namespace="Gma.QrCodeNet.Encoding" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Drawing" %>
<%@ Import Namespace="System.Xml" %>
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
        try
        {
            n.InnerText = Request["body"].Trim();
        }
        catch
        {
            n.InnerText = "aaa";
        }
        rootXmlNode.AppendChild(n);

        n = xmlD.CreateNode(XmlNodeType.Element, "detail", "");
        try
        {
            n.InnerText = Request["detail"].Trim();
        }
        catch
        {
            n.InnerText = "bbb";
        }
        rootXmlNode.AppendChild(n);
        

        n = xmlD.CreateNode(XmlNodeType.Element, "total_fee", "");
        try
        {
            n.InnerText = Request["total_fee"].Trim();
        }
        catch
        {
            n.InnerText = "1";
        }
        rootXmlNode.AppendChild(n);

        string productId = "";
        
        n = xmlD.CreateNode(XmlNodeType.Element, "product_id", "");
        try
        {
            productId = Request["product_id"].Trim();
            
        }
        catch
        {
            productId = "ccc";
        }
        n.InnerText = productId;
        rootXmlNode.AppendChild(n);

        n = xmlD.CreateNode(XmlNodeType.Element, "notify_url", "");
        n.InnerText = Request.Url.ToString().Trim().Replace("payment_web_qrcode.aspx", "payment_callback.aspx").Trim().Split('?')[0].Trim();
        rootXmlNode.AppendChild(n);

        //n = xmlD.CreateNode(XmlNodeType.Element, "openid", "");
        //n.InnerText = Session["user_open_id"].ToString().Trim();

        //n.InnerText = "oqrMvt8K6cwKt5T1yAavEylbJaRs";
        //rootXmlNode.AppendChild(n);

       

        n = xmlD.CreateNode(XmlNodeType.Element, "spbill_create_ip", "");
        //n.InnerText = "116.90.84.36";
        n.InnerText = Request.UserHostAddress.Trim();
        rootXmlNode.AppendChild(n);

        n = xmlD.CreateNode(XmlNodeType.Element, "out_trade_no", "");
        timeStamp = Util.GetTimeStamp();
        n.InnerText = timeStamp+productId.PadLeft(6,'0');
        rootXmlNode.AppendChild(n);

        n = xmlD.CreateNode(XmlNodeType.Element, "trade_type", "");
        n.InnerText = "NATIVE";
        rootXmlNode.AppendChild(n);

        
        string s = Util.ConverXmlDocumentToStringPair(xmlD);
        s = Util.GetMd5Sign(s, "jihuowangluoactivenetworkjarrodc");
        n = xmlD.CreateNode(XmlNodeType.Element, "sign", "");
        n.InnerText = s.Trim();
        rootXmlNode.AppendChild(n);

        Order.CreateOrder(
                rootXmlNode.SelectSingleNode("out_trade_no").InnerText.Trim(),
                rootXmlNode.SelectSingleNode("appid").InnerText.Trim(),
                rootXmlNode.SelectSingleNode("mch_id").InnerText.Trim(),
                rootXmlNode.SelectSingleNode("nonce_str").InnerText.Trim(),
                "",
                rootXmlNode.SelectSingleNode("body").InnerText.Trim(),
                rootXmlNode.SelectSingleNode("detail").InnerText.Trim(),
                rootXmlNode.SelectSingleNode("product_id").InnerText.Trim(),
                int.Parse(rootXmlNode.SelectSingleNode("total_fee").InnerText.Trim()),
                rootXmlNode.SelectSingleNode("spbill_create_ip").InnerText.Trim());
           
        


        string prepayXml = Util.GetWebContent("https://api.mch.weixin.qq.com/pay/unifiedorder", "post", xmlD.InnerXml.Trim(), "raw");


        XmlDocument xmlRet = new XmlDocument();

        xmlRet.LoadXml(prepayXml);

        string content = "http://www.luqinwenda.com";

        content = xmlRet.SelectSingleNode("//xml/code_url").InnerText.Trim();

        var codeParams = CodeDescriptor.Init(ErrorCorrectionLevel.H, content, QuietZoneModules.Four, 9);

        codeParams.TryEncode();

        
        
        using (MemoryStream ms = new MemoryStream())
        {
            codeParams.Render(ms);
            ms.Position = 0;
            byte[] buffer = new byte[ms.Length];
            for (int i = 0; i < ms.Length; i++)
            {
                buffer[i] = (byte)ms.ReadByte();
            }
            Response.ContentType = "image/jpeg";
            Response.BinaryWrite(buffer);

                
        }
    }

    internal class CodeDescriptor
    {
        public ErrorCorrectionLevel Ecl;
        public string Content;
        public QuietZoneModules QuietZones;
        public int ModuleSize;
        public BitMatrix Matrix;
        public string ContentType;

        /// <summary>
        /// Parse QueryString that define the QR code properties
        /// </summary>
        /// <param name="request">HttpRequest containing HTTP GET data</param>
        /// <returns>A QR code descriptor object</returns>
        public static CodeDescriptor Init(ErrorCorrectionLevel level, string content, QuietZoneModules qzModules, int moduleSize)
        {
            var cp = new CodeDescriptor();

            //// Error correction level
            cp.Ecl = level;
            //// Code content to encode
            cp.Content = content;
            //// Size of the quiet zone
            cp.QuietZones = qzModules;
            //// Module size
            cp.ModuleSize = moduleSize;
            return cp;
        }

        /// <summary>
        /// Encode the content with desired parameters and save the generated Matrix
        /// </summary>
        /// <returns>True if the encoding succeeded, false if the content is empty or too large to fit in a QR code</returns>
        public bool TryEncode()
        {
            var encoder = new QrEncoder(Ecl);
            QrCode qr;
            if (!encoder.TryEncode(Content, out qr))
                return false;

            Matrix = qr.Matrix;
            return true;
        }

        /// <summary>
        /// Render the Matrix as a PNG image
        /// </summary>
        /// <param name="ms">MemoryStream to store the image bytes into</param>
        internal void Render(MemoryStream ms)
        {
            var render = new GraphicsRenderer(new FixedModuleSize(ModuleSize, QuietZones));
            render.WriteToStream(Matrix, System.Drawing.Imaging.ImageFormat.Png, ms);
            ContentType = "image/png";
        }
    }
</script>