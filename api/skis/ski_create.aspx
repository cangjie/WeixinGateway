<%@ Page Language="C#" %>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string token = Util.GetSafeRequestValue(Request, "token", "");
        string adminOpenId = WeixinUser.CheckToken(token);
        WeixinUser adminUser = new WeixinUser(adminOpenId);
        if (!adminUser.IsAdmin)
        {
            Response.Write("{\"status\": 1, \"error_message\": \"Token is invalid.\"}");
        }
        string rfid = Util.GetSafeRequestValue(Request, "rfid", DateTime.Now.Year.ToString().Substring(2, 2)
            + DateTime.Now.Month.ToString().PadLeft(2, '0') + DateTime.Now.Day.ToString().PadLeft(2, '0')
            + DateTime.Now.Hour.ToString().PadLeft(2, '0') + DateTime.Now.Minute.ToString().PadLeft(2, '0')
            + DateTime.Now.Second.ToString().PadLeft(2, '0'));
        bool duplicateRfid = false;
        try
        {
            Ski ski = new Ski(rfid);
            if (ski._filds != null)
            {
                duplicateRfid = true;
            }
        }
        catch
        {

        }

        if (duplicateRfid)
        {
            Response.Write("{\"status\": 1, \"error_message\": \"Duplicate rfid.\" }");
            Response.End();
        }
        string rfidType = Util.GetSafeRequestValue(Request, "rfid_type", "timestamp");
        string skiType = Util.GetSafeRequestValue(Request, "ski_type", "双板");
        string brand = Util.GetSafeRequestValue(Request, "brand", "");
        string serialName = Util.GetSafeRequestValue(Request, "serial_name", "");
        string madeOfYear = Util.GetSafeRequestValue(Request, "year_of_made", "");
        string length = Util.GetSafeRequestValue(Request, "length", "");
        int skiId = Ski.CreateNewSki(rfid, rfidType.Trim(), skiType.Trim(), brand, serialName.Trim(), madeOfYear.Trim(), length.Trim());
        if (skiId > 0)
        {
            Response.Write("{\"status\": 0, \"ski_id\": " + skiId.ToString() + "}");
        }
        else
        {
            Response.Write("{\"status\": 1, \"error_message\": \"Create failed.\" }");
        }
    }
</script>