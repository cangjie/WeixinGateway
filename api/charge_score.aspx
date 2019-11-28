<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string token = Util.GetSafeRequestValue(Request, "token", "").Trim();
        int score = int.Parse(Util.GetSafeRequestValue(Request, "score", "0").Trim());
        string comment = Util.GetSafeRequestValue(Request, "comment", "").Trim();
        string msg = "";

        string openId = WeixinUser.CheckToken(token);
        if (openId.Trim().Equals(""))
        {
            msg = "找不到该用户。";
        }
        else
        {
            WeixinUser user = new WeixinUser(openId);
            if (user.Points < score)
            {
                msg = "龙珠余额不足。";
            }
            else
            {
                Point.AddNew(openId, score, DateTime.Now, comment.Trim());
            }
        }
        if (msg.Trim().Equals(""))
        {
            Response.Write("{\"status\": 0}");
        }
        else
        {
            Response.Write("{\"status\": 1, \"error_message\": \"" + msg.Trim() + "\"}");
        }
    }
</script>