<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    public WeixinUser currentUser;

    public string userToken = "";

    public string openId = "";

    public SecondKill secondKillItem;

    public int id;

    public bool success = false;

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
        if (openId.Trim().Equals(""))
        {
            Response.Redirect("../authorize.aspx?callback=" + currentPageUrl, true);
        }
        currentUser = new WeixinUser(WeixinUser.CheckToken(userToken));


        id = int.Parse(Util.GetSafeRequestValue(Request, "id", "64"));
        bool existsInMemory = true;
        string applicationHandle = "second_kill_" + id.ToString();
        if (Application[applicationHandle] == null)
        {
            existsInMemory = false;
        }
        else
        {
            try
            {
                secondKillItem = (SecondKill)Application[applicationHandle];
            }
            catch
            {
                existsInMemory = false;
            }
        }
        if (!existsInMemory)
        {
            secondKillItem = new SecondKill(id);
            Application.Lock();
            Application[applicationHandle] = secondKillItem;
            Application.UnLock();
        }
        SecondKill.SecondKillRecord[] skrArr = secondKillItem.secondKillRecordList.ToArray();
        foreach (SecondKill.SecondKillRecord skr in skrArr)
        {
            if (skr.openId.Trim().Equals(openId.Trim()))
            {
                success = true;
                break;
            }
        }
        if (success)
        {
            orderId = secondKillItem.PlaceOnlineSecondKillOrder(openId);
            if (orderId > 0)
            {
                Response.Redirect("/payment/payment.aspx?product_id=" + orderId.ToString().Trim());
            }
            else
            {

            }
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
        Token=<%=userToken.Trim() %><br />
        OpenId=<%=openId.Trim() %><br />
        OrderId=<%=orderId %>
    </div>
    </form>
</body>
</html>
