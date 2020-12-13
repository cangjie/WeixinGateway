<%@ Page Language="C#" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {

        /*
        string testUrl = "http://weixin.snowmeet.top/show_qrcode.aspx?sceneid=1582092807";
        HttpWebRequest reqt = (HttpWebRequest)WebRequest.Create(testUrl);
        HttpWebResponse rest = (HttpWebResponse)reqt.GetResponse();
        Stream st = rest.GetResponseStream();
        System.Drawing.Bitmap bmpt = new System.Drawing.Bitmap(st);
        st.Close();
        rest.Close();
        reqt.Abort();
        Response.End();
        */



        int deviceId = int.Parse(Util.GetSafeRequestValue(Request, "deviceid", "1"));
        Device device = new Device(deviceId);
        string qrCodeUrl = device._lastScan["qrcode_url"].ToString().Trim();

        HttpWebRequest req = (HttpWebRequest)WebRequest.Create(qrCodeUrl);
        HttpWebResponse res = (HttpWebResponse)req.GetResponse();
        Stream s = res.GetResponseStream();
        System.Drawing.Bitmap bmp = new System.Drawing.Bitmap(s);
        s.Close();
        res.Close();
        req.Abort();
        ThoughtWorks.QRCode.Codec.Data.QRCodeBitmapImage qrBmp = new ThoughtWorks.QRCode.Codec.Data.QRCodeBitmapImage(bmp);
        ThoughtWorks.QRCode.Codec.QRCodeDecoder decoder = new ThoughtWorks.QRCode.Codec.QRCodeDecoder();
        string qrUrl = decoder.decode(qrBmp);
        Response.Write("{\"device_id\": \"" + deviceId.ToString() + "\" , \"nick\": \"" + device._lastScan["nick"].ToString().Trim()
            + "\", \"head_image\":\"" + device._lastScan["head_image"].ToString()  + "\", \"scan_time\":\""
            + device._lastScan["timestamp"].ToString() + "\", \"next_qrcode\":\"" + qrCodeUrl.Trim() + "\", \"next_qrcode_url\": \"" + qrUrl.Trim() + "\", "
            + "\"open_id\": \"" + device._lastScan["open_id"].ToString().Trim() + "\"  }");
    }
</script>