﻿<%@ Page Language="C#" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Drawing" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string qrCodeText = Util.GetSafeRequestValue(Request, "qrcodetext", "");
        if (qrCodeText.Trim().Equals(""))
        {
            long sceneId = long.Parse(Util.GetSafeRequestValue(Request, "sceneid", "1"));
            string path = QrCode.GetQrCode(sceneId, "images/qrcode");
            Response.ContentType = "image/jpeg";
            FileStream fs = File.OpenRead(Server.MapPath(path));
            byte[] bArr = new byte[fs.Length];
            for (int i = 0; i < fs.Length; i++)
            {
                bArr[i] = (byte)fs.ReadByte();
            }
            Response.BinaryWrite(bArr);
            fs.Close();
        }
        else
        {
            ThoughtWorks.QRCode.Codec.QRCodeEncoder qrCodeEncoder = new ThoughtWorks.QRCode.Codec.QRCodeEncoder();
            Bitmap bmp = qrCodeEncoder.Encode(qrCodeText);
            string qrCodeFileName = "temp_qrcode_" + Util.GetTimeStamp().ToString() + ".bmp";
            bmp.Save(Server.MapPath("images/qrcode/" + qrCodeFileName.Trim()));
            bmp.Dispose();
            Response.ContentType = "image/jpeg";
            FileStream fs = File.OpenRead(Server.MapPath("images/qrcode/" + qrCodeFileName.Trim()));
            byte[] bArr = new byte[fs.Length];
            for (int i = 0; i < fs.Length; i++)
            {
                bArr[i] = (byte)fs.ReadByte();
            }
            Response.BinaryWrite(bArr);
            fs.Close();
            try
            {
                File.Delete(Server.MapPath("images/qrcode/" + qrCodeFileName.Trim()));
            }
            catch
            {

            }
        }

    }
</script>