<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.Net" %>
<!DOCTYPE html>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        //WeixinUser user = new WeixinUser("oZBHkjoXAYNrx5wKCWRCD5qSGrPM");
        ReceivedMessage msg = new ReceivedMessage("event_20210109215431392");
        DealMessage.DealCommonEventMessage(msg);
       
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    
</head>
<body>
    <form id="form1" runat="server">
    <div>
       
    </div>
    </form>
</body>
</html>
