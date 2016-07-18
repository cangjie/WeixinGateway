<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<!DOCTYPE html>

<script runat="server">

    public string currentOpenId = "oUuHnwXMB0fjGSH1CEv8jJDr3CRQ";
    public WeixinUser currentUser;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["user_token"] == null || Session["user_token"].ToString().Trim().Equals(""))
        {

            Response.Redirect("../authorize.aspx?callback=" + Server.UrlEncode("pages/score.aspx"), true);
        }
        else
        {
            currentOpenId = WeixinUser.CheckToken(Session["user_token"].ToString());
            if (currentOpenId.Trim().Equals(""))
            {
                Response.Redirect("../authorize.aspx?callback=" + Server.UrlEncode("pages/score.aspx"), true);
            }
        }
      
        currentUser = new WeixinUser(currentOpenId);
        dg.DataSource = GetData();
        dg.DataBind();
    }

    public DataTable GetData()
    {
        UserAction[] userActionArray = UserAction.GetOneUserValidAction(currentOpenId);
        DataTable dt = new DataTable();
        dt.Columns.Add("日期");
        dt.Columns.Add("动作");
        dt.Columns.Add("积分");
        dt.Columns.Add("说明");
        foreach (UserAction userAction in userActionArray)
        {
            DataRow dr = dt.NewRow();
            dr["日期"] = userAction.ActionDate.ToShortDateString();
            dr["动作"] = userAction.Name.Trim();
            dr["积分"] = "待定";
            dr["说明"] = "待完善";
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
    <table style="width:100%" >
        <tr>
            <td>
                <span><img src="<%=currentUser.HeadImage %>" style="width:50px;height:50px" /> <%=currentUser.Nick.Trim() %></span>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <span style="right:500px" >积分：xxxxxxxx</span>
            </td>
        </tr>
        <tr>
            <td><asp:DataGrid runat="server" ID="dg" BackColor="White" BorderColor="#999999" BorderStyle="None" BorderWidth="1px" CellPadding="3" GridLines="Vertical" Width="100%"  >
                <AlternatingItemStyle BackColor="#DCDCDC" />
                <FooterStyle BackColor="#CCCCCC" ForeColor="Black" />
                <HeaderStyle BackColor="#000084" Font-Bold="True" ForeColor="White" />
                <ItemStyle BackColor="#EEEEEE" ForeColor="Black" />
                <PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" Mode="NumericPages" />
                <SelectedItemStyle BackColor="#008A8C" Font-Bold="True" ForeColor="White" />
                </asp:DataGrid></td>
        </tr>
    </table>
</body>
</html>
