<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.IO" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string token = Util.GetSafeRequestValue(Request, "token", "");
        string adminOpenId = WeixinUser.CheckToken(token.Trim());
        WeixinUser adminUser = new WeixinUser(adminOpenId);
        if (!adminUser.IsAdmin)
        {
            Response.Write("{\"status\": 1, \"error_message\": \"Token is invalid.\"}");
            Response.End();
        }

        string customerOpenId = Util.GetSafeRequestValue(Request, "customer", "");
        string skiId = Util.GetSafeRequestValue(Request, "ski_id", "0");
        int edge = int.Parse(Util.GetSafeRequestValue(Request, "edge", "89"));
        int candle = int.Parse(Util.GetSafeRequestValue(Request, "candle", "0"));
        int fixBoard = int.Parse(Util.GetSafeRequestValue(Request, "fix", "0"));
        string memo = Util.GetSafeRequestValue(Request, "memo", "");
        DateTime finishDateTime = DateTime.Parse(Util.GetSafeRequestValue(Request,
            "finis_date", DateTime.Now.AddDays(1).ToShortDateString()));
        string cardNo = Util.GetSafeRequestValue(Request, "card_no", "");
        string payMethod = Util.GetSafeRequestValue(Request, "pay_method", "");
        int amount = int.Parse(Util.GetSafeRequestValue(Request, "amount", "0"));
        int deltaAmount = int.Parse(Util.GetSafeRequestValue(Request, "delta", "0"));
        string postJson = new StreamReader(Request.InputStream).ReadToEnd();
        int taskId = SkiMaintainTask.CreateNewTask(customerOpenId, adminOpenId, int.Parse(skiId), edge,
            (candle == 0 ? false : true), fixBoard == 0 ? false : true, memo.Trim(), finishDateTime, 
            cardNo.Trim(), postJson.Trim(), amount, deltaAmount);
        
        
        if (taskId > 0)
        {
            SkiMaintainTask skiMaintainTask = new SkiMaintainTask(taskId);
            int orderId = skiMaintainTask.PlaceOrder(amount, memo);
            if (orderId > 0 || !cardNo.Trim().Equals(""))
            {
                Response.Write("{\"status\": 0, \"task_id\": " + taskId.ToString() + ", \"order_id\": " + orderId.ToString() + "}");
            }
            else
            {
                Response.Write("{\"status\": 1, \"error_message\": \"Can't create order.\"}");
            }
        }
        else
        {
            Response.Write("{\"status\": 1, \"error_message\": \"Can't create task.\"}");
        }
        


    }
</script>