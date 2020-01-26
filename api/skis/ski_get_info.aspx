<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        int id = int.Parse(Util.GetSafeRequestValue(Request, "id", "0"));
        string rfid = Util.GetSafeRequestValue(Request, "rfid", "aaa");
        Ski ski = new Ski();
        if (id == 0)
        {
            ski = new Ski(rfid);
        }
        else
        {
            ski = new Ski(id);
        }
        string jsonFields = Util.ConvertDataFieldsToJson(ski._filds);
        Response.Write("{\"status\": 0, \"ski\": " + jsonFields + "}");
    }
</script>