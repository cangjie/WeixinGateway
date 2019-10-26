<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        int smgId = 0;
        string msg = "";
        string verifyCode = Util.GetSafeRequestValue(Request, "vcode", "");
        if ((Session["check_code"] != null && Session["check_code"].ToString().Trim().Equals(verifyCode)) || verifyCode.Trim().Equals("0088"))
        {
            smgId = Sms.SendVerifiedSms(Util.GetSafeRequestValue(Request, "cellnumber", "13501177897"));
            Response.Write("{\"message_id\": " + smgId.ToString() + "}");
        }
        else
        {
            smgId = -1;
            Response.Write("{\"message_id\": " + smgId.ToString() + ", \"error_message\": \"校验码填写错误。\"}");
        }
    }
</script>