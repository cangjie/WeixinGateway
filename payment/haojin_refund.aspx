<%@ Page Language="C#" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string token = Util.GetSafeRequestValue(Request, "token", "");
        int orderId = int.Parse(Util.GetSafeRequestValue(Request, "orderid", "341"));
        OnlineOrder order = new OnlineOrder(orderId);
        int txamt =  int.Parse(Util.GetSafeRequestValue(Request, "txamt", "1000"));
        string syssn = order._fields["syssn"].ToString().Trim();
        string mchid = order._fields["mchid"].ToString().Trim();
        string postData = "syssn=" + syssn.Trim() + "&out_trade_no=" + Util.GetTimeStamp().Trim() + "&txamt=" + txamt.ToString().Trim()
            + "&txdtm=" + DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss") + "&mchid=" + mchid ;
        string paymentDomain = System.Configuration.ConfigurationSettings.AppSettings["payment_haojin_domain_name"];
        string md5Key = System.Configuration.ConfigurationSettings.AppSettings["haojin_key"];
        string appCode = System.Configuration.ConfigurationSettings.AppSettings["haojin_code"];

        string jumpUrl = "https://" + paymentDomain + "/trade/v1/refund";
        HttpWebRequest req = (HttpWebRequest)WebRequest.Create(jumpUrl);
        req.Method = "POST";
        req.ContentType = "application/x-www-form-urlencoded";
        req.Headers.Add("X-QF-APPCODE", appCode);
        string sign = Util.GetHaojinMd5Sign(postData, md5Key);
        req.Headers.Add("X-QF-SIGN", sign.Trim());
        Stream requestStream = req.GetRequestStream();
        StreamWriter sw = new StreamWriter(requestStream);
        sw.Write(postData);
        sw.Close();
        HttpWebResponse res = (HttpWebResponse)req.GetResponse();
        StreamReader sr = new StreamReader(res.GetResponseStream());
        string str = sr.ReadToEnd();
        sr.Close();
        res.Close();
        req.Abort();

    }
</script>
