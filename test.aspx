<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Xml" %>
<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string verifyCode = "123456";
        //您的验证码为@，请在规定的时间输入。【易龙雪聚】
        int smsId = Sms.SaveSms("18601197897", "您的验证码为" + verifyCode.Trim() + "，请在规定的时间输入。【易龙雪聚】", true, verifyCode);
        Sms sms = new Sms(smsId);
        sms.Send();
    }



</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <!--test conflict-->
    </div>
    </form>
</body>
</html>
