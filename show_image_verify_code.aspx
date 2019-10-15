<%@ Page Language="C#" %>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        Random random = new Random();
        string checkCode = random.Next(1000, 9999).ToString();
        Session["check_code"] = checkCode.Trim();
        System.IO.MemoryStream ms= BitmapImage.ImageCheck(checkCode);
        Response.ClearContent();
        Response.ContentType = "image/Gif";
        Response.BinaryWrite(ms.ToArray());
    }
</script>