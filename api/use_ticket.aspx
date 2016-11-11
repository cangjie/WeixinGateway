<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string code = Util.GetSafeRequestValue(Request, "code", "065042308");
        string token = Util.GetSafeRequestValue(Request, "token", "dbb4b41e76861369b698a9288e6ca30caecbaa4873097943dea8b702f58881c74f570e1f");
        string word = Util.GetSafeRequestValue(Request, "word", "test");

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