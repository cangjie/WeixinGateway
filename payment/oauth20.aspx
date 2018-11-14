<%@ Page Language="C#" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>
<!DOCTYPE html>

<script runat="server">

    public string s = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        string code = Request["code"].Trim();
        string url = "https://api.weixin.qq.com/sns/oauth2/access_token?appid="
            + System.Configuration.ConfigurationSettings.AppSettings["wxappid"].Trim() + "&secret=" 
            +System.Configuration.ConfigurationSettings.AppSettings["wxappsecret"].Trim() + "&code=" 
            + code + "&grant_type=authorization_code";
        HttpWebRequest req = (HttpWebRequest)WebRequest.Create(url);
        HttpWebResponse res = (HttpWebResponse)req.GetResponse();
        s = (new StreamReader(res.GetResponseStream())).ReadToEnd();
        res.Close();
        req.Abort();

        

        if (!s.Trim().Equals(""))
        {
            try
            {
                Session["user_access_token"] = Util.GetSimpleJsonValueByKey(s, "access_token");
            }
            catch (Exception err)
            {
                Response.Write(err.ToString());
                Response.End();
            }
            try
            {
                Session["user_refresh_token"] = Util.GetSimpleJsonValueByKey(s, "refresh_token");
            }
            catch (Exception err)
            {
                Response.Write(err.ToString());
                Response.End();
            }
            try
            {
                Session["user_open_id"] = Util.GetSimpleJsonValueByKey(s, "openid");
            }
            catch(Exception err)
            {
                Response.Write(err.ToString());
                //File.AppendAllText(Server.MapPath("log/jsonpay.txt"), s + "\r\n");
                Response.End();
            }
            
        }
        
        string action = "";

        string stateStr = Request["state"] == null ? "" : Request["state"].Trim();

        foreach (string ss in stateStr.Split('|'))
        {
            if (ss.StartsWith("action:"))
            {
                action = ss.Split(':')[1].Trim();
                break;
            }
        }

        switch (action)
        { 
            case "payment":
                Response.Redirect("payment.aspx?state=" + stateStr.Trim());
                break;
            default:
                break;
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
        <%=s %><br />
        <%=Request["state"].Trim() %>
    </div>
    </form>
</body>
</html>
