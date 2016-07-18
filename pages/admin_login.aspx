<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    protected void Button1_Click(object sender, EventArgs e)
    {
        if ((TextUsername.Text.Trim() + ":" + TextPassword.Text.Trim()).Equals("admin:missyo"))
        {
            Session["cms_login"] = "1";
            Response.Redirect("admin_content_list.aspx", true);
        }
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        .auto-style1 {
            width: 100%;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
        <table class="auto-style1">
            <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td style="text-align: right">用户名：</td>
                <td>
                    <asp:TextBox ID="TextUsername" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td style="text-align: right">密码：</td>
                <td>
                    <asp:TextBox ID="TextPassword" runat="server" TextMode="Password"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>
                    <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="登  录" />
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
        </table>
    
    </div>
    </form>
</body>
</html>
