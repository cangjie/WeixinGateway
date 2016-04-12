<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["cms_login"] == null || !Session["cms_login"].ToString().Equals("1"))
        {
            Response.Redirect("admin_login.aspx", true);
        }

        if (!IsPostBack)
        {
            dg.DataSource = GetData();
            dg.DataBind();
        }
        
    }

    public DataTable GetData()
    {
        Article[] articleArray = Article.GetList();
        DataTable dt = new DataTable();
        dt.Columns.Add("id");
        dt.Columns.Add("title");
        dt.Columns.Add("create_date");
        foreach (Article article in articleArray)
        {
            DataRow dr = dt.NewRow();
            dr["id"] = article.ID;
            dr["title"] = article.Title.Trim();
            dr["create_date"] = article.CreateDate;
            dt.Rows.Add(dr);
        }
        return dt;
    }
    
 
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        .auto-style1 {
            width: 100%;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
        <table class="auto-style1">
            <tr>
                <td>
                    <asp:Button ID="Button1" runat="server" Text="添加文章" />
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td><asp:DataGrid ID="dg" Width="100%" runat="server" BackColor="White" BorderColor="#999999" BorderStyle="None" BorderWidth="1px" CellPadding="3" Font-Size="Small" GridLines="Vertical" AutoGenerateColumns="False" >
                    <AlternatingItemStyle BackColor="#DCDCDC" />
                    <Columns>
                        <asp:ButtonColumn CommandName="Delete" Text="Delete"></asp:ButtonColumn>
                        <asp:BoundColumn DataField="id" DataFormatString="&lt;a href=&quot;admin_content_edit.aspx?id={0}&quot; &gt;{0}&lt;/a&gt;" HeaderText="ID"></asp:BoundColumn>
                        <asp:BoundColumn DataField="title" HeaderText="标题"></asp:BoundColumn>
                        <asp:BoundColumn DataField="create_date" HeaderText="添加时间"></asp:BoundColumn>
                    </Columns>
                    <FooterStyle BackColor="#CCCCCC" ForeColor="Black" />
                    <HeaderStyle BackColor="#000084" Font-Bold="True" ForeColor="White" />
                    <ItemStyle BackColor="#EEEEEE" ForeColor="Black" />
                    <PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" Mode="NumericPages" />
                    <SelectedItemStyle BackColor="#008A8C" Font-Bold="True" ForeColor="White" />
                    </asp:DataGrid></td>
            </tr>
            <tr>
                <td>&nbsp;</td>
            </tr>
        </table>
    
    </div>
    </form>
</body>
</html>
