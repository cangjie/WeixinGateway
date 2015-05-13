<%@ Page Language="C#" %>
<%@ Import Namespace="System.Runtime.Serialization" %>
<%@ Import Namespace="System.Runtime.Serialization.Json" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        string openId = Util.GetSafeRequestValue(Request, "openid", "ocTHCuPdHRCPZrcJb2qWOE_EYjeI");
        string token = Util.GetToken();
        HttpWebRequest req = (HttpWebRequest)WebRequest.Create("https://api.weixin.qq.com/cgi-bin/user/info?access_token="
            + token + "&openid=" + openId + "&lang=zh_CN");
        HttpWebResponse res = (HttpWebResponse)req.GetResponse();
        Stream s = res.GetResponseStream();
        StreamReader sdr = new StreamReader(s);
        string j = sdr.ReadToEnd();
        sdr.Close();
        s.Close();
        res.Close();
        req.Abort();

        //JsonHelper json = new JsonHelper(j);
        
        
        Response.Write(j);
    }
</script>