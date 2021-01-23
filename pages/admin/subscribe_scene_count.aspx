<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Threading" %>
<!DOCTYPE html>

<script runat="server">



    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            DataTable dt = GetData(DateTime.Now);
            dg.DataSource = dt;
            dg.DataBind();
        }
    }

    public DataTable GetData(DateTime currentDate)
    {
        int totalCount = 0;
        DataTable dt = DBHelper.GetDataTable(" select dbo.func_GetSubscribeScene(wxreceivemsg_eventkey) as 场景, count(*) as 新增 from wxreceivemsg "
            + " where wxreceivemsg_crt >= '" + currentDate.ToShortDateString() + "' and wxreceivemsg_crt < '" + currentDate.AddDays(1).ToShortDateString() + "'  "
            + " and wxreceivemsg_event = 'subscribe' group by dbo.func_GetSubscribeScene(wxreceivemsg_eventkey)  ");
        DataTable dtNew = new DataTable();
        dtNew.Columns.Add("场景");
        dtNew.Columns.Add("新增");
        int deviceCount = 0;
        foreach (DataRow dr in dt.Rows)
        {
            if (dr["场景"].ToString().StartsWith("qrscene_161"))
            {
                deviceCount++;
            }
            else
            {
                DataRow drNew = dtNew.NewRow();
                drNew["场景"] = dr["场景"].ToString().Trim();
                drNew["新增"] = dr["新增"].ToString().Trim();
                totalCount = totalCount + int.Parse(drNew["新增"].ToString());
                dtNew.Rows.Add(drNew);
            }
        }
        DataRow drDevice = dtNew.NewRow();
        drDevice["场景"] = "八易烘鞋";
        drDevice["新增"] = deviceCount;
        dtNew.Rows.Add(drDevice);
        totalCount = totalCount + deviceCount;
        DataRow drTotal = dtNew.NewRow();
        drTotal["场景"] = "总计";
        drTotal["新增"] = totalCount.ToString();
        dtNew.Rows.Add(drTotal);
        return dtNew;
    }




    protected void calendar_SelectionChanged(object sender, EventArgs e)
    {
        DataTable dt = GetData(calendar.SelectedDate);
        dg.DataSource = dt;
        dg.DataBind();
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form2" runat="server">
    <div>
        <table width="100%" >
            <tr>
                <td><asp:Calendar runat="server" id="calendar" Width="100%" OnSelectionChanged="calendar_SelectionChanged" BackColor="White" BorderColor="Black" BorderStyle="Solid" CellSpacing="1" Font-Names="Verdana" Font-Size="9pt" ForeColor="Black" Height="250px" NextPrevFormat="ShortMonth" >
                    <DayHeaderStyle Font-Bold="True" Font-Size="8pt" ForeColor="#333333" Height="8pt" />
                    <DayStyle BackColor="#CCCCCC" />
                    <NextPrevStyle Font-Bold="True" Font-Size="8pt" ForeColor="White" />
                    <OtherMonthDayStyle ForeColor="#999999" />
                    <SelectedDayStyle BackColor="#333399" ForeColor="White" />
                    <TitleStyle BackColor="#333399" BorderStyle="Solid" Font-Bold="True" Font-Size="12pt" ForeColor="White" Height="12pt" />
                    <TodayDayStyle BackColor="#999999" ForeColor="White" />
                    </asp:Calendar></td>
            </tr>
            <tr>
                <td><asp:DataGrid ID="dg" runat="server" BackColor="White" BorderColor="#999999" BorderStyle="None" BorderWidth="1px" CellPadding="3" GridLines="Vertical" Width="100%" AutoGenerateColumns="False" AllowSorting="True" >
                <AlternatingItemStyle BackColor="#DCDCDC" />
                <Columns>
                    <asp:BoundColumn DataField="场景" HeaderText="场景"></asp:BoundColumn>
                    <asp:BoundColumn DataField="新增" HeaderText="新增"></asp:BoundColumn>
                </Columns>
                <FooterStyle BackColor="#CCCCCC" ForeColor="Black" />
                <HeaderStyle BackColor="#000084" Font-Bold="True" ForeColor="White" />
                <ItemStyle BackColor="#EEEEEE" ForeColor="Black" />
                <PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" Mode="NumericPages" />
                <SelectedItemStyle BackColor="#008A8C" Font-Bold="True" ForeColor="White" />
                </asp:DataGrid></td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
