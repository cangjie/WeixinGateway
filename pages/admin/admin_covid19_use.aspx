<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void btn_Click(object sender, EventArgs e)
    {
        string cardNo = TxtCardNo.Text.Trim();
        try
        {
            
            if (cardNo.Length == 9)
            {
                Card card = new Card(cardNo.Trim());
                card.Use(DateTime.Now, "非现场手动核销");
            }
            else
            {
                Card.CardDetail cardDetail = new Card.CardDetail(cardNo);
                cardDetail.Use(DateTime.Now, "非现场手动核销");
            }
            lb.Text = cardNo.Trim() + " 核销成功";
        }
        catch
        { 
            lb.Text = cardNo.Trim() + " 核销失败";
        }
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
            <asp:Label ID="lb" Width="100%" runat="server" Font-Bold="True" ForeColor="Red" ></asp:Label><br /><br />
            <asp:TextBox ID="TxtCardNo" runat="server" ></asp:TextBox>
            <asp:Button ID="btn" runat="server" Text=" 核 销 " OnClick="btn_Click" />
        </div>
    </form>
</body>
</html>
