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

        //Core.Util.SetSnapFailed("https://s.taobao.com/search?q=capita", DateTime.Now.Date);
        //Response.Write(System.Text.Encoding.UTF8.ToString());
        //System.Text.Encoding.GetEncoding("UTF-8");

        //string ret = QrCode.GetStaticQrCode("shop_sale_charge_request_openid_oZBHkjhdFpC5ScK5FUU7HKXE3PJM", "images\\qrcode");
        //Response.Write(ret.Trim());

        //WeixinPaymentOrder weixinOrder = new WeixinPaymentOrder("1568988121004718");
        //weixinOrder.Refund(1, 0.05);

        //ReceivedMessage rec = new ReceivedMessage("event_20190102154904968");
        //RepliedMessage repliedMessage = DealMessage.DealReceivedMessage(rec);

        //Response.Write(Request.Url.LocalPath.Trim().ToString() + "?" + Request.QueryString.ToString());

        //Response.End();
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>taobao cookie: <%=Core.TaobaoSnap.taobaoCookie.Trim() %></div>
    <div>tmall cookie: <%=Core.TaobaoSnap.tmallCookie.Trim() %></div>
    </form>
</body>
</html>
