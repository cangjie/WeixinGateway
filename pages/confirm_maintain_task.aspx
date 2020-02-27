<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    public WeixinUser currentUser;

    public string openId = "";

    public string userToken = "";

    public string msg = "";

    public int orderId = 0;

    protected void Page_Load(object sender, EventArgs e)
    {
        string currentPageUrl = Request.Url.ToString();
        if (Session["user_token"] == null || Session["user_token"].ToString().Trim().Equals(""))
        {
            Response.Redirect("../authorize.aspx?callback=" + currentPageUrl, true);
        }
        userToken = Session["user_token"].ToString();
        openId = WeixinUser.CheckToken(userToken);

        int taskId = int.Parse(Util.GetSafeRequestValue(Request, "id", "0"));

        SkiMaintainTask task = new SkiMaintainTask(taskId);

        if (!openId.Trim().Equals(task._fields["customer_open_id"].ToString()))
        {
            Response.Write("请送板本人亲自扫码。");
            Response.End();
        }

        string cardNo = task._fields["associate_card_no"].ToString().Trim();
        if (cardNo.Length >= 9)
        {
            Card card = new Card(cardNo.Substring(0, 9).Trim());
            if (!card.Owner.OpenId.Trim().Equals(openId))
            {
                Response.Write("需要持卡者本人扫码。");
                Response.End();
            }
            if (cardNo.Length == 12)
            {
                Card.CardDetail detail = new Card.CardDetail(cardNo.Trim());
                detail.Use(DateTime.Now, "扫码核销");
            }
            else
            {
                card.Use(DateTime.Now);
            }
            msg = "相关卡券已经核销成功。";
        }

        orderId = int.Parse(task._fields["associate_order_id"].ToString());
        if (orderId > 0)
        {
            Response.Redirect("/payment/payment.aspx?product_id=" + orderId.ToString(), true);
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
            <%=msg.Trim() %>
        </div>
    </form>
</body>
</html>
