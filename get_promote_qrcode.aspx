<%@ Page Language="C#" %>
<script runat="server">

    public string openId = "";
    public string type = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        openId = Request["openid"] == null ? "oqrMvtySBUCd-r6-ZIivSwsmzr44" : Request["openid"].Trim();
        type = Request["type"] == null ? "" : Request["type"].Trim();
        long promoteId = Util.GetInviteCode(openId, type);
        string ticket = Util.GetQrCodeTicketTemp(Util.GetToken(), promoteId);
        byte[] qrCodeByteArr = Util.GetQrCodeByTicket(ticket);
        Response.ContentType = "image/jpeg";
        Response.BinaryWrite(qrCodeByteArr);
    }
</script>