<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<!DOCTYPE html>

<script runat="server">

    public DateTime startDate = DateTime.Now.Date;

    public DateTime endDate = DateTime.Now.Date;

    public DateTime mondayDate = DateTime.Now.Date;

    public string shop = "全部";

    public string type = "全部";



    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            try
            {
                startDate = DateTime.Parse(Util.GetSafeRequestValue(Request, "start_date", DateTime.Now.ToShortDateString()));
                endDate = DateTime.Parse(Util.GetSafeRequestValue(Request, "end_date", DateTime.Now.ToShortDateString()));
                shop = Util.GetSafeRequestValue(Request, "shop", "全部");
                type = Util.GetSafeRequestValue(Request, "type", "全部");
            }
            catch
            {

            }


            switch (DateTime.Now.DayOfWeek)
            {
                case DayOfWeek.Sunday:
                    mondayDate = DateTime.Now.Date.AddDays(-6);
                    break;
                case DayOfWeek.Tuesday:
                    mondayDate =  DateTime.Now.Date.AddDays(-1);
                    break;
                case DayOfWeek.Wednesday:
                    mondayDate = DateTime.Now.Date.AddDays(-2);
                    break;
                case DayOfWeek.Thursday:
                    mondayDate = DateTime.Now.Date.AddDays(-3);
                    break;
                case DayOfWeek.Friday:
                    mondayDate = DateTime.Now.Date.AddDays(-4);
                    break;
                case DayOfWeek.Saturday:
                    mondayDate = DateTime.Now.Date.AddDays(-5);
                    break;
                default:
                    break;
            }
            dg.DataSource = GetData();
            dg.DataBind();
        }
    }

    public DataTable GetData()
    {

        DataTable dtAdmin = DBHelper.GetDataTable(" select open_id, nick from users where is_admin = 1 union select open_id, nick from mini_users where is_admin = 1 ");

        DataTable dtOri = DBHelper.GetDataTable("select distinct ( case   when maintain_in_shop_request.confirmed_cell is null then order_online.cell_number   when maintain_in_shop_request.confirmed_cell = '' then order_online.cell_number else confirmed_cell end )   as user_number, "
            + " users.*, order_online.*, "
            + " order_online_temp.*, maintain_in_shop_request.service_open_id  from order_online left join users on order_online.open_id = users.open_id left join order_online_temp on online_order_id = order_online.[id] "
            + " left join maintain_in_shop_request on order_online.[id] = maintain_in_shop_request.order_id "
            + " where order_online.type in ('店销', '服务') and order_online.pay_state = 1  "
            + (shop.Equals("全部")? " " : " and order_online.shop = '" + shop + "' ")
            + " and pay_time >= '" + startDate.ToShortDateString() + "' and pay_time < '" + endDate.AddDays(1) + "' "
            + (type.Equals("全部")? " " : " and order_online.[type] = '" + type.Trim() + "'  ")
            + " order by order_online.[id]  desc");

        DataTable dt = new DataTable();
        dt.Columns.Add("订单号", Type.GetType("System.Int32"));
        dt.Columns.Add("日期");
        dt.Columns.Add("店铺");
        dt.Columns.Add("类型");
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
        double totalSale = 0;
        double totalCharge = 0;
        double totalScore = 0;
        foreach (DataRow drOri in dtOri.Rows)
        {
            DataRow dr = dt.NewRow();
            if (drOri["id"].ToString().Trim().Equals("10787"))
            {
                string aa = "aa";
            }
            dr["订单号"] = int.Parse(drOri["id"].ToString().Trim());
            dr["日期"] = DateTime.Parse(drOri["pay_time"].ToString()).ToString("u");
            dr["店铺"] = drOri["shop"].ToString();
            dr["类型"] = drOri["type"].ToString().Trim();
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
            totalSale = totalSale + Math.Round(double.Parse(drOri["order_price"].ToString()),2);
            dr["实付金额"] = Math.Round(double.Parse(drOri["order_real_pay_price"].ToString()),2);
            totalCharge = totalCharge + Math.Round(double.Parse(drOri["order_real_pay_price"].ToString()),2);
            dr["龙珠系数"] = Math.Round(double.Parse(drOri["score_rate"].ToString()),2);
            dr["生成龙珠"] = Math.Round(double.Parse(drOri["generate_score"].ToString()),2);
            totalScore = totalScore + Math.Round(double.Parse(drOri["generate_score"].ToString()),2);
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
            dr["备注"] = drOri["memo1"].ToString().Trim();

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
                if (!drOri["service_open_id"].ToString().Trim().Equals(""))
                {
                    DataRow[] drArrAdmin = dtAdmin.Select(" open_id = '" + drOri["service_open_id"].ToString().Trim() + "' ");
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
            }

            dt.Rows.Add(dr);
        }
        DataRow drTotal = dt.NewRow();
        drTotal["昵称"] = "总计";
        drTotal["零售总价"] = Math.Round(totalSale, 2).ToString();
        drTotal["实付金额"] = Math.Round(totalCharge, 2).ToString();
        drTotal["生成龙珠"] = ((int)totalScore).ToString();
        dt.Rows.Add(drTotal);
        return dt;
    }

    protected void TypeList_SelectedIndexChanged(object sender, EventArgs e)
    {
        dg.DataSource = GetData();
        dg.DataBind();
    }

    protected void ShopList_SelectedIndexChanged(object sender, EventArgs e)
    {
        dg.DataSource = GetData();
        dg.DataBind();
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        #start_date {
            width: 75px;
        }
        #end_date {
            width: 75px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div>日期：&nbsp;<input type="text" id="start_date" value="<%=startDate.Year.ToString() + "-" + startDate.Month.ToString() + "-" + startDate.Day.ToString()%>" /> 
        - <input type="text" id="end_date" value="<%=endDate.Year.ToString() + "-" + endDate.Month.ToString() + "-" + endDate.Day.ToString() %>" /> &nbsp;<input type="button" onclick="date_filter()" value=" 查 询 " />  
        <a href="?start_date=<%=DateTime.Now.AddDays(-1).Year.ToString() + "-" + DateTime.Now.AddDays(-1).Month.ToString() + "-" + DateTime.Now.AddDays(-1).Day.ToString() %>&end_date=<%=DateTime.Now.AddDays(-1).Year.ToString() + "-" + DateTime.Now.AddDays(-1).Month.ToString() + "-" + DateTime.Now.AddDays(-1).Day.ToString() %>" >昨天</a> 
        <a href="?start_date=<%=mondayDate.Year.ToString() + "-" + mondayDate.Month.ToString() + "-" + mondayDate.Day.ToString() %>&end_date=<%=DateTime.Now.Year.ToString() + "-" + DateTime.Now.Month.ToString() + "-" + DateTime.Now.Day.ToString() %>" >本周</a>&nbsp;&nbsp; 类型：
        <select id="type" onchange="date_filter()"  >
            <option <%=((type.Trim().Equals("全部"))? "selected":"") %> >全部</option>
            <option <%=((type.Trim().Equals("店销"))? "selected":"") %> >店销</option>
            <option <%=((type.Trim().Equals("服务"))? "selected":"") %> >服务</option>
        </select>
        &nbsp; 店铺：<select id="shop" onchange="shop_change()" >
            <option <%=((shop.Trim().Equals("全部"))? "selected":"") %> >全部</option>
            <option <%=((shop.Trim().Equals("万龙"))? "selected":"") %> >万龙</option>
            <option <%=((shop.Trim().Equals("南山"))? "selected":"") %> >南山</option>
            <option <%=((shop.Trim().Equals("八易"))? "selected":"") %> >八易</option>
            <option <%=((shop.Trim().Equals("总店"))? "selected":"") %> >总店</option>
            <option <%=((shop.Trim().Equals("崇礼旗舰店"))? "selected":"") %> >崇礼旗舰店</option>
                  </select></div>
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
    <script type="text/javascript" >
        function date_filter() {
            window.location.href = '?start_date=' + document.getElementById("start_date").value + '&end_date=' + document.getElementById("end_date").value
                + '&type=' + document.getElementById("type").value + '&shop=' + document.getElementById("shop").value;
        }
        function shop_change() {
            var shop = document.getElementById("shop").value;
            var type = document.getElementById("type").value;
            if (shop == '万龙') {
                type = '全部';
            }
            window.location.href = '?start_date=' + document.getElementById("start_date").value + '&end_date=' + document.getElementById("end_date").value
                + '&type=' + type + '&shop=' + shop;
        }
    </script>
</body>
</html>
