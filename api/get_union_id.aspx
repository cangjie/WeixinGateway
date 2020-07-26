<%@ Page Language="C#" %>
<<%@ Import Namespace="System.Data" %>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        string openId = Util.GetSafeRequestValue(Request, "openid", "");
        DataTable dt = DBHelper.GetDataTable(" select * from unionid where official_account_open_id = '" + openId.Trim() + "' ");
        string unionId = "";
        if (dt.Rows.Count > 0)
        {
            unionId = dt.Rows[0]["union_id"].ToString().Trim();
        }
        dt.Dispose();
        if (unionId.Trim().Equals(""))
        {
            string accessToken = Util.GetToken();
            string url = "https://api.weixin.qq.com/sns/userinfo?access_token=" + accessToken.Trim()
                + "&openid=" + openId.Trim() + "&lang=zh_CN";
            string jsonStr = Util.GetWebContent(url);
            try
            {
                unionId = Util.GetSimpleJsonValueByKey(jsonStr, "unionid");
            }
            catch
            {

            }
            if (!unionId.Trim().Equals(""))
            {
                dt = DBHelper.GetDataTable(" select * from unionid where union_id = '" + unionId.Trim() + "'  ");
                if (dt.Rows.Count > 0)
                {
                    DBHelper.UpdateData("unionid", new string[,] { { "official_account_open_id", "varchar", openId.Trim() } },
                        new string[,] { { "union_id", "varchar", unionId.Trim() } }, Util.conStr.Trim());
                }
                else
                {
                    DBHelper.InsertData("unionid", new string[,] { { "union_id", "varchar", unionId.Trim() }, 
                        { "official_account_open_id", "varchar", openId.Trim() } });
                }
            }
        }
        Response.Write(unionId.Trim());


    }
</script>