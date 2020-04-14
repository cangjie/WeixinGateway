<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string cardNo = Util.GetSafeRequestValue(Request, "cardno", "");
        DataTable dt = DBHelper.GetDataTable("select * from covid19_service where card_no = '" + cardNo.Trim() + "'  ");
        string subJson = "";
        if (dt.Rows.Count > 0)
        {
            subJson = Util.ConvertDataFieldsToJson(dt.Rows[0]);
        }
        dt.Dispose();
        Response.Write("{\"status\": 0, \"covid19_service\":[" + subJson + "]}");
        
        //string json = Util.ConvertDataFieldsToJson()
    }
</script>