<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        SalesFlowSheet sfs = new SalesFlowSheet(Server.MapPath("template.xlsx"));
        Response.Write(sfs.LastRowIndex);
    }
</script>
