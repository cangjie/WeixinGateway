<%@ Page Language="C#" %>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string number = Util.GetSafeRequestValue(Request, "number", "13501177897");
        Response.Write("{\"status\": 0, \"points\": " + Point.GetOldPoints(number).ToString() + " }");
    }
</script>
