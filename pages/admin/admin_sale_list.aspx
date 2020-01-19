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

        DataTable dtAdmin = DBHelper.GetDataTable(" select * from users where is_admin = 1 ");

        DataTable dtOri = DBHelper.GetDataTable("select *, users.cell_number as user_number from order_online left join users on order_online.open_id = users.open_id left join order_online_temp on online_order_id = order_online.[id]  where order_online.type in ('店销', '服务') and order_online.pay_state = 1  and order_online.crt > '2019-10-1' order by order_online.[id] desc");

        DataTable dt = new DataTable();
        dt.Columns.Add("订单号", Type.GetType("System.Int32"));
        dt.Columns.Add("日期", Type.GetType("System.DateTime"));
        dt.Columns.Add("店铺");
        dt.Columns.Add("头像");
        dt.Columns.Add("昵称");
        //dt.Columns.Add("姓名");
        dt.Columns.Add("电话");
        dt.Columns.Add("零售总价", Type.GetType("System.Double"));
        dt.Columns.Add("实付金额", Type.GetType("System.Double"));
        dt.Columns.Add("支付方式", Type.GetType("System.String"));
        dt.Columns.Add("龙珠系数", Type.GetType("System.Double"));
        dt.Columns.Add("生成龙珠",  Type.GetType("System.Int32"));
        //dt.Columns.Add("商品概要");
        dt.Columns.Add("备注");
        dt.Columns.Add("销售");

        foreach (DataRow drOri in dtOri.Rows)
        {

            DataRow dr = dt.NewRow();
            dr["订单号"] = int.Parse(drOri["id"].ToString().Trim());



            dr["日期"] = DateTime.Parse(drOri["pay_time"].ToString());
            dr["店铺"] = drOri["shop"].ToString();
            WeixinUser user = new WeixinUser();
            user._fields = drOri;
            dr["头像"] = "<img src=\"" + user.HeadImage.Trim() + "\" width=\"30\" height=\"30\" />";
            //dr["姓名"] = drOri["name"].ToString().Trim();
            dr["昵称"] = user.Nick.Trim();
            dr["电话"] = drOri["user_number"].ToString().Trim();
            if (dr["电话"].ToString().Trim().Equals(""))
            {
                dr["电话"] = drOri["cell_number"].ToString().Trim();
            }
            dr["零售总价"] = Math.Round(double.Parse(drOri["order_price"].ToString()),2);
            dr["实付金额"] = Math.Round(double.Parse(drOri["order_real_pay_price"].ToString()),2);
            dr["龙珠系数"] = Math.Round(double.Parse(drOri["score_rate"].ToString()),2);
            dr["生成龙珠"] = Math.Round(double.Parse(drOri["generate_score"].ToString()),2);
            dr["支付方式"] = drOri["pay_method"].ToString().Trim();
            string detailStr = "";
            /*
            OnlineOrder order = new OnlineOrder(int.Parse(drOri["id"].ToString().Trim()));
            foreach (OnlineOrderDetail detail in OnlineOrderDetail.GetOnlineOrderDetails(int.Parse( drOri["id"].ToString().Trim())))
            {
                detailStr = detailStr + (detailStr.Trim().Equals("") ? "" : "<br/>") + detail.productName.Trim() + " 数量:" + detail.count.ToString()
                    + " 价格:" + Math.Round(detail.price, 2).ToString() + " 小计:" + Math.Round(detail.summary, 2).ToString();
            }
            */
            //dr["商品概要"] = detailStr.Trim();
            dr["备注"] = drOri["memo"].ToString().Trim();

            if (!drOri["admin_open_id"].ToString().Trim().Equals(""))
            {
                DataRow[] drArrAdmin = dtAdmin.Select(" open_id = '" + drOri["admin_open_id"].ToString().Trim() + "' ");
                if (drArrAdmin.Length > 0)
                {
                    dr["销售"] = drArrAdmin[0]["nick"].ToString().Trim();
                }
                else
                {
                    dr["销售"] = "";
                }
            }
            else
            {
                dr["销售"] = "";
            }

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
