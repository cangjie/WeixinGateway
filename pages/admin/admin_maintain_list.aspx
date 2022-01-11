<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
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
        DateTime start = DateTime.Parse(Util.GetSafeRequestValue(Request, "start", "2021-10-1"));
        DateTime end = DateTime.Parse(Util.GetSafeRequestValue(Request, "start", "2022-5-30"));
        DataTable dt = new DataTable();
        dt.Columns.Add("ID");
        dt.Columns.Add("店铺");
        dt.Columns.Add("流水号");
        dt.Columns.Add("手机");
        dt.Columns.Add("姓名");
        dt.Columns.Add("昵称");
        dt.Columns.Add("顾客备注");
        dt.Columns.Add("日期");
        dt.Columns.Add("时间");
        dt.Columns.Add("项目");
        dt.Columns.Add("应付金额");
        dt.Columns.Add("实付金额");
        dt.Columns.Add("类型");
        dt.Columns.Add("品牌");
        dt.Columns.Add("系列");
        dt.Columns.Add("尺寸");
        dt.Columns.Add("年款");
        dt.Columns.Add("提取");
        dt.Columns.Add("收板");
        dt.Columns.Add("订单备注");
        dt.Columns.Add("照片");
        dt.Columns.Add("渠道");
        DataTable dtOrder = DBHelper.GetDataTable(" select * from order_online where type = '服务' and pay_state = 1 "
            + " and create_date >= '" + start.ToShortDateString() + "' and create_date <= '" + end.ToShortDateString() + "' "
            + " and exists ( select 'a' from maintain_in_shop_request where order_id = order_online.[id] )  "
            + " order by [id] desc ");
        foreach (DataRow drOrder in dtOrder.Rows)
        {

            OnlineOrder order = new OnlineOrder();
            order._fields = drOrder;
            string channel = "H5";
            OnlineOrderDetail[] detailArr = order.OrderDetails;
            EquipMaintainRequestInshop[] taskArr = new EquipMaintainRequestInshop[0];
            if (detailArr.Length > 0 || !drOrder["pay_method"].ToString().Trim().Equals("微信"))
            {
                channel = "MAPP";
                DataTable dtTask = DBHelper.GetDataTable("select * from maintain_in_shop_request where order_id = " + drOrder["id"].ToString() );
                taskArr = new EquipMaintainRequestInshop[dtTask.Rows.Count];
                for (int i = 0; i < dtTask.Rows.Count; i++)
                {
                    taskArr[i] = new EquipMaintainRequestInshop();
                    taskArr[i]._fields = dtTask.Rows[i];
                }
            }
            if (channel.Trim().Equals("H5"))
            {
                DataRow dr = dt.NewRow();
                WeixinUser user = new WeixinUser(drOrder["open_id"].ToString());
                dr["ID"] = drOrder["id"].ToString().Trim();
                dr["店铺"] = drOrder["shop"].ToString().Trim();
                dr["流水号"] = "";
                dr["手机"] = drOrder["cell_number"].ToString().Trim();
                dr["姓名"] = "";
                dr["昵称"] = drOrder["name"].ToString().Trim();
                dr["顾客备注"] = user.Memo.Trim();
                DateTime orderDate = DateTime.Parse(drOrder["create_date"].ToString());
                dr["日期"] = orderDate.ToShortDateString();
                dr["时间"] = orderDate.Hour.ToString() + ":" + orderDate.Minute.ToString();
                dr["项目"] = "";
                dr["应付金额"] = Math.Round(double.Parse(drOrder["order_price"].ToString()), 2).ToString();
                dr["实付金额"] = Math.Round(double.Parse(drOrder["order_real_pay_price"].ToString()), 2).ToString();
                dr["类型"] = "";
                dr["品牌"] = "";
                dr["系列"] = "";
                dr["尺寸"] = "";
                dr["年款"] = "";
                dr["提取"] = "";
                string staffNick = "";
                try
                {
                    WeixinUser staffUser = new WeixinUser(order.StaffOpenId.Trim());
                    staffNick = staffUser.Nick.Trim();
                }
                catch
                {

                }

                dr["收板"] = staffNick;
                if (!drOrder["pay_method"].ToString().Trim().Equals("微信"))
                {
                    dr["订单备注"] = drOrder["pay_method"].ToString().Trim();// + " " + drOrder["pay_memo"].ToString().Trim();
                }
                else
                {
                    dr["订单备注"] = drOrder["memo"].ToString();
                }

                dr["渠道"] = channel.Trim();
                dt.Rows.Add(dr);

            }
            else
            {
                if (taskArr.Length > 0)
                {
                    WeixinUser user = new WeixinUser(drOrder["open_id"].ToString());
                    foreach (EquipMaintainRequestInshop task in taskArr)
                    {
                        DataRow dr = dt.NewRow();
                        dr["ID"] = drOrder["id"].ToString().Trim();
                        dr["店铺"] = drOrder["shop"].ToString().Trim();
                        dr["流水号"] = task._fields["task_flow_num"].ToString().Trim();
                        dr["手机"] = task._fields["confirmed_cell"].ToString().Trim();
                        dr["姓名"] = task._fields["confirmed_name"].ToString().Trim() + " "
                            + (task._fields["confirmed_gender"].ToString().Trim().Equals("女") ? "女士" : "先生");
                        dr["昵称"] = user.Nick;
                        dr["顾客备注"] = "";
                        DateTime orderDate = DateTime.Parse(drOrder["create_date"].ToString());
                        dr["日期"] = orderDate.ToShortDateString();
                        dr["时间"] = orderDate.Hour.ToString() + ":" + orderDate.Minute.ToString();
                        string serviceItem = "";
                        if (task._fields["confirmed_edge"].ToString().Trim().Equals("1"))
                        {
                            serviceItem = serviceItem + " 修刃 " + task._fields["confirmed_degree"].ToString().Trim();
                        }
                        if (task._fields["confirmed_candle"].ToString().Trim().Equals("1"))
                        {
                            serviceItem = serviceItem + " 打蜡";
                        }
                        serviceItem = serviceItem + " " + task._fields["confirmed_more"].ToString().Trim();
                        dr["项目"] = serviceItem.Trim();
                        dr["应付金额"] = Math.Round(double.Parse(drOrder["order_price"].ToString()), 2).ToString();
                        dr["实付金额"] = Math.Round(double.Parse(drOrder["order_real_pay_price"].ToString()), 2).ToString();
                        dr["类型"] = task._fields["confirmed_equip_type"].ToString().Trim();
                        dr["品牌"] = task._fields["confirmed_brand"].ToString().Trim();
                        dr["系列"] = task._fields["confirmed_serial"].ToString().Trim();
                        dr["尺寸"] = task._fields["confirmed_scale"].ToString().Trim();
                        dr["年款"] = task._fields["confirmed_year"].ToString().Trim();
                        DateTime pickDate = DateTime.Parse(task._fields["confirmed_pick_date"].ToString());
                        dr["提取"] = pickDate.Date == orderDate.Date ? "当日" : "次日";
                        MiniUsers staffUser = new MiniUsers(task._fields["service_open_id"].ToString());
                        dr["收板"] = staffUser._fields["nick"].ToString();
                        if (task._fields["pay_method"].ToString().Trim().Equals("微信"))
                        {
                            dr["订单备注"] = task._fields["confirmed_memo"].ToString();
                        }
                        else
                        {
                            dr["订单备注"] = task._fields["pay_method"].ToString().Trim() + " " + task._fields["pay_memo"].ToString().Trim();
                        }
                        dr["渠道"] = channel.Trim();
                        dr["照片"] = "";
                        string[] photoArr = task._fields["confirmed_images"].ToString().Split(',');
                        int i = 1;
                        foreach(string photo in photoArr)
                        {
                            dr["照片"] = dr["照片"].ToString() + " <a href=\"" + photo.Trim() + "\" target=\"_blank\" >照片" + i.ToString() + "</a>";
                            i++;
                        }
                        dt.Rows.Add(dr);
                    }
                }
                else
                {
                    DataRow dr = dt.NewRow();
                    WeixinUser user = new WeixinUser(drOrder["open_id"].ToString());
                    dr["ID"] = drOrder["id"].ToString().Trim();
                    dr["店铺"] = drOrder["shop"].ToString().Trim();
                    dr["流水号"] = "";
                    dr["手机"] = drOrder["cell_number"].ToString().Trim();
                    dr["姓名"] = "";
                    dr["昵称"] = drOrder["name"].ToString().Trim();
                    try
                    {
                        dr["顾客备注"] = user.Memo.Trim();
                    }
                    catch
                    {
                        dr["顾客备注"] = "";
                    }
                    DateTime orderDate = DateTime.Parse(drOrder["create_date"].ToString());
                    dr["日期"] = orderDate.ToShortDateString();
                    dr["时间"] = orderDate.Hour.ToString() + ":" + orderDate.Minute.ToString();
                    string serviceItem = "";
                    foreach (OnlineOrderDetail detail in detailArr)
                    {
                        serviceItem = serviceItem + " " + detail.productName.Trim();
                    }
                    dr["项目"] = serviceItem.Trim();
                    dr["应付金额"] = Math.Round(double.Parse(drOrder["order_price"].ToString()), 2).ToString();
                    dr["实付金额"] = Math.Round(double.Parse(drOrder["order_real_pay_price"].ToString()), 2).ToString();
                    dr["类型"] = "";
                    dr["品牌"] = "";
                    dr["系列"] = "";
                    dr["尺寸"] = "";
                    dr["年款"] = "";
                    dr["提取"] = "";
                    string staffOpenId = order.StaffOpenId.Trim();
                    if (!staffOpenId.Equals(""))
                    {
                        WeixinUser staffUser = new WeixinUser(staffOpenId.Trim());
                        dr["收板"] = staffUser.Nick.Trim();
                    }
                    else
                    {
                        dr["收板"] = "";
                    }
                    dr["订单备注"] = drOrder["memo"].ToString();
                    dr["渠道"] = channel.Trim();
                    /*
                    string[] photoArr = dr["confirmed_images"].ToString().Split(',');
                    int i = 1;
                    foreach(string photo in photoArr)
                    { 
                        dr["照片"] = dr["照片"].ToString() + " <a href=\"" + photo.Trim() + "\" target=\"_blank\" >照片" + i.ToString() + "</a>";
                        i++;
                    }
                    */
                    dt.Rows.Add(dr);
                }
            }


        }

        return dt;
    }

    protected void downloadSheet_Click(object sender, EventArgs e)
    {
        DataTable dt = GetData();
        string content = "";
        foreach (DataColumn dc in dt.Columns)
        {
            content = content + "," + dc.Caption;
        }
        content = content.Remove(0, 1) + "\r\n";
        foreach (DataRow dr in dt.Rows)
        {
            string lineContent = "";
            foreach (DataColumn dc in dt.Columns)
            {
                lineContent = lineContent + "," + dr[dc].ToString().Trim();
            }
            lineContent = lineContent.Remove(0, 1) + "\r\n";
            content = content + lineContent;
        }
        System.Text.Encoding utf8 = System.Text.Encoding.UTF8;
        System.Text.Encoding gb2312 = System.Text.Encoding.GetEncoding("GB2312");
        byte[] contentBytes = System.Text.Encoding.Convert(utf8, gb2312, utf8.GetBytes(content));
        content = gb2312.GetString(contentBytes);
        Response.Clear();
        Response.ContentType = "text/plain";
        Response.Headers.Add("Content-Disposition", "attachment; filename=maintain_sheet.csv");
        Response.ContentEncoding = gb2312;
        Response.Write(content.Trim());
        Response.End();
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Button runat="server" ID="downloadSheet" Text="下载" OnClick="downloadSheet_Click" />
        </div>
        <div>
            <asp:DataGrid runat="server" ID="dg" Width="100%" BackColor="White" BorderColor="#999999" BorderStyle="None" BorderWidth="1px" CellPadding="3" GridLines="Vertical"  >
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
