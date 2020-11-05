<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        DataTable dt = DBHelper.GetDataTable(" select * from users where ISNUMERIC(open_id) = 0 and not exists(select 'a' from unionids where unionids.open_id = users.open_id and source = 'snowmeet_offical_account') ");
        foreach (DataRow dr in dt.Rows)
        {
            //string token = Util.GetToken().Trim();
            string token = "37_fsPg9Wm44liPRZJjqiphi04siI6kCLMg6SIXv36h01xRIW2QCp3Y0BnE2lOILZvZ2rvjLQ1qU3X4tEWLKTm64JVC6tL2gVForrlxnH3gl1gG373v6M3pAmFANCUAa72Vo9Gev2G9OqHOR9MTXJPdAAALXD";
            string openId = dr["open_id"].ToString().Trim();
            bool isnumeric = false;
            try
            {
                int.Parse(openId);
                isnumeric = true;
            }
            catch
            {

            }
            if (isnumeric)
            {
                continue;
            }
            string url = "https://api.weixin.qq.com/cgi-bin/user/info?access_token=" + token
                + "&openid=" + openId.Trim() + "&lang=zh_CN";
            string jsonStr = Util.GetWebContent(url);
            string unionId = "";
            try
            {
                unionId = Util.GetSimpleJsonValueByKey(jsonStr, "unionid");
            }
            catch
            {

            }
            if (!unionId.Trim().Equals(""))
            {
                try
                {
                    DBHelper.InsertData("unionids", new string[,]{ {"open_id", "varchar", openId.Trim() },
                        {"union_id", "varchar", unionId.Trim() }, {"source", "varchar", "snowmeet_official_account" } },
                    Util.conStr.Trim());
                }
                catch
                {

                }
            }
        }
    }
</script>