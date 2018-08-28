<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<!DOCTYPE html>

<script runat="server">

    public string keyWord = "";

    protected void btn_Click(object sender, EventArgs e)
    {
        keyWord = keyword.Text.Trim();
        dg.DataSource = GetHTMLData(keyWord.Trim());
        dg.DataBind();
    }


    public DataTable GetHTMLData(string keyWord)
    {
        DataTable dtList = DBHelper.GetDataTable("select * from b2cmonitor_taobao_shop_list where keyword = '" + keyWord.Trim().Replace("'","") + "' ");
        DataTable dtOri = GetData(keyWord);
        DataTable dt = dtOri.Clone();
        for (int i = 0; i < dtOri.Rows.Count && dt.Rows.Count < 500; i++)
        {
            if (dtList.Select("id = '" + dtOri.Rows[i]["店铺ID"].ToString().Trim() + "' ").Length == 0)
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
        }
        return dt;
    }


    public static DataTable GetData(string keyWord)
    {
        DataTable dt = new DataTable();
        dt.Columns.Add("店铺");
        dt.Columns.Add("店铺ID");
        dt.Columns.Add("店铺URL");
        dt.Columns.Add("商品");
        dt.Columns.Add("商品ID");
        dt.Columns.Add("商品URL");
        dt.Columns.Add("图片");
        dt.Columns.Add("价格");


        int pageSize = 0;
        int totalCount = 0;
        for (int i = 0; (i == 0 && pageSize == 0 && totalCount == 0) || (i < totalCount); i = i + pageSize)
        {
            try
            {
                string json = GetTaobaoSearchJson(keyWord, i);
                FillDataTable(json, dt);
                try
                {
                    pageSize = GetPageSize(json);
                }
                catch
                {

                }
                try
                {
                    totalCount = GetTotalCount(json);
                }
                catch
                {

                }
            }
            catch
            {

            }
        }
        return dt;
    }

    public static string GetTaobaoSearchJson(string keyWord, int index)
    {
        string ret = Util.GetWebContent("https://s.taobao.com/search?q=" + keyWord.Trim()+ (index>0? "&s=" + index.ToString():""));
        int startIndex = ret.IndexOf("{\"pageName\":\"mainsrp\"");
        ret = ret.Substring(startIndex, ret.Length - startIndex);
        int endIndex = ret.IndexOf("};");
        ret = ret.Substring(0, endIndex+1);
        return ret;
    }

    public static int GetTotalCount(string json)
    {
        int totalCount = 0;
        try
        {
            Dictionary<string, object> pagerObject = (Dictionary<string, object>)((Dictionary<string, object>)((Dictionary<string, object>)Util.GetObjectFromJsonByKey(json, "mods"))["pager"]);
            totalCount = int.Parse(((Dictionary<string, object>)(Dictionary<string, object>)pagerObject["data"])["totalCount"].ToString());
        }
        catch
        {
            try
            {
                Dictionary<string, object> modObject = (Dictionary<string, object>)((Dictionary<string, object>)((Dictionary<string, object>)Util.GetObjectFromJsonByKey(json, "mods"))["sortbar"]);
                Dictionary<string, object> dataObject = (Dictionary<string, object>)modObject["data"];
                Dictionary<string, object> pagerObject = (Dictionary<string, object>)dataObject["pager"];
                totalCount = int.Parse(pagerObject["totalCount"].ToString().Trim());
            }
            catch
            {

            }
        }
        return totalCount;
    }

    public static int GetPageSize(string json)
    {
        int pageSize = 0;
        try
        {
            Dictionary<string, object> pagerObject = (Dictionary<string, object>)((Dictionary<string, object>)((Dictionary<string, object>)Util.GetObjectFromJsonByKey(json, "mods"))["pager"]);
            pageSize = int.Parse(((Dictionary<string, object>)(Dictionary<string, object>)pagerObject["data"])["pageSize"].ToString());
        }
        catch
        {
            try
            {
                Dictionary<string, object> modObject = (Dictionary<string, object>)((Dictionary<string, object>)((Dictionary<string, object>)Util.GetObjectFromJsonByKey(json, "mods"))["sortbar"]);
                Dictionary<string, object> dataObject = (Dictionary<string, object>)modObject["data"];
                Dictionary<string, object> pagerObject = (Dictionary<string, object>)dataObject["pager"];
                pageSize = int.Parse(pagerObject["pageSize"].ToString().Trim());
            }
            catch
            {

            }
        }
        return pageSize;
    }

    public static void FillDataTable(string json, DataTable dt)
    {
        Dictionary<string, object> dataObject = (Dictionary<string, object>)((Dictionary<string, object>)((Dictionary<string, object>)Util.GetObjectFromJsonByKey(json, "mods"))["itemlist"])["data"];
        object[] auctionObjectArray = (object[])dataObject["auctions"];
        foreach (object auctionObject in auctionObjectArray)
        {
            Dictionary<string, object> auction = (Dictionary<string, object>)auctionObject;
            string productId = auction["nid"].ToString().Trim();
            if (dt.Select(" 商品ID = '" + productId.Trim() + "' ").Length == 0)
            {
                DataRow dr = dt.NewRow();
                dr["商品ID"] = productId.Trim();
                dr["店铺"] = auction["nick"].ToString().Trim();
                dr["店铺ID"] = auction["user_id"].ToString().Trim();
                dr["商品"] = auction["title"].ToString().Trim();
                dr["图片"] = auction["pic_url"].ToString().Trim();
                dr["商品URL"] = auction["detail_url"].ToString().Trim();
                dr["价格"] = auction["view_price"].ToString().Trim();
                dt.Rows.Add(dr);
            }
            //DataRow dr = dt.NewRow();

        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (!keyWord.Trim().Equals(""))
            {
                dg.DataSource = GetHTMLData(keyWord.Trim());
                dg.DataBind();
            }
        }
    }

    protected void dg_DeleteCommand(object source, DataGridCommandEventArgs e)
    {
        keyWord = keyword.Text.Trim();
        string shopId = dg.DataKeys[e.Item.ItemIndex].ToString();
        AddShopToList(shopId, keyword.Text.Trim(), "black");
        dg.DataSource = GetHTMLData(keyWord.Trim());
        dg.SelectedIndex = -1;
        dg.DataBind();
    }

    protected void dg_SelectedIndexChanged(object sender, EventArgs e)
    {
        keyWord = keyword.Text.Trim();
        string shopId = dg.DataKeys[dg.SelectedIndex].ToString();
        AddShopToList(shopId, keyword.Text.Trim(), "white");
        dg.DataSource = GetHTMLData(keyWord.Trim());
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
    <div>
        <div style="text-align: left"><asp:TextBox ID="keyword" runat="server" Width="294px" /> &nbsp; <asp:Button ID="btn" text="Search" runat="server" OnClick="btn_Click" /></div>
        <div><br /></div>
        <div><asp:DataGrid runat="server" ID="dg" AutoGenerateColumns="False" BackColor="White" BorderColor="#999999" BorderStyle="None" BorderWidth="1px" CellPadding="3" GridLines="Vertical" style="text-align: left" Width="100%" Font-Size="Small" OnDeleteCommand="dg_DeleteCommand" OnSelectedIndexChanged="dg_SelectedIndexChanged" DataKeyField="店铺ID"  >
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
            </asp:DataGrid></div>
    </div>
    </form>
</body>
</html>
