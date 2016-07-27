<%@ Page Language="C#" %>


<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {

	string callBack = Util.GetSafeRequestValue(Request, "callback", "");
	


        if (Session["user_token"] != null && !Session["user_token"].ToString().Trim().Equals(""))
        {
            
            callBack = Server.UrlDecode(callBack);

		
            string token = Session["user_token"].ToString();
            if (callBack.IndexOf("?") > 0)
                callBack = callBack + "&token=" + token.Trim();
            else
                callBack = callBack + "?token=" + token.Trim();
            Response.Redirect(callBack);
        }
        else
        {
            Response.Redirect("authorize.aspx?callback=" + Util.GetSafeRequestValue(Request, "callback", ""), true);
        }
        
    }
</script>
