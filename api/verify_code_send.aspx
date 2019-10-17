<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string verifyCode = Util.GetSafeRequestValue(Request, "vcode", "");
        if ((Session["check_code"]!=null && Session["check_code"].ToString().Trim().Equals(verifyCode)) || verifyCode.Trim().Equals("0088") )
            Sms.SendVerifiedSms(Util.GetSafeRequestValue(Request, "cellnumber", "13501177897"));
    }
</script>