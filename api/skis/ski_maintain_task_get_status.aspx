<%@ Page Language="C#" %>


<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        int taskId = int.Parse(Util.GetSafeRequestValue(Request, "id", "45"));
        SkiMaintainTask task = new SkiMaintainTask(taskId);
        Response.Write("{\"status\": 0, \"task_id\": " + taskId.ToString() + ", \"paid\": " + (task.Paid ? "1" : "0")
            + ", \"card_used\": " + (task.CardUsed ? "1" : "0") + " }");
    }
</script>