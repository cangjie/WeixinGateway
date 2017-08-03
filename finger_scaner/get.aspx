<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string md5Key = "ABCDEF7768";
        string sn = Util.GetSafeRequestValue(Request, "sn", "Q11163910128");
        string requestTime = Util.GetSafeRequestValue(Request, "requesttime", "123456");
        string sign = Util.GetMd5(sn.Trim() + requestTime.Trim() + md5Key);
        if (!sign.Equals(Util.GetSafeRequestValue(Request, "sign", "")))
        {
            Response.End();
        }
        DataTable dt = DBHelper.GetDataTable(" select * from finger_scaner_command where sent = 0 and finger_scaner_id = '" + sn + "' ");
        string commandJsonStr = "";
        foreach (DataRow dr in dt.Rows)
        {
            if (commandJsonStr.Trim().Equals(""))
            {
                commandJsonStr = dr["command_text"].ToString();
            }
            else
            {
                commandJsonStr = commandJsonStr + "," + dr["command_text"].ToString();
            }
            DBHelper.UpdateData("finger_scaner_command",
                new string[,] { { "sent", "int", "1" }, { "sent_time", "datetime", DateTime.Now.ToString()} },
                new string[,] { { "id", "int", dr["id"].ToString() } }, Util.conStr);
        }
        dt.Dispose();
        Response.Write("{\"status\":1, \"info\":\"ok\",\"data\":[" + commandJsonStr + "]}");
    }
</script>