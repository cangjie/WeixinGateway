<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string token = Util.GetSafeRequestValue(Request, "token", "");
        string adminOpenId = WeixinUser.CheckToken(token);
        WeixinUser adminUser = new WeixinUser(adminOpenId);
        if (adminUser.IsAdmin)
        {
            string itemName = Util.GetSafeRequestValue(Request, "item_name", "");
            string itemContent = Util.GetSafeRequestValue(Request, "item_content", "");
            string securityType = Util.GetSafeRequestValue(Request, "security_type", "");
            string securityContent = Util.GetSafeRequestValue(Request, "security_content", "");
            string scheduleReturnDateTimeString = Util.GetSafeRequestValue(Request, "return_date", "");
            DateTime scheduleReturnDateTime = DateTime.Parse(scheduleReturnDateTimeString.Substring(0,4) + "-" 
                + scheduleReturnDateTimeString.Substring(4,2) + "-" + scheduleReturnDateTimeString.Substring(6, 2) 
                + " " + scheduleReturnDateTimeString.Substring(8, 2) + ":00");
            int id = RentItem.NewRent(itemName.Trim(), itemContent.Trim(), securityType.Trim(), securityContent.Trim(), adminOpenId, scheduleReturnDateTime);
            Response.Write("{\"status\": 0, \"id\": " + id.ToString() + "}");
        }
        else
        {
            Response.Write("{\"status\": 1, \"error_message\": \"Is not admin.\"}");
        }
    }
</script>