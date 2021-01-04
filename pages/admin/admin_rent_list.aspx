<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        DataTable dt = new DataTable();
        dt.Columns.Add("时间");
        dt.Columns.Add("物品");
        dt.Columns.Add("借用人");
        dt.Columns.Add("抵押物");
        dt.Columns.Add("抵押内容");
        dt.Columns.Add("出借人");
        dt.Columns.Add("预计归还时间");

        DataTable dtOri = DBHelper.GetDataTable(" select * from rent_item order by [id] desc ");

        foreach (DataRow drOri in dtOri.Rows)
        {
            DataRow dr = dt.NewRow();
            DateTime createDate = DateTime.Parse(drOri["create_date"].ToString());
            dr["时间"] = createDate.ToShortDateString() + " " + createDate.Hour.ToString() + ":" + createDate.Minute.ToString();
            dr["物品"] = drOri["item"].ToString().Trim();
            if (!drOri["borrow_open_id"].ToString().Trim().Equals(""))
            {
                WeixinUser borrower = new WeixinUser(drOri["borrow_open_id"].ToString());
                dr["借用人"] = borrower.Nick.Trim();
            }
            else
            {
                dr["借用人"] = "-";
            }
            dr["抵押物"] = drOri["security_type"].ToString().Trim();
            dr["抵押内容"] = drOri["security_content"].ToString().Trim();
            if (!drOri["lend_open_id"].ToString().Trim().Equals(""))
            {
                WeixinUser lender = new WeixinUser(drOri["lend_open_id"].ToString().Trim());
                dr["出借人"] = lender.Nick;
            }
            else
            {
                dr["出借人"] = "-";
            }
            DateTime returnTime = DateTime.Parse(drOri["schedule_return_date_time"].ToString().Trim());
            dr["预计归还时间"] = returnTime.ToShortDateString() + " " + returnTime.Hour.ToString() + ":" + returnTime.Minute.ToString();
            dt.Rows.Add(dr);
        }
        dg.DataSource = dt;
        dg.DataBind();
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:DataGrid runat="server" ID="dg" Width="100%" BackColor="White" BorderColor="#999999" BorderStyle="None" BorderWidth="1px" CellPadding="3" GridLines="Vertical" >
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
