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
        dt.Columns.Add("手机");
        dt.Columns.Add("昵称");
        dt.Columns.Add("证件类型");
        dt.Columns.Add("证件号码");
        dt.Columns.Add("品牌");
        dt.Columns.Add("长度");
        dt.Columns.Add("照片");
        dt.Columns.Add("日期");
        dt.Columns.Add("开始");
        dt.Columns.Add("结束");
        dt.Columns.Add("押金");
        dt.Columns.Add("退款");
        dt.Columns.Add("差价");
        dt.Columns.Add("店员");

        DataTable dtOrder = DBHelper.GetDataTable("select *, mini_users.nick as staff_nick from expierence_list "
            + " left join users on users.open_id = expierence_list.open_id  "
            + " left join mini_users on staff_open_id = mini_users.open_id "
            + " where expierence_list.create_date > '2021-10-1' "
            + " and exists ( select 'a' from order_online where order_online.[id] = guarantee_order_id and pay_state = 1  ) order by [id] desc ");
        foreach (DataRow drOrder in dtOrder.Rows)
        {

            DataRow dr = dt.NewRow();
            dr["ID"] = drOrder["id"].ToString();
            dr["店铺"] = drOrder["shop"].ToString();
            dr["手机"] = drOrder["cell_number"].ToString().Trim();
            dr["昵称"] = drOrder["nick"].ToString().Trim();
            dr["证件类型"] = drOrder["guarantee_credential_type"].ToString();
            dr["证件号码"] = drOrder["guarantee_credential_no"].ToString();
            dr["品牌"] = drOrder["asset_name"].ToString();
            dr["长度"] = drOrder["asset_scale"].ToString();
            string[] photoArr = drOrder["asset_photos"].ToString().Split(',');
            dr["照片"] = "";
            for (int i = 0; i < photoArr.Length; i++)
            {
                dr["照片"] = dr["照片"].ToString() + " <a href=\"" + photoArr[i].Trim() + "\" target=\"_blank\" >照片" + (i + 1).ToString() + "</a>";
            }
            DateTime startDate = DateTime.Parse(drOrder["start_time"].ToString());
            DateTime endDate = DateTime.Parse(drOrder["end_time"].ToString());
            dr["日期"] = startDate.ToShortDateString();
            dr["开始"] = startDate.Hour.ToString().PadLeft(2, '0') + ":" + startDate.Minute.ToString().PadLeft(2, '0');
            dr["结束"] = endDate.Hour.ToString().PadLeft(2, '0') + ":" + endDate.Minute.ToString().PadLeft(2, '0');
            double guarantee = double.Parse(drOrder["guarantee_cash"].ToString());
            double refund = double.Parse(drOrder["refund_amount"].ToString());
            dr["押金"] = Math.Round(guarantee, 2).ToString();
            dr["退款"] = Math.Round(refund, 2).ToString();
            dr["差价"] = Math.Round((guarantee - refund), 2).ToString();
            dr["店员"] = drOrder["staff_nick"].ToString().Trim();
            dt.Rows.Add(dr);




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
