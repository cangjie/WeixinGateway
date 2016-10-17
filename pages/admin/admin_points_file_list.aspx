<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["is-log-in"] == null || !Session["is-log-in"].ToString().Equals("1"))
        {
            //Response.Redirect("admin_login.aspx", true);
        }
        if (!IsPostBack)
        {
            dg.DataSource = GetData();
            dg.DataBind();
        }
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        Response.Redirect("admin_points_file_upload.aspx", true);
    }

    public DataTable GetData()
    {
        DataTable dt = new DataTable();
        dt.Columns.Add("日期");
        dt.Columns.Add("条数");
        dt.Columns.Add("总积分");
        dt.Columns.Add("备注");

        DataTable dtOri = DBHelper.GetDataTable(" select * from point_uploaded_file order by [id] desc ");

        foreach (DataRow drOri in dtOri.Rows)
        {
            DataRow dr = dt.NewRow();
            dr["日期"] = DateTime.Parse(drOri["upload_time"].ToString()).ToString();
            PointFile pointFile = new PointFile(int.Parse(drOri["id"].ToString()));
            dr["条数"] = pointFile.pointDataTable.Rows.Count.ToString();
            dr["总积分"] = pointFile.totalPoints.ToString();
            dr["备注"] = pointFile._fields["memo"].ToString().Trim();
            dt.Rows.Add(dr);
        }
        return dt;
        
        return dt;
    }
    
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <div>

            <asp:Button ID="Button1" runat="server" Text="上  传" OnClick="Button1_Click" />

        </div>
        <hr />
        <div>
        <asp:DataGrid runat="server" Width="100%" ID="dg" BackColor="White" BorderColor="#999999" BorderStyle="None" BorderWidth="1px" CellPadding="3" Font-Size="Small" GridLines="Vertical" >
            <AlternatingItemStyle BackColor="#DCDCDC" />
            <FooterStyle BackColor="#CCCCCC" ForeColor="Black" />
            <HeaderStyle BackColor="#000084" Font-Bold="True" ForeColor="White" />
            <ItemStyle BackColor="#EEEEEE" ForeColor="Black" />
            <PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" Mode="NumericPages" />
            <SelectedItemStyle BackColor="#008A8C" Font-Bold="True" ForeColor="White" />
            </asp:DataGrid>
            </div>
    </div>
    </form>
</body>
</html>
