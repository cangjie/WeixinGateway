<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">
    
    public string openId = "";
    public string currentOpenId = "oUuHnwdEI_wjigglCwuQwwzbGt-M";
    public int articleId = 0;
    public string title = "";
    public string dateString = "2016-4-1";
    public string content = "";
    
    public string timeStamp = "";
    public string nonceStr = "s4ef6e21d1f0br01sadfasdf23fcw55b93ba9fd";
    public string ticket = "";
    public string shaParam = "";
    public string appId = System.Configuration.ConfigurationManager.AppSettings["wxappid"];

    public bool qrCodeOnHead = true;

    public bool isMyself = false;

    protected void Page_Load(object sender, EventArgs e)
    {
        timeStamp = Util.GetTimeStamp();
        ticket = Util.GetTicket();
        string shaString = "jsapi_ticket=" + ticket.Trim() + "&noncestr=" + nonceStr.Trim()
            + "&timestamp=" + timeStamp.Trim() + "&url=" + Request.Url.ToString().Trim();
        shaParam = Util.GetSHA1(shaString);

        articleId = int.Parse(Util.GetSafeRequestValue(Request, "articleid", "9"));

        Article article = new Article(articleId);
        title = article.Title.Trim();
        content = article.Content.Trim();

        if (article._fields["display_qrcode_on_top"].ToString().Trim().Equals("1"))
        {
            qrCodeOnHead = true;
        }
        else
        {
            qrCodeOnHead = false;
        }
        
        dateString = article.CreateDate.ToShortDateString();

        openId = Util.GetSafeRequestValue(Request, "userid", "");


        //Session["user_token"] = "aaa";
        
        if (Session["user_token"] == null || Session["user_token"].ToString().Trim().Equals(""))
        {

            Response.Redirect("../authorize.aspx?callback=" + Server.UrlEncode("pages/show_content.aspx?articleid="
                + articleId.ToString() + "&userid=" + openId.ToString()), true);
        }
        else
        {
            currentOpenId = WeixinUser.CheckToken(Session["user_token"].ToString());
            if (currentOpenId.Trim().Equals(""))
            {
                Response.Redirect("../authorize.aspx?callback=" + Server.UrlEncode("pages/show_content.aspx?articleid="
                + articleId.ToString() + "&userid=" + openId.ToString()), true);
            }
            else
            {
                if (currentOpenId.Trim().Equals(openId.Trim()) || openId.Trim().Equals(""))
                {
                    isMyself = true;
                }
            }
        }

        UserAction.AddUserAction(currentOpenId, articleId.ToString(), openId.Trim(), 0, "read");

    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=0" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-mobile-web-app-status-bar-style" content="black" />
    <meta name="format-detection" content="telephone=no" />
    <script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js" ></script>
    <link rel="dns-prefetch" href="//res.wx.qq.com" />
    <link rel="dns-prefetch" href="//mmbiz.qpic.cn" />
    <link rel="shortcut icon" type="image/x-icon" href="http://res.wx.qq.com/mmbizwap/zh_CN/htmledition/images/icon/common/favicon22c41b.ico" />
    <link rel="stylesheet" type="text/css" href="css/css1.css" />
    <link rel="stylesheet" type="text/css" href="css/css2.css" />
    <script type="text/javascript" src="../js/jquery-1.3.2.min.js" ></script>
    <title></title>
</head>
<body id="activity-detail" class="zh_CN mm_appmsg not_in_mm" ontouchstart="" >
    
        <script type="text/javascript" >

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

        </script>

        <div class="rich_media" id="js_article">
        
        <div class="top_banner" id="js_top_ad_area">
 
        </div>
                

        <div class="rich_media_inner">
            <div id="page-content">
                <div class="rich_media_area_primary" id="img-content">
                    <h2 class="rich_media_title" id="activity-name">
                        <%=title.Trim() %>
                    </h2>
                    <div class="rich_media_meta_list">
                        						                        <em class="rich_media_meta rich_media_meta_text" id="post-date"><%=dateString %></em>

                                                <a class="rich_media_meta rich_media_meta_link rich_media_meta_nickname" id="post-user" href="javascript:void(0);">瑞精舍</a>
                        <span class="rich_media_meta rich_media_meta_text rich_media_meta_nickname">瑞精舍<%//=Session["user_token"].ToString().Trim() %></span>

                      
                    </div>
                    
                    
                    
                    
                                                            
                                                            
                    
                    <div class="rich_media_content " id="js_content">
                        
                        <p style="color: rgb(62, 62, 62);  text-align:center;  line-height: 25.6px; white-space: pre-line; -ms-word-wrap: break-word !important; min-height: 1em; max-width: 100%; box-sizing: border-box !important; background-color: rgb(255, 255, 255);">

                            <%
                                if (!qrCodeOnHead)
                            {
                            %>
                            
                            <%=content %>
                            <%} %><div style="text-align:center" ><%if (isMyself)
                              {
                            %><b><font color="red" >将此文分享至朋友圈后，如果你的朋友识别此二维码关注了我们，你可以获得精油试用装哦。</font></b><%
                              }
                              else
                              {%><b><font color="red" >长按识别此二维码可索取精油试用装。</font></b><%
                            }
                              WeixinUser user = new WeixinUser();
                              
                              WeixinUser currentUser = new WeixinUser(currentOpenId);
                              
                                if (openId.Trim().Equals(""))
                                {%><img  align="center" src="../images/qrcode/qrcode.jpg" /><%}
                                  else
                                  {
                                    try
                                    {
                                    user = new WeixinUser(openId);
                                   
                                 %><img  src="../show_qrcode.aspx?sceneid=<%=user.QrCodeSceneId.ToString() %>" /><%
                            }
                            catch
                            {
                            %><img align="center" src="../images/qrcode/qrcode.jpg" /><%
                            }
                            } %></div><%
                            
                            if (qrCodeOnHead)
                            {
                            %>
                            
                            <%=content %>
                            <%} %>
                        </p>
                    </div>
                    <script type="text/javascript">
                        var first_sceen__time = (+new Date());

                        if ("" == 1 && document.getElementById('js_content'))
                            document.getElementById('js_content').addEventListener("selectstart", function (e) { e.preventDefault(); });

                        (function () {
                            if (navigator.userAgent.indexOf("WindowsWechat") != -1) {
                                var link = document.createElement('link');
                                var head = document.getElementsByTagName('head')[0];
                                link.rel = 'stylesheet';
                                link.type = 'text/css';
                                link.href = "css/css4.css";
                                head.appendChild(link);
                            }
                        })();
                    </script>
                    
                    
                    
                                        
                                        
                                        <link href="css/css3.css" rel="stylesheet" type="text/css">



                                    </div>

                

                
               
            </div>
            

        </div>
    </div>
    <%
        Article article = new Article(articleId);
         %>
    <script type="text/javascript" >

        var shareUrl = "http://<%=System.Configuration.ConfigurationSettings.AppSettings["domain_name"].Trim()
    %>/pages/show_content.aspx?articleid=<%=articleId.ToString()%>&userid=<%=currentOpenId%>";
        var shareTitle = "<%=article.Title.Trim()%>";
        var shareImage = "<%=article.Image.Trim()%>";

       
        

        wx.ready(function () {

            wx.onMenuShareTimeline({
                title: shareTitle, // 分享标题
                link: shareUrl, // 分享链接
                imgUrl: shareImage, // 分享图标
                success: function () {
                    // 用户确认分享后执行的回调函数
                    $.ajax({
                        type: "GET",
                        async: false,
                        url: "../api/user_action_register.aspx?token=<%=Session["user_token"].ToString()%>&actionname=sharemoment&articleid=<%=articleId.ToString()%>&openid=<%=openId%>&sceneid=0",
                        success: function() {
                            //alert("aaa");
                        }
                    });
                }
            });

            wx.onMenuShareAppMessage({
                title: shareTitle, // 分享标题
                desc: "识别最下方二维码，关注公众号后转发或者分享到朋友圈，你也可以得酸奶哦。", // 分享描述
                link: shareUrl, // 分享链接
                imgUrl: shareImage, // 分享图标
                success: function () {
                    // 用户确认分享后执行的回调函数
                    //alert("success");
                    $.ajax({
                        type: "POST",
                        async: false,
                        url: "../api/user_action_register.aspx",
                        data: {
                            token: "<%=Session["user_token"].ToString()%>",
                            actionname: "forward",
                            articleid: "<%=articleId.ToString()%>",
                            openid: "<%=openId%>",
                            sceneid: "0"
                        }
                    });

                }
            });


        });

      

        

        /*
        wx.ready(function () {

            wx.onMenuShareTimeline({
                title: shareTitle, // 分享标题
                link: shareLink, // 分享链接
                imgUrl: shareImg, // 分享图标
                success: function () {
                    // 用户确认分享后执行的回调函数
                    //shareSuccess();
                    alert("success");
                }
            });

            wx.onMenuShareAppMessage({
                title: shareTitle, // 分享标题
                desc: "", // 分享描述
                link: shareLink, // 分享链接
                imgUrl: shareImg, // 分享图标
                success: function () {
                    // 用户确认分享后执行的回调函数
                    alert("success");

                }
            });

        });*/
    </script>
    
     
</body>
</html>
