<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        int state = 0;
        SqlConnection conn = new SqlConnection(Util.conStr);
        SqlCommand cmd = new SqlCommand(" select top 1 * from orders where  order_product_id = '"
            + Request["product_id"].Trim().Replace("'", "") + "' order by order_out_trade_no desc ", conn);
        conn.Open();
        SqlDataReader dr = cmd.ExecuteReader();
        if (dr.Read())
        {
            state = int.Parse(dr["order_is_paid"].ToString().Trim());
        }
        dr.Close();
        conn.Close();
        cmd.Dispose();
        conn.Dispose();
        Response.Write("{ \"status\":0, \"product_id\":\"" + Request["product_id"].Trim()
            + "\", \"state\":\"" + ((state == 2) ? "PAID" : "UNPAID") + "\" }");
    }
</script>
