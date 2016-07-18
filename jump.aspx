<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string id = Util.GetSafeRequestValue(Request, "id", "00").Trim();
        string jumpUrl = "";
        switch(id)
        {
            case "00":
                jumpUrl = "http://mp.weixin.qq.com/s?__biz=MzI1MzE5OTE4Ng==&mid=402940913&idx=1&sn=b9af2488bdd66eb0296eb724f064449f&scene=18#wechat_redirect";
                break;
            case "10":
                jumpUrl = "http://mp.weixin.qq.com/s?__biz=MzI1MzE5OTE4Ng==&mid=402919926&idx=1&sn=19420903f58a645776fcfd91e604bedc&scene=18#wechat_redirect";
                break;
            case "12":
                jumpUrl = "http://mp.weixin.qq.com/s?__biz=MzI1MzE5OTE4Ng==&mid=403172205&idx=1&sn=23a631bf5bc7c067e49e029b99103ff3&scene=18#wechat_redirect";
                break;
            case "21":
                jumpUrl = "http://mp.weixin.qq.com/s?__biz=MzI1MzE5OTE4Ng==&mid=402949476&idx=1&sn=f34a8c554d18f9fe49442a0d2f3c5df2&scene=18#wechat_redirect";
                break;
            default:
                jumpUrl = "http://mp.weixin.qq.com/s?__biz=MzI1MzE5OTE4Ng==&mid=402949476&idx=1&sn=f34a8c554d18f9fe49442a0d2f3c5df2&scene=18#wechat_redirect";
                break;
        }
        Response.Redirect(jumpUrl);
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
    </div>
    </form>
</body>
</html>
