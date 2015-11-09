<%@ Page Language="C#" %>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        string token = Util.GetSafeRequestValue(Request, "token", "");
        string openId = WeixinUser.CheckToken(token);
        openId = "oLhvQt75XLvs0Zeo_qWoeZIEGGM8";
        
        
        if (openId.Trim().Equals(""))
        {
            Response.Write("{\"status\" : 1, \"message\" : \"Token unavailable\"}");
            Response.End();
        }
        string name = Util.GetSafeRequestValue(Request, "name", "");
        string school = Util.GetSafeRequestValue(Request, "school", "");
        string major = Util.GetSafeRequestValue(Request, "major", "");
        string role = Util.GetSafeRequestValue(Request, "role", "parent");
        DateTime checkinDate = DateTime.Parse(Util.GetSafeRequestValue(Request, "checkin_date", "1900-1-1"));

        int familyId = WeixinUser.RegisterFamily(school, major, checkinDate);
        bool ret = false;
        if (familyId > 0)
        {
            WeixinUser user = new WeixinUser(openId);
            ret = user.RegisterFamilyMember((role.Trim().Equals("child")?true:false), familyId, name);
        }
        Response.Write("{\"status\": " + (ret ? "0" : "1") + " , \"family_id\" : " + familyId.ToString().Trim() + "  } ");
    }
</script>