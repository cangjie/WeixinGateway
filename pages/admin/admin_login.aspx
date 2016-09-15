<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <div id="file-upload">


        </div>
        <hr />
        <div id="file-upload-list">
            <asp:DataGrid ID="dg" runat="server" ></asp:DataGrid>
        </div>
    </div>
    </form>
</body>
</html>
