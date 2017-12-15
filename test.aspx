<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Xml" %>
<!DOCTYPE html>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        //Ticket t = new Ticket("345678923");
        //t.IsSharing = true;
        //t.Transfer("oZBHkjoXAYNrx5wKCWRCD5qSGrPM");

        ReceivedMessage rec = new ReceivedMessage("event_20171215170518698");
        DealMessage.DealEventMessage(rec);

        /*
        string no = "";
        for (int i = 0; i < 500; i++)
        {
            no = Card.GenerateCardNoWithPassword(9, 1, 6, "内购券");
            if (no.Trim().Equals(""))
                i--;
        }
        */
        //OrderTemp orderTemp = new OrderTemp(25);
        //orderTemp.PlaceOnlineOrder("oZBHkjhdFpC5ScK5FUU7HKXE3PJM");
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
