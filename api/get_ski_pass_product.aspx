<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        DateTime skiDate = DateTime.Parse(Util.GetSafeRequestValue(Request, "skidate", DateTime.Now.AddDays(1).ToShortDateString()));
        string resort = Util.GetSafeRequestValue(Request, "resort", "万龙");
        DataTable dt = DBHelper.GetDataTable(" select * from product_resort_ski_pass left join product on product.[id] = [product_resort_ski_pass].product_id  "
            + " where hidden = 0 and (stock_num > 0 or stock_num = -1) and shop = '" + resort.Trim() + "' ");

    }
</script>