<%@ Page Language="C#" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>
<script runat="server">

    public string str = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        string paymentDomain = System.Configuration.ConfigurationSettings.AppSettings["payment_haojin_domain_name"];
        string md5Key = System.Configuration.ConfigurationSettings.AppSettings["haojin_key"];
        string appCode = System.Configuration.ConfigurationSettings.AppSettings["haojin_code"];

        string txamt = "1";
        string txcurrcd = "CNY";
        string pay_type = "800201";
        string out_trade_no = "qr_test_100";
        string txdtm = DateTime.Now.Year.ToString() + "-" + DateTime.Now.Month.ToString().PadLeft(2,'0') + "-"
            + DateTime.Now.Day.ToString().PadLeft(2,'0') + " " + DateTime.Now.Hour.ToString().PadLeft(2, '0') + ":"
            + DateTime.Now.Minute.ToString().PadLeft(2, '0') + ":" + DateTime.Now.Minute.ToString().PadLeft(2, '0');
        string goods_name = "snowmeet test";
        string mchid = "eA8qkhmq2M";

        string postData = "txamt=" + txamt + "&txcurrcd=" + txcurrcd + "&pay_type=" + pay_type + "&out_trade_no=" + out_trade_no
            + "&txdtm=" + txdtm +  "&goods_name=" + goods_name+"&mchid=" + mchid.Trim();

        string jumpUrl = "https://" + paymentDomain + "/trade/v1/payment";
        HttpWebRequest req = (HttpWebRequest)WebRequest.Create(jumpUrl);
        req.Method = "POST";
        req.ContentType = "application/x-www-form-urlencoded";
        req.Headers.Add("X-QF-APPCODE", appCode);
        req.Headers.Add("X-QF-SIGN", Util.GetHaojinMd5Sign(postData, md5Key));
        Stream requestStream = req.GetRequestStream();
        StreamWriter sw = new StreamWriter(requestStream);
        sw.Write(postData);
        sw.Close();
        HttpWebResponse res = (HttpWebResponse)req.GetResponse();
        StreamReader sr = new StreamReader(res.GetResponseStream());
        str = sr.ReadToEnd();
        sr.Close();
        res.Close();
        req.Abort();

    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    <% =str%>
    </div>
    </form>
</body>
</html>
