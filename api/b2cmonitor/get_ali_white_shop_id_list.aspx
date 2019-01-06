<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        DataTable dt = DBHelper.GetDataTable(" select [id] from b2cmonitor_taobao_shop_list where [type] = 'white'  ");
        string jsonStr = "{\"shop_id\": [";
        foreach (DataRow dr in dt.Rows)
        {
            jsonStr = jsonStr + " \"" + dr["id"].ToString().Trim() + "\",";
        }
        jsonStr = jsonStr.Remove(jsonStr.Length - 1, 1);
        jsonStr = jsonStr + "]}";
        Response.Write(jsonStr.Trim());
    }
</script>