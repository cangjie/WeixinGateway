<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        DataTable dt = DBHelper.GetDataTable(" select * from users where not exists(select 'a' from unionids where unionids.open_id = users.open_id and source = 'snowmeet_offical_account') ");
        foreach (DataRow dr in dt.Rows)
        {
            //string token = Util.GetToken().Trim();
            string token = "37_Bz8mYEqyJJlUqhWxc3E54UmIkGCO2Dic9pbaf8f2ezdqcN6u5WWfPL-Jj8sbm7MeVIr3QT01lv3lzGeu6_Mxhw0Ol3iHl7rA8nF0hx2a1gVqcASy-ixFzCMsyEgrptVOSzrLgoIUcJizOwiKLNXeAHATVF";
            string url = "https://api.weixin.qq.com/cgi-bin/user/info?access_token=" + token 
                + "&openid=" + dr["open_id"].ToString().Trim() + "&lang=zh_CN";

            string jsonStr = Util.GetWebContent(url);
        }
    }
</script>