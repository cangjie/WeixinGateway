<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string code = Util.GetSafeRequestValue(Request, "code", "");
        string token = Util.GetSafeRequestValue(Request, "token", "");
        string word = Util.GetSafeRequestValue(Request, "word", "");

        WeixinUser user = new WeixinUser(WeixinUser.CheckToken(token));

        if (user.IsAdmin)
        {
            Ticket ticket = new Ticket(code);
            if (ticket.Use(word))
            {
                Response.Write("{\"status\":0}");
            }
            else
            {
                Response.Write("{\"status\":1}");
            }
        }
        else
        {
            Response.Write("{\"status\":1}");
        }

    }

</script>