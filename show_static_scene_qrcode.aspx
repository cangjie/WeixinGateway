<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    public string qrCodePath = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        qrCodePath = QrCode.GetStaticQrCode(Request["scene"].Trim(), "images/qrcode");
        Response.Redirect(qrCodePath, true);
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <%=qrCodePath %>
    </div>
    </form>
</body>
</html>
