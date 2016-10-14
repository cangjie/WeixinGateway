<%@ Page Language="C#" %>
<%@ Import Namespace="System.IO" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        int sceneId = int.Parse(Util.GetSafeRequestValue(Request, "sceneid", "1"));
        //QrCode qrCode = new QrCode(sceneId);
        string path = QrCode.GetQrCode(sceneId, "images/qrcode");

        
        
        //Response.Write(path);
        
        Response.ContentType = "image/jpeg";
        FileStream fs = File.OpenRead(Server.MapPath(path));
        byte[] bArr = new byte[fs.Length];
        for (int i = 0; i < fs.Length; i++)
        {
            bArr[i] = (byte)fs.ReadByte();
        }
        
        //QrCode qrCode = new QrCode(
        Response.BinaryWrite(bArr);
        
    }
</script>