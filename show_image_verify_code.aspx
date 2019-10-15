<%@ Page Language="C#" %>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        System.IO.MemoryStream ms= BitmapImage.ImageCheck();
        Response.ClearContent();
        Response.ContentType = "image/Gif";
        Response.BinaryWrite(ms.ToArray());
    }
</script>