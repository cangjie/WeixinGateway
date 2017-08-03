<%@ Page Language="C#" %>
<%@ Import Namespace="System.IO" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string md5Key = "ABCDEF7768";
        string sn = Util.GetSafeRequestValue(Request, "sn", "Q11163910128");
        string requestTime = Util.GetSafeRequestValue(Request, "requesttime", "123456");
        string sign = Util.GetMd5(sn.Trim() + requestTime.Trim() + md5Key);
        if (!sign.Equals(Util.GetSafeRequestValue(Request, "sign", "")))
        {
            //Response.End();
        }

        Stream requestBodyStream = Request.InputStream;
        StreamReader sr = new StreamReader(requestBodyStream);
        string jsonStr = sr.ReadToEnd();
        sr.Close();
        requestBodyStream.Close();
        Response.Write("!"+jsonStr+"!");
    }
</script>