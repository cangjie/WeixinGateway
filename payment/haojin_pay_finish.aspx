<%@ Page Language="C#" %>
<%@ Import Namespace="System.IO" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        int orderId = int.Parse(Util.GetSafeRequestValue(Request, "orderid", "0"));
        string openId = WeixinUser.CheckToken(Session["user_token"].ToString());
        OnlineOrder order = new OnlineOrder(orderId);
        if (order._fields["open_id"].ToString().Trim().Equals(openId.Trim()))
        {
            if (order.Type.Trim().Equals("雪票"))
            {
                //order.CreateSkiPass();
                Response.Redirect("../pages/ski_pass_list.aspx", true);
            }
            else
            {
                Response.Redirect("../pages/dragon_ball_list.aspx", true);
            }
        }

    }
</script>