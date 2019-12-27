<%@ Page Language="C#" %>
<%@ Import Namespace="System.IO" %>
<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        //QrCode.GenerateTempStaticQrcode("text_scene", 60, "/images/qrcode");
        Response.Write(QrCode.GetTempStaticQrCode("text_scene_1", 30, "/images/qrcode"));
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