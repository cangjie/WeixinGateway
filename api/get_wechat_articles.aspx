<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string token = Util.GetToken();
        Response.Write(Util.GetWebContent("http://api.weixin.qq.com/cgi-bin/material/batchget_material?access_token=" + token.Trim()));
    }
</script>