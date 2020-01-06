<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.Net" %>
<!DOCTYPE html>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        Card.CreatePackageCard("897604376");
        /*
        ReceivedMessage rec = new ReceivedMessage("event_20191227223553369");
        RepliedMessage repliedMessage = DealMessage.DealReceivedMessage(rec);
        RepliedMessage.AddRepliedMessage(repliedMessage);
        */
        //RepliedMessage repliedMessage = DealMessage.DealReceivedMessage(rec);
        //WeixinUser.MergeUser("18601197897");
        //Product.GetSkiPassList("万龙");
        //Sms.SendVerifiedSms("13501177897");
        /*
        DateTime currentTime = DateTime.Now;
        Response.Write(currentTime.ToString()+"<br/>");
        Response.Write("ToLocalTime:" + currentTime.ToLocalTime().ToString() + "<br/>");
        Response.Write("ToUniversalTime:" + currentTime.ToUniversalTime().ToString() + "<br/>");
        Response.Write(Util.GetTimeStamp(currentTime));
        */
        //OnlineOrder order = new OnlineOrder(4722);
        //order.Refund(0.01, "asdfasdfasdf");
        //Response.Write(DateTime.Now.ToString());
        /*
        HttpWebRequest req = (HttpWebRequest)WebRequest.Create("http://weixin.snowmeet.com/show_qrcode.aspx?sceneid=1569386461");
        HttpWebResponse res = (HttpWebResponse)req.GetResponse();
        Stream s = res.GetResponseStream();
        System.Drawing.Bitmap bmp = new System.Drawing.Bitmap(s);
        s.Close();
        res.Close();
        req.Abort();

        ThoughtWorks.QRCode.Codec.Data.QRCodeBitmapImage qrBmp = new ThoughtWorks.QRCode.Codec.Data.QRCodeBitmapImage(bmp);
        ThoughtWorks.QRCode.Codec.QRCodeDecoder decoder = new ThoughtWorks.QRCode.Codec.QRCodeDecoder();
        string qrUrl = decoder.decode(qrBmp);
        Response.Write(qrUrl);
        */
        //Core.Util.SetSnapFailed("https://s.taobao.com/search?q=capita", DateTime.Now.Date);
        //Response.Write(System.Text.Encoding.UTF8.ToString());
        //System.Text.Encoding.GetEncoding("UTF-8");

        //string ret = QrCode.GetStaticQrCode("shop_sale_charge_request_openid_oZBHkjhdFpC5ScK5FUU7HKXE3PJM", "images\\qrcode");
        //Response.Write(ret.Trim());

        //WeixinPaymentOrder weixinOrder = new WeixinPaymentOrder("1569564613004720");
        //weixinOrder.Refund(0.01);

        //ReceivedMessage rec = new ReceivedMessage("event_20190102154904968");
        //RepliedMessage repliedMessage = DealMessage.DealReceivedMessage(rec);

        //Response.Write(Request.Url.LocalPath.Trim().ToString() + "?" + Request.QueryString.ToString());

        //Response.End();
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript" >
        var start_time_string = "2019-9-30 14:10:00".replace(/-/g,'/');
        var start_time = Date.parse(start_time_string)/1000;
        var current_time = <%=Util.GetServerLocalTimeStamp()%>;
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <img src="<%//=QrCode.GetStaticQrCode("pay_product_id_137", "images/qrcode") %>" />
    </div>
    </form>
</body>
</html>
