<%@ Page Language="C#" %>
<%@ Import Namespace="System.Runtime.Serialization" %>
<%@ Import Namespace="System.Runtime.Serialization.Json" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        string token = Util.GetAccessToken(System.Configuration.ConfigurationSettings.AppSettings["wxappid"].Trim(),
            System.Configuration.ConfigurationSettings.AppSettings["wxappsecret"].Trim());

        string openId = ((Request["openid"]==null)? "oqrMvt-Us9oUyRpmHttQKeKOdAA4" :  Request["openid"].Trim());

        HttpWebRequest req = (HttpWebRequest)WebRequest.Create("https://api.weixin.qq.com/cgi-bin/user/info?access_token="
            + token + "&openid="+openId+"&lang=zh_CN");
        HttpWebResponse res = (HttpWebResponse)req.GetResponse();
        Stream s = res.GetResponseStream();
        StreamReader sdr = new StreamReader(s);
        string j = sdr.ReadToEnd();
        sdr.Close();
        s.Close();
        res.Close();
        req.Abort();
        Response.Write(j);
    }
</script>