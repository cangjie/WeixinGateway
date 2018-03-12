<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Text.RegularExpressions" %>
<!DOCTYPE html>

<script runat="server">


    public string openId = "";
    public string userToken = "";

    public string customOpenId = "oZBHkjoXAYNrx5wKCWRCD5qSGrPM";

    public DataTable dtTicketTemplate;

    public WeixinUser currentUser = new WeixinUser("oZBHkjoXAYNrx5wKCWRCD5qSGrPM");

    public WeixinUser customUser;

    protected void Page_Load(object sender, EventArgs e)
    {
        customOpenId = Util.GetSafeRequestValue(Request, "openid", "oZBHkjoXAYNrx5wKCWRCD5qSGrPM").Trim();
        dtTicketTemplate = DBHelper.GetDataTable(" select * from ticket_template where hide = 0 ");

        
        string currentPageUrl = Request.Url.ToString();
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
            

        customUser = new WeixinUser(customOpenId.Trim());
        if (!IsPostBack)
        {

            TxtNick.Text = customUser.Nick.Trim();
            TxtCell.Text = customUser.CellNumber.Trim();
            LblScore.Text = Point.GetUserPoints(customOpenId.Trim()).ToString();
            ImgHead.ImageUrl = customUser.HeadImage;
            if (!customUser.FatherOpenId.Trim().Equals(""))
            {
                try
                {
                    WeixinUser fatherUser = new WeixinUser(customUser.FatherOpenId.Trim());
                    LblFather.Text = fatherUser.Nick.Trim() + " " + fatherUser.CellNumber.Trim();
                    TxtMemo.Text = customUser.Memo.Trim();
                }
                catch
                {

                }

            }
            dg.DataSource = GetTagData();
            dg.DataBind();
        }
    }

    protected void save1_Click(object sender, EventArgs e)
    {
        WeixinUser customUser = new WeixinUser(customOpenId.Trim());
        customUser.CellNumber = TxtCell.Text.Trim();
        customUser.Memo = TxtMemo.Text.Trim();
        LblInfo.Text = "保存成功。";
    }

    public DataTable GetTagData()
    {
        return WeixinUser.GetUserTagTable(customUser.OpenId.Trim());
    }

    protected void save2_Click(object sender, EventArgs e)
    {
        save2.Enabled = false;
        WeixinUser customUser = new WeixinUser(customOpenId.Trim());
        int score = 0;
        try
        {
            score = int.Parse(TxtScore.Text.Trim());
            if (score > 0)
                Point.AddNew(customOpenId, score, DateTime.Now, currentUser.Nick + " 赠予。");
        }
        catch
        {

        }
        foreach (string key in Request.Form.Keys)
        {
            if (Regex.IsMatch(key, @"ticket_num_\d+"))
            {
                try
                {
                    int count = int.Parse(Request.Form[key].Trim());
                    for (int i = 0; i < count; i++)
                    {
                        int templateId = int.Parse(key.Replace("ticket_num_", "").Trim());
                        string code = Ticket.GenerateNewTicketCode(templateId);
                        //Ticket.GenerateNewTicket(code, customOpenId.Trim(), templateId);
                        Ticket.GenerateNewTicket(code, currentUser.OpenId.Trim(), templateId);
                        Ticket ticket = new Ticket(code);
                        ticket.Transfer(customOpenId.Trim(), "管理员赠送");
                    }
                }
                catch
                {

                }
            }
        }
        LblInfo.Text = "成功送出。";
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

    protected void addTag_Click(object sender, EventArgs e)
    {
        DataTable dt = GetTagData();
        DataRow dr = dt.NewRow();
        dr[0] = "";
        dr[1] = "";
        dt.Rows.Add(dr);
        dg.DataSource = dt;
        dg.EditItemIndex = dt.Rows.Count - 1;
        dg.DataBind();
    }

    protected void dg_UpdateCommand(object source, DataGridCommandEventArgs e)
    {
        string tag = ((TextBox)dg.Items[e.Item.ItemIndex].Cells[2].Controls[0]).Text.Trim();
        string tagValue = ((TextBox)dg.Items[e.Item.ItemIndex].Cells[3].Controls[0]).Text.Trim();
        if (!tag.Trim().Equals("") && !tagValue.Trim().Equals(""))
        {
            WeixinUser.SaveUserTag(customOpenId.Trim(), tag, tagValue);
        }
        dg.DataSource = GetTagData();
        dg.EditItemIndex = -1;
        dg.DataBind();
    }

    protected void dg_DeleteCommand(object source, DataGridCommandEventArgs e)
    {
        string tag = dg.DataKeys[e.Item.ItemIndex].ToString().Trim();
        WeixinUser.DeleteUserTag(customOpenId, tag);
        dg.DataSource = GetTagData();
        dg.EditItemIndex = -1;
        dg.DataBind();
    }

    protected void dg_CancelCommand(object source, DataGridCommandEventArgs e)
    {
        dg.DataSource = GetTagData();
        dg.EditItemIndex = -1;
        dg.DataBind();
    }

    protected void dg_EditCommand(object source, DataGridCommandEventArgs e)
    {
        dg.DataSource = GetTagData();
        dg.EditItemIndex = e.Item.ItemIndex;
        dg.DataBind();
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        .auto-style1 {
            height: 20px;
        }
    </style>
</head>
<body>
    <form id="form" runat="server" >
    <table width="100%" border="1" style="font-size: xx-large"  >
        <tr>
            <td colspan="3" ><asp:Label ID="LblInfo" runat="server" Font-Bold="True" Font-Size="Small" ForeColor="Red" Width="100%" ></asp:Label></td>
        </tr>
        <tr>
            <td rowspan="5" ><asp:Image ID="ImgHead" runat="server" Width="150px" /></td>
            <td>昵称：</td>
            <td><asp:TextBox ID="TxtNick" runat="server" ReadOnly="True" ></asp:TextBox></td>
        </tr>
        <tr>
            <td>电话：</td>
            <td><asp:TextBox ID="TxtCell" runat="server" ></asp:TextBox></td>
        </tr>
        <tr>
            <td>龙珠：</td>
            <td><asp:Label runat="server" ID="LblScore" ></asp:Label></td>
        </tr>
        <tr>
            <td>介绍人：</td>
            <td><asp:Label runat="server" ID="LblFather" ></asp:Label></td>
        </tr>
        <tr>
            <td>备注：</td>
            <td><asp:TextBox ID="TxtMemo" runat="server" Width="310px" ></asp:TextBox></td>
        </tr>
        <tr>
            <td colspan="3" ><asp:Button ID="save1" runat="server" Text="保存" OnClick="save1_Click" /></td>
        </tr>
        <tr>
            <td colspan="3">标签：<asp:Button runat="server" ID="addTag" Text="新增标签" OnClick="addTag_Click" /></td>
        </tr>
        <tr>
            <td colspan="3"><asp:DataGrid runat="server" Width="100%" ID="dg" AutoGenerateColumns="False" BackColor="White" BorderColor="#999999" BorderStyle="None" BorderWidth="1px" CellPadding="3" GridLines="Vertical" OnUpdateCommand="dg_UpdateCommand" OnDeleteCommand="dg_DeleteCommand" OnCancelCommand="dg_CancelCommand" DataKeyField="tag" OnEditCommand="dg_EditCommand" >
                <AlternatingItemStyle BackColor="#DCDCDC" />
                <Columns>
                    <asp:EditCommandColumn CancelText="取消" EditText="编辑" UpdateText="更新"></asp:EditCommandColumn>
                    <asp:ButtonColumn CommandName="Delete" Text="删除"></asp:ButtonColumn>
                    <asp:BoundColumn DataField="tag" HeaderText="标签"></asp:BoundColumn>
                    <asp:BoundColumn DataField="tag_value" HeaderText="内容"></asp:BoundColumn>
                </Columns>
                <FooterStyle BackColor="#CCCCCC" ForeColor="Black" />
                <HeaderStyle BackColor="#000084" Font-Bold="True" ForeColor="White" />
                <ItemStyle BackColor="#EEEEEE" ForeColor="Black" />
                <PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" Mode="NumericPages" />
                <SelectedItemStyle BackColor="#008A8C" Font-Bold="True" ForeColor="White" />
                </asp:DataGrid></td>
        </tr>
        <tr>
            <td colspan="3">未使用卡券：<%=GetTicketSummary(customOpenId) %></td>
        </tr>
        <tr>
            <td>赠送龙珠：</td>
            <td colspan="2" ><asp:TextBox ID="TxtScore" runat="server" Width="50" ></asp:TextBox> 颗</td>
        </tr>
        <tr>
            <td colspan="3" >赠送卡券：</td>
        </tr>
        <%
            foreach (DataRow drTicketTemplate in dtTicketTemplate.Rows)
            {
             %>
        <tr>
            <td><%=drTicketTemplate["name"].ToString().Trim() %></td>
            <td><%=drTicketTemplate["memo"].ToString().Trim() %></td>
            <td><input type="text" name="ticket_num_<%=drTicketTemplate["id"].ToString().Trim() %>" width="25"/>张</td>
        </tr>
        <%
            }
             %>
        <tr>
            <td colspan="3"><asp:Button ID="save2" runat="server" Text="送出" OnClick="save2_Click" /></td>
        </tr>
    </table>
    </form>
</body>
</html>
