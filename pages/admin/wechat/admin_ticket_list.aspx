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
        DataTable dt = new DataTable();
        dt.Columns.Add("号码");
        dt.Columns.Add("类别");
        dt.Columns.Add("名称");
        dt.Columns.Add("发送者");
        dt.Columns.Add("持有者");
        dt.Columns.Add("持有者电话");
        dt.Columns.Add("已使用");
        dt.Columns.Add("使用备注");
        dt.Columns.Add("使用日期");
        dt.Columns.Add("到期日");

        DataTable dtOri = DBHelper.GetDataTable(" select * from ticket left join ticket_template on ticket_template.[id] = template_id "
            + " left join users on users.open_id = ticket.open_id order by ticket.expire_date ");
        for (int i = 0; i < dtOri.Rows.Count; i++)
        {
            DataRow dr = dt.NewRow();
            dr["号码"] = dtOri.Rows[i]["code"].ToString();
            dr["类别"] = dtOri.Rows[i]["type"].ToString();
            dr["名称"] =  dtOri.Rows[i]["name"].ToString();
            try
            {
                WeixinUser sender = new WeixinUser(Ticket.GetSenderOpenId(dtOri.Rows[i]["code"].ToString()));
                dr["发送者"] = sender.Nick.Trim();
            }
            catch
            {
                dr["发送者"] = "";
            }
            try
            {
                WeixinUser holder = new WeixinUser(Ticket.GetSenderOpenId(dtOri.Rows[i]["open_id"].ToString()));
                dr["持有者"] = holder.Nick;
                dr["持有者电话"] = holder.CellNumber.Trim();
            }
            catch
            {
                dr["持有者"] = "";
                dr["持有者电话"] = "";
            }
            dr["已使用"] = dtOri.Rows[i]["used"].ToString().Trim().Equals("0") ? "否" : "是";
            dr["使用备注"] = dtOri.Rows[i]["memo"].ToString().Trim();
            dr["使用日期"] = dtOri.Rows[i]["used_time"].ToString().Trim();
            dr["到期日"] = dtOri.Rows[i]["expire_date"].ToString().Trim();
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
        <asp:DataGrid ID="dg" runat="server" BackColor="White" BorderColor="#999999" BorderStyle="None" BorderWidth="1px" CellPadding="3" GridLines="Vertical" Width="100%" >
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
