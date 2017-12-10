<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string code = Util.GetSafeRequestValue(Request, "code", "345678923");
        string token = Util.GetSafeRequestValue(Request, "token", "88fc446ee37b58ef2bafc997e654d7b7d32c64e9e30fda3e29c5c05211ee794a7a91f252");
        int type = int.Parse(Util.GetSafeRequestValue(Request, "type", "1"));
        Ticket t = new Ticket(code);
        string openId = WeixinUser.CheckToken(token.Trim());
        if (t.Owner.OpenId.Trim().Equals(openId))
        {
            Ticket.Share(code, type);
        }
    }
</script>