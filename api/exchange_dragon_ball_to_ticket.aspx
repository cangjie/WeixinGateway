<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string token = Util.GetSafeRequestValue(Request, "token", "").Trim();
        int templateId = int.Parse(Util.GetSafeRequestValue(Request, "templateid", "1"));
        string userOpenId = WeixinUser.CheckToken(token).Trim();
        Ticket.TicketTemplate ticketTemplate = Ticket.GetTicketTemplate(templateId);
        WeixinUser user = new WeixinUser(userOpenId);

        if (user.Points >= ticketTemplate.neetPoints)
        {
            int i = Point.AddNew(userOpenId, -1 * ticketTemplate.neetPoints, DateTime.Now, "兑换代金券");
            if (i > 0)
            {
                string code = Ticket.GenerateNewTicket(userOpenId, templateId);
                Response.Write("{\"status\" : 0, \"ticket_code\" : \"" + code.Trim() + "\" }");
            }
            else
            {
                Response.Write("{\"status\" : 1, \"error_message\" : \"can`t generate new ticket.\" }");
            }
        }
        else
        {
            Response.Write("{\"status\" : 1, \"error_message\" : \"User havn`t enough points.\" }");
        }

    }
</script>