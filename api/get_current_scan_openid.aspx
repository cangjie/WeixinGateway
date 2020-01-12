<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string eventKey = Util.GetSafeRequestValue(Request, "eventkey", "shop_sale_charge_request_openid_oZBHkjoXAYNrx5wKCWRCD5qSGrPM");
        DataTable dt = DBHelper.GetDataTable(" select top 1 * from wxreceivemsg where wxreceivemsg_event in ('SCAN', 'subscribe') and wxreceivemsg_eventkey = '"
            + eventKey.Trim() + "' and wxreceivemsg_deal = 0 order by wxreceivemsg_crt desc ");
        if (dt.Rows.Count > 0)
        {
            DateTime scanTime = DateTime.Parse(dt.Rows[0]["wxreceivemsg_crt"].ToString().Trim());
            if (DateTime.Now - scanTime < new TimeSpan(0, 2, 0))
            {
                Response.Write(dt.Rows[0]["wxreceivemsg_from"].ToString().Trim());
            }
            DBHelper.UpdateData("wxreceivemsg", new string[,] { { "wxreceivemsg_deal", "int", "1" } },
                new string[,] { { "wxreceivemsg_id", "varchar", dt.Rows[0][0].ToString().Trim() } }, Util.conStr.Trim());
        }
        
        dt.Dispose();
    }
</script>