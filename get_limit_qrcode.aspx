<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        long scene = Request["scene"] == null ? 1 : long.Parse(Request["scene"].Trim());
        string ticket = Util.GetQrCodeTicket(Util.GetToken(), scene);
        byte[] qrCodeByteArr = Util.GetQrCodeByTicket(ticket);
        Response.ContentType = "image/jpeg";
        Response.BinaryWrite(qrCodeByteArr);
    }
</script>