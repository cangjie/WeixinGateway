<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string token = "";
        string adminOpenId = WeixinUser.CheckToken(token.Trim());
        WeixinUser adminUser = new WeixinUser(adminOpenId);
        if (adminUser.IsAdmin)
        {
            Response.Write("{\"status\": 1, \"error_message\": \"Token is invalid.\"}");
            Response.End();
        }
        string customerOpenId = Util.GetSafeRequestValue(Request, "customer", "");
        string rfid = Util.GetSafeRequestValue(Request, "rfid", "");
        int edge = int.Parse(Util.GetSafeRequestValue(Request, "edge", "89"));
        int candle = int.Parse(Util.GetSafeRequestValue(Request, "candle", "0"));
        int fixBoard = int.Parse(Util.GetSafeRequestValue(Request, "fix", "0"));
        string memo = Util.GetSafeRequestValue(Request, "memo", "");
        DateTime finishDateTime = DateTime.Parse(Util.GetSafeRequestValue(Request, "finishDateTime", DateTime.Now.AddDays(1).ToShortDateString()));
        Ski ski = new Ski(rfid);
        int i = DBHelper.InsertData("skis_maintain_task", new string[,] { {"ski_id", "varchar", ski._filds["id"].ToString() },
            {"edge", "int", edge.ToString() }, {"candle", "int", candle.ToString() }, {"fix_board", "int", fixBoard.ToString() },
            {"customer_open_id", "varchar", customerOpenId.Trim() }, {"staff_accept_open_id", "varchar", adminOpenId.Trim() } });
        int maxId = 0;
        if (i == 1)
        {
            DataTable dt = DBHelper.GetDataTable(" select max(id) from skis_maintain_task  ");
            if (dt.Rows.Count == 1)
            {
                maxId = int.Parse(dt.Rows[0][0].ToString());
            }
            dt.Dispose();
        }
        Response.Write("{\"status\": 0, \"id\": " + maxId.ToString() + "}");

    }
</script>