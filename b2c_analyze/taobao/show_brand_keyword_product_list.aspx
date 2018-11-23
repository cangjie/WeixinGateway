<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<!DOCTYPE html>

<script runat="server">

    public string brand = "";
    public string keyword = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        brand = Util.GetSafeRequestValue(Request, "brand", "giro").Trim();
        keyword = Util.GetSafeRequestValue(Request, "keyword", "头盔");
        if (!IsPostBack)
        {
            TaobaoKeyword taobaoKeyword = TaobaoKeyword.GetTaobaoKeywordResult(brand, keyword);
            dg.DataSource = GetHtmlData(taobaoKeyword.NewShopResultTable);
            dg.DataBind();
        }
    }

    public DataTable GetHtmlData(DataTable dtOri)
    {
        DataTable dt = dtOri.Clone();
        for (int i = 0; i < dtOri.Rows.Count && dt.Rows.Count < 500; i++)
        {

            DataRow dr = dt.NewRow();
            dr["店铺"] = dtOri.Rows[i]["店铺"];
            dr["店铺ID"] = dtOri.Rows[i]["店铺ID"];
            dr["店铺URL"] = "";
            dr["商品"] = "<a href=\""
                + (dtOri.Rows[i]["商品URL"].ToString().Trim().StartsWith("http:") ? dtOri.Rows[i]["商品URL"].ToString().Trim() : "http://" + dtOri.Rows[i]["商品URL"].ToString().Trim())
                + "\"  target=\"_blank\" >" + dtOri.Rows[i]["商品"].ToString() + "</a>";
            dr["图片"] = "<img width=\"50\" height=\"50\" src=\""
                + (dtOri.Rows[i]["图片"].ToString().Trim().StartsWith("http:") ? dtOri.Rows[i]["图片"].ToString().Trim() : "http:" + dtOri.Rows[i]["图片"].ToString().Trim())
                + "\" />";
            dr["价格"] = dtOri.Rows[i]["价格"];
            dt.Rows.Add(dr);

        }
        return dt;
    }

    protected void dg_SelectedIndexChanged(object sender, EventArgs e)
    {
        //string keyWord = keyword.Text.Trim();
        string shopId = dg.DataKeys[dg.SelectedIndex].ToString();
        AddShopToList(shopId, brand.Trim(), "white");
        TaobaoKeyword taobaoKeyword = TaobaoKeyword.GetTaobaoKeywordResult(brand, keyword);
        dg.DataSource = GetHtmlData(taobaoKeyword.NewShopResultTable);
        dg.SelectedIndex = -1;
        dg.DataBind();
    }

    protected void dg_DeleteCommand(object source, DataGridCommandEventArgs e)
    {
        string shopId = dg.DataKeys[e.Item.ItemIndex].ToString();
        AddShopToList(shopId, brand.Trim(), "black");
        TaobaoKeyword taobaoKeyword = TaobaoKeyword.GetTaobaoKeywordResult(brand, keyword);
        dg.DataSource = GetHtmlData(taobaoKeyword.NewShopResultTable);
        dg.SelectedIndex = -1;
        dg.DataBind();
    }

    public static void AddShopToList(string shopId, string keyWord, string type)
    {
        try
        {
            DBHelper.InsertData("b2cmonitor_taobao_shop_list",
                new string[,] {
                { "id", "varchar", shopId.Trim()},
                { "type", "varchar", type.Trim()},
                { "keyword", "varchar", keyWord.Trim()},

                });
        }
        catch
        {

        }
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>品牌：<%=brand.Trim() %> 关键词：<%=keyword.Trim() %></div>
    <div>
        <asp:DataGrid runat="server" ID="dg" AutoGenerateColumns="False" BackColor="White" BorderColor="#999999" BorderStyle="None" BorderWidth="1px" CellPadding="3" GridLines="Vertical" style="text-align: left" Width="100%" Font-Size="Small" OnDeleteCommand="dg_DeleteCommand" OnSelectedIndexChanged="dg_SelectedIndexChanged" DataKeyField="店铺ID"  >
            <AlternatingItemStyle BackColor="#DCDCDC" />
            <Columns>
                <asp:ButtonColumn CommandName="Select" Text="白名单"></asp:ButtonColumn>
                <asp:ButtonColumn CommandName="Delete" Text="黑名单"></asp:ButtonColumn>
                <asp:BoundColumn DataField="店铺" HeaderText="店铺"></asp:BoundColumn>
                <asp:BoundColumn DataField="店铺ID" HeaderText="店铺ID" Visible="false" ></asp:BoundColumn>
                <asp:BoundColumn DataField="商品" HeaderText="商品"></asp:BoundColumn>
                <asp:BoundColumn DataField="图片" HeaderText="图片"></asp:BoundColumn>
                <asp:BoundColumn DataField="价格" HeaderText="价格"></asp:BoundColumn>
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
