<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Xml" %>
<!DOCTYPE html>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        //ReceivedMessage receivedMessage = new ReceivedMessage("event_20180120213621556");
        //DealMessage.SendCustomeRequestToAssistant(receivedMessage);
        OrderTemp tempOrder = OrderTemp.GetFinishedOrder(1065);
        if (order.HaveFinishedShopSaleOrder())
        {
        }

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
