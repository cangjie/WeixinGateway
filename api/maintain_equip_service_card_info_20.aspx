<%@ Page Language="C#" %>
<%@ Import Namespace="System.IO" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        Stream inputRawStream = Request.InputStream;
        StreamReader sr = new StreamReader(inputRawStream, Encoding.UTF8);
        string inputRawString = sr.ReadToEnd();
        sr.Close();
        inputRawStream.Close();
        Response.Write(inputRawString.Trim());
    }
</script>