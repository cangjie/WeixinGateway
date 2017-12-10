<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    public string timeStamp = "";
    public string nonceStr = "e4bf6e00dd1f0br0fcab93bd5ae8f";
    public string ticketStr = "";
    public string shaParam = "";
    public string appId = System.Configuration.ConfigurationManager.AppSettings["wxappid"];


    public WeixinUser currentUser;
    public string openId = "";
    public Ticket ticket;

    protected void Page_Load(object sender, EventArgs e)
    {
        ticket = new Ticket(Util.GetSafeRequestValue(Request, "code", ""));

        string currentPageUrl = Server.UrlEncode("/pages/ticket_detail.aspx?code=" + ticket.Code);
        if (Session["user_token"] == null || Session["user_token"].ToString().Trim().Equals(""))
        {
            Response.Redirect("../authorize.aspx?callback=" + currentPageUrl, true);
        }
        string userToken = Session["user_token"].ToString();
        openId = WeixinUser.CheckToken(userToken);
        if (openId.Trim().Equals(""))
        {
            Response.Redirect("../authorize.aspx?callback=" + currentPageUrl, true);
        }
        currentUser = new WeixinUser(WeixinUser.CheckToken(userToken));

        if (currentUser.CellNumber.Trim().Equals("") || currentUser.VipLevel < 1)
            Response.Redirect("register_cell_number.aspx", true);
        /*
        if (!currentUser.IsBetaUser)
            Response.Redirect("beta_announce.aspx", true);
            */
        if (!currentUser.OpenId.Trim().Equals(ticket.Owner.OpenId))
        {
            Response.End();
        }

        timeStamp = Util.GetTimeStamp().Trim();
        ticketStr = Util.GetTicket();
        string shaString = "jsapi_ticket=" + ticketStr.Trim() + "&noncestr=" + nonceStr.Trim()
            + "&timestamp=" + timeStamp.Trim() + "&url=" + Request.Url.ToString().Trim();
        shaParam = Util.GetSHA1(shaString);
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <!-- 新 Bootstrap 核心 CSS 文件 -->
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="css/normalize.css" />
    <!-- 可选的Bootstrap主题文件（一般不用引入） -->
    <link rel="stylesheet" href="css/bootstrap-theme.min.css">
    <!-- jQuery文件。务必在bootstrap.min.js 之前引入 -->
    <script src="js/jquery.min.js"></script>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="js/bootstrap.min.js"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.2.0.js" ></script>
</head>
<body>
    <div style="margin-left: 5px" >
        <div id="ticket-<%=ticket.Code.Trim()%>" name="ticket" class="panel panel-info" style="width:350px"  >
            <div class="panel-heading">
                <h3 class="panel-title">代金券<%=Math.Round(ticket.Amount, 2).ToString() %>元&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;到期日：<%=ticket.ExpireDate.ToShortDateString() %></h3>
            </div>
            <div class="panel-body">
                    <%=ticket._fields["memo"].ToString().Trim() %>
                <br />
                <div style="text-align:center" >
                    <img src="../show_qrcode.aspx?sceneid=3<%=ticket.Code %>" style="width:200px; text-align:center"  />
                    <br />
                    <b style="text-align:center" ><%=ticket.Code.Substring(0,3) %>-<%=ticket.Code.Substring(3,3) %>-<%=ticket.Code.Substring(6,3) %></b>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
<script type="text/javascript" >

    var weixin_ready = false;
    
    var shareUrl = '';

    var title = '';
    
    var imgUrl = '';

     wx.config({
            debug: false, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
            appId: '<%=appId%>', // 必填，公众号的唯一标识
            timestamp: '<%=timeStamp%>', // 必填，生成签名的时间戳
            nonceStr: '<%=nonceStr%>', // 必填，生成签名的随机串
            signature: '<%=shaParam %>', // 必填，签名，见附录1
            jsApiList: [
                    'onMenuShareTimeline',
                    'onMenuShareAppMessage']
        });
    wx.ready(function () {
        //alert("ready");
        weixin_ready = true;
        render_page();
    });
    wx.error(function () {
        alert("error");
    });

    wx.onMenuShareAppMessage({

        title: title, // 分享标题

        desc: '', // 分享描述

        link: shareUrl, // 分享链接，该链接域名或路径必须与当前页面对应的公众号JS安全域名一致

        imgUrl: imgUrl, // 分享图标

        type: 'link', // 分享类型,music、video或link，不填默认为link

        dataUrl: '', // 如果type是music或video，则要提供数据链接，默认为空

        success: function () {

            // 用户确认分享后执行的回调函数
            alert("share");
        },

        cancel: function () {

            // 用户取消分享后执行的回调函数

        }

    });


    function render_page() {
        shareUrl = '<%=Request.Url.Authority.Trim() %>/pages/ticket_transfer.aspx?code=<%=ticket.Code.Trim()%>&fatheropenid=<%=openId.Trim()%>';
        title = '易龙雪聚测试券';
        imgUrl = 'https://mmbiz.qlogo.cn/mmbiz_jpg/pibCAzzGRCmPEQ0Zgvf2K7evvuY23Stw2lQ99EiaOoSzsiaJicFGXNpIq7eUHssUlibnGrNDBSFzNCOu9EDj3Fzicvzg/0?wx_fmt=jpeg';
    }
</script>