<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            dg.DataSource = GetData();
            dg.DataBind();
        }
    }

    public DataTable GetData()
    {
        DataTable dtOri = DBHelper.GetDataTable("select * from order_online where type = '店销' and pay_state = 1 order by [id] desc");

        DataTable dt = new DataTable();
        dt.Columns.Add("订单号", Type.GetType("System.Int32"));
        dt.Columns.Add("日期", Type.GetType("System.DateTime"));
        dt.Columns.Add("店铺");
        dt.Columns.Add("头像");
        dt.Columns.Add("昵称");
        dt.Columns.Add("电话");
        dt.Columns.Add("零售总价", Type.GetType("System.Double"));
        dt.Columns.Add("实付金额", Type.GetType("System.Double"));
        dt.Columns.Add("龙珠系数", Type.GetType("System.Double"));
        dt.Columns.Add("生成龙珠",  Type.GetType("System.Int32"));
        dt.Columns.Add("商品概要");
        dt.Columns.Add("备注");

        foreach (DataRow drOri in dtOri.Rows)
        {
            DataRow dr = dt.NewRow();
            dr["订单号"] = int.Parse(drOri["id"].ToString().Trim());
            dr["日期"] = DateTime.Parse(drOri["pay_time"].ToString());
            dr["店铺"] = drOri["shop"].ToString();
            WeixinUser user = new WeixinUser(drOri["open_id"].ToString().Trim());
            dr["头像"] = "<img src=\"" + user.HeadImage.Trim() + "\" width=\"30\" height=\"30\" />";
            dr["昵称"] = user.Nick.Trim();
            dr["电话"] = user.CellNumber.Trim();
            dr["零售总价"] = Math.Round(double.Parse(drOri["order_price"].ToString()),2);
            dr["实付金额"] = Math.Round(double.Parse(drOri["order_real_pay_price"].ToString()),2);
            dr["龙珠系数"] = Math.Round(double.Parse(drOri["score_rate"].ToString()),2);
            dr["生成龙珠"] = Math.Round(double.Parse(drOri["generate_score"].ToString()),2);
            string detailStr = "";
            OnlineOrder order = new OnlineOrder(int.Parse(drOri["id"].ToString().Trim()));
            foreach (OnlineOrderDetail detail in order.OrderDetails)
            {
                detailStr = detailStr + (detailStr.Trim().Equals("") ? "" : "<br/>") + detail.productName.Trim() + " 数量:" + detail.count.ToString()
                    + " 价格:" + Math.Round(detail.price, 2).ToString() + " 小计:" + Math.Round(detail.summary, 2).ToString();
            }
            dr["商品概要"] = detailStr.Trim();
            dr["备注"] = drOri["memo"].ToString().Trim();
            dt.Rows.Add(dr);
        }

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
        <asp:DataGrid runat="server" ID="dg" BackColor="White" BorderColor="#999999" BorderStyle="None" BorderWidth="1px" CellPadding="3" GridLines="Vertical" Width="100%" >
            <AlternatingItemStyle BackColor="#DCDCDC" />
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
