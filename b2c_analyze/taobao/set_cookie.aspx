<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    protected void BtnSetTaobaoCookie_Click(object sender, EventArgs e)
    {

        System.IO.File.AppendAllText(Server.MapPath("taobao_cookie.txt"), TxtTaobaoCookie.Text.Trim());
   
    }

    protected void BtnSetTmallCookie_Click(object sender, EventArgs e)
    {
        System.IO.File.AppendAllText(Server.MapPath("tmall_cookie.txt"), TxtTaobaoCookie.Text.Trim());
        //Core.TaobaoSnap.tmallCookie = TxtTmallCookie.Text.Trim();
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:TextBox ID="TxtTaobaoCookie" runat="server" Width="100%" Height="50px" TextMode="MultiLine" ></asp:TextBox>
    </div>
    <div>
        <asp:Button ID="BtnSetTaobaoCookie" Text="Set Taobao Cookie" runat="server" OnClick="BtnSetTaobaoCookie_Click" />
    </div>
    <div><br /></div>
    <div>
        <asp:TextBox ID="TxtTmallCookie" runat="server" Width="100%" Height="50px" TextMode="MultiLine" ></asp:TextBox>
    </div>
    <div>
        <asp:Button ID="BtnSetTmallCookie" Text="Set Tmall Cookie" runat="server" OnClick="BtnSetTmallCookie_Click" />
    </div>
    </form>
</body>
</html>
