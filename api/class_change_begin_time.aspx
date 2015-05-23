<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string token = Util.GetSafeRequestValue(Request, "token", "");

        int classId = int.Parse(Util.GetSafeRequestValue(Request, "classid", ""));

        DateTime beginTime = DateTime.Parse(Util.GetSafeRequestValue(Request, "begintime", "2015-6-1"));

        WeixinUser operatorUser = new WeixinUser(WeixinUser.CheckToken(token));

        if (operatorUser.IsAdmin)
        {
            Class cls = new Class(classId);
            cls.BeginTime = beginTime;
            Response.Write("{\"status\":0 }");
                
        }
        else
        {
            Response.Write("{\"status\":1, \"message\":\"error\" }");
        }
       
    }
</script>