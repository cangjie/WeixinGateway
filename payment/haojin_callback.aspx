<%@ Page Language="C#" %>
<%@ Import Namespace="System.IO" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string str = "";
        StreamReader sr = new StreamReader(Request.InputStream);
        str = sr.ReadToEnd();
        sr.Close();
        Response.Write(Session["user_token"].ToString());
    }
</script>