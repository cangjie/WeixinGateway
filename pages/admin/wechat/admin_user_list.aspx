<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<!DOCTYPE html>

<script runat="server">

    public WeixinUser currentUser;
    public string openId = "";
    public string userToken = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        string currentPageUrl = Request.Url.ToString().Trim();
        if (Session["user_token"] == null || Session["user_token"].ToString().Trim().Equals(""))
        {
            Response.Redirect("../../../authorize.aspx?callback=" + currentPageUrl, true);
        }
        userToken = Session["user_token"].ToString();
        openId = WeixinUser.CheckToken(userToken);
        if (openId.Trim().Equals(""))
        {
            Response.Redirect("../../../authorize.aspx?callback=" + currentPageUrl, true);
        }
        currentUser = new WeixinUser(WeixinUser.CheckToken(userToken));

        if (!currentUser.IsAdmin)
            Response.End();


        if (!IsPostBack)
        {
            dg.DataSource = GetData();
            dg.DataBind();
        }
    }

    public DataTable GetData()
    {
        DataTable dt = new DataTable();
        dt.Columns.Add("头像");
        dt.Columns.Add("昵称");
        dt.Columns.Add("电话");
        dt.Columns.Add("龙珠", Type.GetType("System.Int32"));
        dt.Columns.Add("标签");
        dt.Columns.Add("卡券");
        dt.Columns.Add("介绍人");

        DataTable dtOri = DBHelper.GetDataTable(" select * from users order by nick ");
        for (int i = 0; i < dtOri.Rows.Count; i++)
        {
            DataRow dr = dt.NewRow();
            dr["头像"] = "<a href=\"admin_user_detail.aspx?openid=" + dtOri.Rows[i]["open_id"].ToString().Trim()
                + "\" ><img src=\"" + dtOri.Rows[i]["head_image"].ToString().Trim()
                + "\" width=\"25\" height=\"25\" border=\"0\"  /></a>";
            dr["昵称"] = "<a href=\"admin_user_detail.aspx?openid=" + dtOri.Rows[i]["open_id"].ToString().Trim()
                + "\" >" + dtOri.Rows[i]["nick"].ToString().Trim() + "</a>";
            dr["电话"] = dtOri.Rows[i]["cell_number"].ToString().Trim();
            dr["龙珠"] = Point.GetUserPoints(dtOri.Rows[i]["open_id"].ToString().Trim());
            dr["标签"] = dtOri.Rows[i]["memo"].ToString();
            dr["卡券"] = GetTicketSummary(dtOri.Rows[i]["open_id"].ToString().Trim());
            string fatherInfo = "";
            if (!dtOri.Rows[i]["father_open_id"].ToString().Trim().Equals(""))
            {
                try
                {
                    WeixinUser fatherUser = new WeixinUser(dtOri.Rows[i]["father_open_id"].ToString().Trim());
                    fatherInfo = "<a href=\"admin_user_detail.aspx?openid=" + fatherUser.OpenId + "\" >" + fatherUser.Nick.Trim() + "</a>";
                }
                catch
                {

                }
            }
            dr["介绍人"] = fatherInfo.Trim();
            dt.Rows.Add(dr);
        }

        DataTable dtNew = dt.Clone();
        foreach (DataRow dr in dt.Select("", " 龙珠 desc"))
        {
            DataRow drNew = dtNew.NewRow();
            foreach (DataColumn dc in dt.Columns)
            {
                drNew[dc.Caption.Trim()] = dr[dc];
            }
            dtNew.Rows.Add(drNew);
        }
        return dtNew;
    }

    public string GetTicketSummary(string openId)
    {
        DataTable dt = Ticket.GetUserTiketSummary(openId, false);
        string str = "";
        foreach (DataRow dr in dt.Rows)
        {
            str = str + " " + dr["name"].ToString().Trim() + ": " + dr["count"].ToString();  
        }
        return str;
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:DataGrid ID="dg" runat="server" AutoGenerateColumns="False" BackColor="White" BorderColor="#999999" BorderStyle="None" BorderWidth="1px" CellPadding="3" GridLines="Vertical" Width="100%" Font-Size="XX-Large" >
            <AlternatingItemStyle BackColor="#DCDCDC" />
            <Columns>
                <asp:BoundColumn DataField="头像" HeaderText="头像"></asp:BoundColumn>
                <asp:BoundColumn DataField="昵称" HeaderText="昵称"></asp:BoundColumn>
                <asp:BoundColumn DataField="电话" HeaderText="电话"></asp:BoundColumn>
                <asp:BoundColumn DataField="龙珠" HeaderText="龙珠"></asp:BoundColumn>
                <asp:BoundColumn DataField="标签" HeaderText="标签"></asp:BoundColumn>
                <asp:BoundColumn DataField="卡券" HeaderText="卡券"></asp:BoundColumn>
                <asp:BoundColumn DataField="介绍人" HeaderText="介绍人"></asp:BoundColumn>
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
