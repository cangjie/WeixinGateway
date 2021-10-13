<%@ Page Language="C#" %>
<%@ Import Namespace="ThoughtWorks.QRCode.Codec" %>
<%@ Import Namespace="System.Drawing" %>
<%@ Import Namespace="System.IO" %>
<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        Random rnd = new Random();
        QRCodeEncoder enc = new QRCodeEncoder();
        for (int i = 1; i <= 2; i++)
        {
            for (int j = 1; j <= 5; j++)
            {
                for (int k = 1; k <= 50; k++)
                {
                    string code = rnd.Next(0, 999999).ToString().PadLeft(6, '0') + "21" + i.ToString() + j.ToString().PadLeft(2, '0') + k.ToString().PadLeft(4, '0');
                    File.AppendAllText(Server.MapPath("equip_qrcode/list.txt"), code + "\r\n");
                    Bitmap bmp = enc.Encode("http://weixin.snowmeet.top/scan_equip_qrcode.aspx?code=" + code.Trim());
                    string fileName = code.Substring(0, 3) + "-" + code.Substring(3, 3) + "-" + code.Substring(6, 3) + "-" + code.Substring(9, 3) + "-" + code.Substring(12, 3);
                    bmp.Save(Server.MapPath("equip_qrcode/" + fileName + ".bmp"));
                    bmp.Dispose();
                }
            }
        }
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
