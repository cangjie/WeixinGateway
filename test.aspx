<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Xml" %>
<!DOCTYPE html>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        Ticket.GenerateNewTicket("aaa", "aaa", 1);
        //ReceivedMessage receivedMessage = new ReceivedMessage("event_20180120213621556");
        //DealMessage.SendCustomeRequestToAssistant(receivedMessage);
        //OrderTemp tempOrder = OrderTemp.GetFinishedOrder(1065);
        //Ticket ticket = new Ticket("667120871");
        //Response.Write(ticket.Name.Trim());

    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div></div>
    </form>
</body>
</html>
