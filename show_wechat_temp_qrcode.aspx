<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string scene = Util.GetSafeRequestValue(Request, "scene", "pay_channeled_product_id_144-0").Trim();
        int expireSeconds = int.Parse(Util.GetSafeRequestValue(Request, "expire", (30 * 24 * 3600).ToString()));
        string qrCodePath = QrCode.GetTempStaticQrCode(scene.Trim(), expireSeconds, "/images/qrcode");
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
    
    </div>
    </form>
</body>
</html>
