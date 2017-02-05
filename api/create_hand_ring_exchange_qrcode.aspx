<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string token = Util.GetSafeRequestValue(Request, "token", "01127366f2f219f3578b75fbd32a3bb2f200ac7fcf3051fa5bf5515f0321f86e43592f6e");
        string ringCode = Util.GetSafeRequestValue(Request, "ringcode", "");

        string adminUserOpenId = WeixinUser.CheckToken(token);
        WeixinUser adminUser = new WeixinUser(adminUserOpenId);
        if (adminUser.IsAdmin)
        {
            string[,] insertParam = { { "code", "varchar", ringCode.Trim() }, {"admin_open_id", "varchar", adminUserOpenId.Trim() } };
            DBHelper.InsertData("hand_ring_use", insertParam);
            int maxId = DBHelper.GetMaxId("hand_ring_use");
            Response.Write("{\"status\":0, \"exchange_id\":\"4293" + maxId.ToString().PadLeft(6,'0') + "\" }");
        }

    }
</script>