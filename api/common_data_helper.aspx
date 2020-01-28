<%@ Page Language="C#" %>
<%@ Import Namespace="System.IO" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string token = Util.GetSafeRequestValue(Request, "token", "");
        string dataTable = Util.GetSafeRequestValue(Request, "table", "");
        string action = Util.GetSafeRequestValue(Request, "action", "");
        Stream s = Request.InputStream;
        StreamReader sr = new StreamReader(s);
        string json = sr.ReadToEnd();
        sr.Close();
        s.Close();

        Response.Write(json.Trim());
    }
</script>