<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        if (TextBox1.Text.Trim().Equals("admin") && TextBox2.Text.Trim().Equals("adminnimda"))
        {
            Session["is-log-in"] = "1";
            Response.Redirect("admin_points_file_list.aspx", true);
        }
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <table style="width:100%" >
            <tr>
                <td style="width:50%; text-align: right;">用户名：</td>
                <td>
                    <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td style="width:50%"></td>
                <td></td>
            </tr>
            <tr>
                <td style="width:50%; text-align: right;">密&nbsp;&nbsp;&nbsp; 码：</td>
                <td>
                    <asp:TextBox ID="TextBox2" runat="server" TextMode="Password"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td style="width:50%"></td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td style="width:50%"></td>
                <td>
                    <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="登    录" />
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
