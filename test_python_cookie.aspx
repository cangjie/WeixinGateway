<%@ Page Language="C#" %>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string cookie = "";
        try
        {
            cookie = Request.Headers["Cookie"].Trim();
        }
        catch
        {

        }
        Response.Write(cookie.Trim());
    }
</script>