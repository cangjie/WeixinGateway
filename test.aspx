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

        string url = "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=" + appId.Trim() + "&secret=" + appSecret.Trim();
        HttpWebRequest req = (HttpWebRequest)WebRequest.Create(url);
        HttpWebResponse res = (HttpWebResponse)req.GetResponse();
        Stream s = res.GetResponseStream();
        string ret = (new StreamReader(s)).ReadToEnd();
        s.Close();
        res.Close();
        req.Abort();

        Response.Write(ret);
        

        //Response.Write(Util.GetToken());
        
        //Response.Write(QrCode.GenerateNewQrCode(1, "images/qrcode"));
        
        //Response.Write(Util.GetQrCodeTicketTemp(Util.GetToken(), 1111));
        
        /*
        ReceivedMessage receiveMsg = new ReceivedMessage();
        receiveMsg.to = "gh_7c0c5cc0906a";
        receiveMsg.from = "oqrMvt8K6cwKt5T1yAavEylbJaRs";
        receiveMsg.type = "event";
        receiveMsg.userEvent = "CLICK";
        receiveMsg.eventKey = "PINGTAI";

        RepliedMessage repliedMessage = DealMessage.DealReceivedMessage(receiveMsg);
        repliedMessage.id = RepliedMessage.AddRepliedMessage(repliedMessage);
        XmlDocument xmlRet = Util.CreateReplyDocument(repliedMessage.id);
        Response.Write(xmlRet.InnerXml);
        */
        /*

        RepliedMessage.news[] newsArr = new RepliedMessage.news[2];
        newsArr[0] = new RepliedMessage.news();
        newsArr[0].title = "test1";
        newsArr[0].description = "test Description1";
        newsArr[0].picUrl = "http://www.nanshanski.com/images/ppt1.jpg";
        newsArr[0].url = "http://www.luqinwenda.com";

        newsArr[1] = new RepliedMessage.news();
        newsArr[1].title = "test2";
        newsArr[1].description = "test Description2";
        newsArr[1].picUrl = "http://www.nanshanski.com/images/ppt2.jpg";
        newsArr[1].url = "http://www.nanshanski.com";
        

        RepliedMessage rm = new RepliedMessage();
        rm.from = "gh_7c0c5cc0906a";
        rm.to = "oqrMvt8K6cwKt5T1yAavEylbJaRs";
        rm.type = "news";
        rm.newsContent = newsArr;
        rm.SendAsServiceMessage();
         */ 
        /*
        System.Xml.XmlDocument xmlD = new System.Xml.XmlDocument();
        xmlD.LoadXml("<xml>"
            + "<ToUserName><![CDATA[gh_7c0c5cc0906a]]></ToUserName>"
            + "<FromUserName><![CDATA[oqrMvt8K6cwKt5T1yAavEylbJaRs]]></FromUserName>"
            + "<CreateTime>1418115437</CreateTime>"
            + "<MsgType><![CDATA[text]]></MsgType>"
            + "<MsgId><![CDATA[" + DateTime.Now.ToString() + "]]></MsgId>"
            + "<Content><![CDATA[二维码]]></Content>"
            + "</xml>");
        ReceivedMessage receivedMessage = new ReceivedMessage(xmlD);
        ReceivedMessage.SaveReceivedMessage(receivedMessage);
        RepliedMessage repliedMessage = DealMessage.DealReceivedMessage(receivedMessage);
        repliedMessage.id = RepliedMessage.AddRepliedMessage(repliedMessage);
        XmlDocument xmlRet = Util.CreateReplyDocument(repliedMessage.id);
        Response.Write(xmlRet.InnerXml);
        */
        //Response.Write(Util.GetUserInfoJsonStringByOpenid("oqrMvtySBUCd-r6-ZIivSwsmzr44"));
        
        //DealLandingRequest("oqrMvtySBUCd-r6-ZIivSwsmzr44");
        //Stream qrStream = Util.GetAccessToken(

        /*
       string token = Util.GetAccessToken(System.Configuration.ConfigurationSettings.AppSettings["wxappid"].Trim(),
           System.Configuration.ConfigurationSettings.AppSettings["wxappsecret"].Trim());
       
       DateTime now = DateTime.Now;
       string ticket = Util.GetQrCodeTicketTemp(token, 123456789012345);
       Util.SaveBytesToFile(Server.MapPath("images/qrcode/" + now.Year.ToString() + now.Month.ToString().PadLeft(2, '0') 
           + now.Day.ToString().PadLeft(2, '0') + now.Hour.ToString().PadLeft(2, '0') + now.Minute.ToString().PadLeft(2, '0') 
           + now.Second.ToString().PadLeft(2, '0') + now.Millisecond.ToString().PadLeft(3, '0') + ".jpg"),
           Util.GetQrCodeByTicket(ticket));

       */
        //string mediaId = Util.UploadImageToWeixin(Server.MapPath("images/qrcode/20141015150455619.jpg"), token);
        
        //long i = long.Parse(Util.GetInviteCode("asdfasdfasdfasdf"));

        //string id = Util.GetInviteCode("aaaa");

        /*
        int id = ServiceMessage.CreateServiceMessage("gh_7c0c5cc0906a", "oqrMvt8K6cwKt5T1yAavEylbJaRs", "text", "hello");
        ServiceMessage testMessage = new ServiceMessage(id);
        testMessage.send(token);
        */
    }
    

    public void DealLandingRequest(string openId)
    {
        DateTime now = DateTime.Now;
        now = now.AddMinutes(-5);
        SqlDataAdapter da = new SqlDataAdapter(" select * from WxLoginRequest where WxLoginRequest_deal = 0 and wxloginrequest_crt > '" + now.ToString() + "' ",
            System.Configuration.ConfigurationSettings.AppSettings["constr"].Trim());
        DataTable dt = new DataTable();
        if (dt.Rows.Count >= 0)
        {
            SqlConnection conn = new SqlConnection(System.Configuration.ConfigurationSettings.AppSettings["constr"].Trim());
            SqlCommand cmd = new SqlCommand(" insert into WxLoginRequest (WxLoginRequest_openid ) values ('" + openId.Replace("'", "") + "' ) ", conn);
            conn.Open();
            cmd.ExecuteNonQuery();
            conn.Close();
            cmd.Dispose();
            conn.Dispose();
        }
        dt.Dispose();
        da.Dispose();
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
