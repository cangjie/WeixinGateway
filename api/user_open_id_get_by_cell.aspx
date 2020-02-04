<%@ Page Language="C#" %>
<%@ Import Namespace="System.Text.RegularExpressions" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string token = Util.GetSafeRequestValue(Request, "token", "af12f1206150547fbfc6694db2a4029982ccaf17e58738f670cb11dffc6312c1090656e4");
        string cell = Util.GetSafeRequestValue(Request, "cell", "13601277897");
        string adminUserOpenId = WeixinUser.CheckToken(token.Trim());
        if (adminUserOpenId.Trim().Equals(""))
        {
            Response.Write("{\"status\": 1, \"error_message\": \"Is not admin.\"}");
            Response.End();
        }
        WeixinUser adminUser = new WeixinUser(adminUserOpenId);
        if (adminUser.IsAdmin)
        {
            string[] openIdArr = WeixinUser.GetOpenIdByCellNumber(cell.Trim());
            string openId = "";
            string tempOpenId = "";
            foreach (string s in openIdArr)
            {
                if (Regex.IsMatch(s.Trim(), @"^-?\d+$"))
                {
                    tempOpenId = s.Trim();
                }
                else
                {
                    openId = s.Trim();
                }
            }
            if (openId.Trim().Equals("") && tempOpenId.Trim().Equals(""))
            {
                tempOpenId = WeixinUser.GetTempWeixinUser(cell.Trim()).OpenId.Trim();
            }
            Response.Write("{\"status\": 0, \"open_id\": \""+ openId.Trim() + "\", \"temp_open_id\": \"" + tempOpenId.Trim() + "\" }");
        }
        else
        {
            Response.Write("{\"status\": 1, \"error_message\": \"Is not admin.\"}");
        }
    }
</script>