<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<script runat="server">

    public int orderId = 0;

    protected void Page_Load(object sender, EventArgs e)
    {
        orderId = int.Parse(Util.GetSafeRequestValue(Request, "orderid", "0"));
        if (orderId == 0)
        {
            int tempOrderId = int.Parse(Util.GetSafeRequestValue(Request, "temporderid", "0"));
            OrderTemp orderTemp = new OrderTemp(tempOrderId);
            orderId = int.Parse(orderTemp._fields["online_order_id"].ToString());
        }
        OnlineOrder order = new OnlineOrder(orderId);
        string json = "";
        foreach(DataColumn c in order._fields.Table.Columns)
        {
            json = json + ((!json.Trim().Equals("")) ? ", " : "") + " \"" + c.Caption.Trim() + "\" :\"" + order._fields[c].ToString() + "\"";
        }
        Response.Write("{\"status\": 0, " + json.Trim() + " }");
    }
</script>