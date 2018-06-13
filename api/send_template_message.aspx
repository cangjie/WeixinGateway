<%@ Page Language="C#" %>
<%@ Import Namespace="System.IO" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        Stream s = Request.InputStream;
        StreamReader sr = new StreamReader(s);
        string dataJson = sr.ReadToEnd();
        sr.Close();
        //Response.Write(dataJson);
        string url = "https://api.weixin.qq.com/cgi-bin/message/template/send?access_token=" + Util.GetToken();
        Response.Write(Util.GetWebContent(url, "POST", dataJson, "text/html"));
    }
</script>