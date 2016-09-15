<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void Button1_Click(object sender, EventArgs e)
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
            <div>上传文件：<asp:FileUpload ID="FileUpload1" runat="server" />
&nbsp;(csv文件，用逗号分隔)</div>
            <div>备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注：<asp:TextBox ID="TextBox1" runat="server" Width="449px"></asp:TextBox>
            </div>
            <div>
                <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="上  传" />
            </div>

        </div>
        <hr />
        <div id="file-upload-list">
            <asp:DataGrid ID="dg" runat="server" ></asp:DataGrid>
        </div>
    </div>
    </form>
</body>
</html>
