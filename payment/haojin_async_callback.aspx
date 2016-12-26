<%@ Page Language="C#" %>
<%@ Import Namespace="System.IO" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        StreamReader sr = new StreamReader(Request.InputStream);
        string paymentResult = sr.ReadToEnd();
        sr.Close();
        File.AppendAllText(Server.MapPath("payment_result.txt"), paymentResult + "\r\n");
    }
</script>
SUCCESS