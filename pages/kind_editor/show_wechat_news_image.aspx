<%@ Page Language="C#" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        Response.ContentType = "image/jpeg";
        string imageUrl = Util.GetSafeRequestValue(Request, "imageurl",
            "https://mmbiz.qpic.cn/mmbiz_png/pibCAzzGRCmPBDLBI0qudJxM7UlcNCHs6j1yfw00NDU1aWYXicN8Vy30Z9IT6TibceYOKqQXdHGnshVhq6zD6WjdA/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1");
        HttpWebRequest request = (HttpWebRequest)WebRequest.Create(Server.UrlDecode(imageUrl));
        HttpWebResponse response = (HttpWebResponse)request.GetResponse();
        Stream s = response.GetResponseStream();
        byte[] bArr = new byte[1024 * 1024 * 50];
        int i = 0;
        for (; i < bArr.Length; i++)
        {
            int b = s.ReadByte();
            if (b == -1)
            {
                break;
            }
            else
            {
                bArr[i] = (byte)b;
            }
        }
        byte[] bArrNew = new byte[i];
        for (int j = 0; j < i; j++)
        {
            bArrNew[j] = bArr[j];
        }
        Response.BinaryWrite(bArrNew);
        s.Close();
        response.Close();
        request.Abort();
        //for(int i = 0; i < bArr.Length && (bArr[i] = s.Read(1)); i++)


    }
</script>