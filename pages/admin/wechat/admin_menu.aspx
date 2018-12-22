<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<!DOCTYPE html>

<script runat="server">

    public WeixinUser currentUser;

    public string openId = "";

    public string userToken = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        string currentPageUrl = Server.UrlEncode("/pages/admin/wechat/admin_menu.aspx");


        if (Session["user_token"] == null || Session["user_token"].ToString().Trim().Equals(""))
        {
            Response.Redirect("../../../authorize.aspx?callback=" + currentPageUrl, true);
        }
        userToken = Session["user_token"].ToString();

        //userToken = "f10192787f4fe855aac1bf337e0925854eff0fb9914f89fe5c871db66c448b8a5b82fd46";
        openId = WeixinUser.CheckToken(userToken);

        currentUser = new WeixinUser(openId);

        if (!currentUser.IsAdmin)
        {
            Response.End();
        }

        if (!IsPostBack)
        {
            if (currentUser.CellNumber.Trim().Equals("13501177897") || currentUser.CellNumber.Trim().Equals("13910231129"))
            {
                btn.Enabled = true;
            }
            else
            {
                btn.Enabled = false;
            }
            dg.DataSource = GetData();
            dg.DataBind();
        }
    }

    public DataTable GetData()
    {
        SqlDataAdapter da = new SqlDataAdapter(" select [id] as ID, title as 标题, link as 链接 from menu order by [id] desc ", Util.conStr);
        DataTable dt = new DataTable();
        da.Fill(dt);
        da.Dispose();
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            dt.Rows[i]["链接"] = "<a href=\"" + dt.Rows[i]["链接"].ToString().Trim() + "\" >" + dt.Rows[i]["链接"].ToString().Trim() + "</a>";
        }
        return dt;
    }

    protected void btn_Click(object sender, EventArgs e)
    {
        DBHelper.InsertData("menu", new string[,] { { "title", "varchar", TxtTitle.Text.Trim() }, { "link", "varchar", TxtUrl.Text.Trim() } });
        dg.DataSource = GetData();
        dg.DataBind();
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        标题：<asp:TextBox ID="TxtTitle" runat="server" ></asp:TextBox>  &nbsp;&nbsp;  链接：<asp:TextBox ID="TxtUrl" runat="server" Width="414px" ></asp:TextBox>  &nbsp; <asp:Button id="btn" runat="server" Text="添加" OnClick="btn_Click" />
        <asp:DataGrid ID="dg" runat="server" Width="100%" BackColor="White" BorderColor="#999999" BorderStyle="None" BorderWidth="1px" CellPadding="3" GridLines="Vertical" >
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
