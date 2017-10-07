<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<script runat="server">

    public int tempOrderId = 0;

    protected void Page_Load(object sender, EventArgs e)
    {
        tempOrderId = int.Parse(Util.GetSafeRequestValue(Request, "temporderid", "66"));
        OrderTemp tempOrder = new OrderTemp(tempOrderId);
        string json = "";
        foreach(DataColumn c in tempOrder._fields.Table.Columns)
        {
            json = json + ((!json.Trim().Equals("")) ? ", " : "") +  " \"" + c.Caption.Trim() + "\" :" 
                + (!tempOrder._fields[c].ToString().Trim().StartsWith("{")? " \"" : " ") +  tempOrder._fields[c].ToString() 
                + (!tempOrder._fields[c].ToString().Trim().EndsWith("}")? "\" " : " ") ;
        }
        Response.Write("{\"status\": 0, " + json.Trim() + " }");
    }
</script>