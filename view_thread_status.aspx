<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        Response.Write(ServiceMessage.sendThread.ThreadState.ToString());
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        System.Threading.ThreadStart threadStart = new System.Threading.ThreadStart(ServiceMessage.SendScheduleMessage);
        ServiceMessage.sendThread = new System.Threading.Thread(threadStart);
        ServiceMessage.sendThread.Start();

        Response.Write(ServiceMessage.sendThread.ThreadState.ToString());
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:Button ID="Button1" runat="server" Text="Button" OnClick="Button1_Click" />
    </div>
    </form>
</body>
</html>
