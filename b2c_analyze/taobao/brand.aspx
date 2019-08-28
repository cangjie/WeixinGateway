<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="Core" %>
<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //dg.DataSource = GetHtmlData(Core.Brand.GetBrandTable());
            //dg.DataBind();
        }
    }

    public DataTable GetHtmlData(DataTable dtOri)
    {
        DataTable dt = dtOri.Clone();
        foreach (DataRow drOri in dtOri.Rows)
        {
            DataRow dr = dt.NewRow();
            foreach (DataColumn dc in dt.Columns)
            {
                dr[dc] = drOri[dc.Caption.Trim()];
            }
            string tmp = dr["alias"].ToString().Trim();
            string linkStr = "";
            foreach (string s in tmp.Split(','))
            {
                if (!s.Trim().Equals(""))
                {
                    linkStr = linkStr.Trim() + "<a href=\"show_brand_keyword_product_list.aspx?brand=" + Server.UrlEncode(dr["brand_name"].ToString().Trim())
                        + "&keyword=" + Server.UrlEncode(s.Trim()) + "\" target=\"_blank\" >" + s.Trim() + "</a> , ";
                }
            }
            if (linkStr.Trim().EndsWith(","))
            {
                linkStr = linkStr.Trim().Remove(linkStr.Trim().Length - 1, 1);
            }
            dr["alias"] = linkStr.Trim();
            dt.Rows.Add(dr);
        }
        return dt;
    }



    protected void btnAdd_Click(object sender, EventArgs e)
    {
        if (!txtBrandName.Text.Trim().Equals(""))
        {
            Core.Brand.AddNew(txtBrandName.Text.Trim());
            dg.DataSource = GetHtmlData(Core.Brand.GetBrandTable());
            dg.EditItemIndex = -1;
            dg.DataBind();
        }
    }

    protected void dg_EditCommand(object source, DataGridCommandEventArgs e)
    {
        dg.DataSource = Core.Brand.GetBrandTable();
        dg.EditItemIndex = e.Item.ItemIndex;
        dg.DataBind();
    }

    protected void dg_UpdateCommand(object source, DataGridCommandEventArgs e)
    {
        string newAlias = ((TextBox)dg.Items[e.Item.ItemIndex].Cells[2].Controls[1]).Text.Trim();
        string key = dg.DataKeys[e.Item.ItemIndex].ToString().Trim();
        Core.Brand.UpdateAlias(key, newAlias);
        dg.DataSource = GetHtmlData(Core.Brand.GetBrandTable());
        dg.EditItemIndex = -1;
        dg.DataBind();
    }

    protected void dg_CancelCommand(object source, DataGridCommandEventArgs e)
    {
        dg.DataSource = GetHtmlData(Core.Brand.GetBrandTable());
        dg.EditItemIndex = -1;
        dg.DataBind();
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:TextBox ID="txtBrandName" runat="server" Width="270px" ></asp:TextBox>
    &nbsp;<asp:Button ID="btnAdd" Text="新增品牌 无法删除" runat="server" OnClick="btnAdd_Click" />
    </div>
        <br />
    <div>
        <asp:DataGrid ID="dg" runat="server" Width="100%" AutoGenerateColumns="False" BackColor="White" BorderColor="#999999" BorderStyle="None" BorderWidth="1px" CellPadding="3" GridLines="Vertical" OnEditCommand="dg_EditCommand" OnUpdateCommand="dg_UpdateCommand" OnCancelCommand="dg_CancelCommand" DataKeyField="brand_name" >
            <AlternatingItemStyle BackColor="#DCDCDC" />
            <Columns>
                <asp:EditCommandColumn CancelText="取消" EditText="编辑" UpdateText="更新"></asp:EditCommandColumn>
                <asp:TemplateColumn HeaderText="品牌">
                    <ItemTemplate>
                        <asp:Label runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.brand_name") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="关键词(用逗号分隔)">
                    <EditItemTemplate>
                        <asp:TextBox runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.alias") %>' Width="100%"></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.alias") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateColumn>
            </Columns>
            <FooterStyle BackColor="#CCCCCC" ForeColor="Black" />
            <HeaderStyle BackColor="#000084" Font-Bold="True" ForeColor="White" />
            <ItemStyle BackColor="#EEEEEE" ForeColor="Black" />
            <PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" Mode="NumericPages" />
            <SelectedItemStyle BackColor="#008A8C" Font-Bold="True" ForeColor="White" />
        </asp:DataGrid>
    </div>
    </form>
</body>
</html>
