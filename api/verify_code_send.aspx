<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        Sms.SendVerifiedSms(Util.GetSafeRequestValue(Request, "cellnumber", "13501177897"));
    }
</script>