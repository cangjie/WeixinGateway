<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    public string currentOpenId = "oUuHnwXMB0fjGSH1CEv8jJDr3CRQ";
    public WeixinUser currentUser;
    //public string userToken = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        //Session["user_token"] = "7777e297508f30411a2c5d443b2d4e9696c8dfd8d2141f556744efff82e27988516cc04f";
        if (Session["user_token"] == null || Session["user_token"].ToString().Trim().Equals(""))
        {

            Response.Redirect("../authorize.aspx?callback=" + Server.UrlEncode("pages/registration.aspx"), true);
        }
        else
        {
            currentOpenId = WeixinUser.CheckToken(Session["user_token"].ToString());
            if (currentOpenId.Trim().Equals(""))
            {
                Response.Redirect("../authorize.aspx?callback=" + Server.UrlEncode("pages/registration.aspx"), true);
            }
        }
        currentUser = new WeixinUser(currentOpenId.Trim());
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" />

    <!-- 新 Bootstrap 核心 CSS 文件 -->
    <link rel="stylesheet" href="css/bootstrap.min.css" />

    
    <!-- jQuery文件。务必在bootstrap.min.js 之前引入 -->
    <script src="../js/jquery-1.12.3.min.js"></script>

    <script type="text/javascript" >

        var user_token = "<%=Session["user_token"].ToString().Trim()%>";

        var article_array_json;

        article_array_json = JSON.parse($.ajax({
            url: "../api/article_get_list.aspx?token=" + user_token,
            async: false,
            type: "get",
        }).responseText.trim());

    </script>
    
</head>
<body style="margin-left:15px;margin-top:0px">
    <div id="title" class="row"  >
       	<p id="followed_num" style="position:absolute; left:140px; top:120px" >
		关注人数：<%=currentUser.FollowedUsers.Rows.Count.ToString() %><br/>
		可领试用装：0<br/>
		已领试用装：0<br/>
		
	</p>
	    <!--p style="position:absolute;left:140px; top:140px" >积分：细则制定中<br/>积分可抵现金<br/>请努力转发</p-->
        <img src="<%=currentUser.HeadImage.Trim() %>"  class="img-circle" style="width:75px; position:absolute;top:10px;left:10px" >
        <img id="title_image" style="width:100%;height:100%" src="images/title_tree.jpg" />
    </div>
    <script type="text/javascript" >

        function locate_title() {
		window.orientation;
		//alert(document.body.clientWidth);
            var body_width = document.body.clientWidth;
            var followed_num = document.getElementById("followed_num");
            followed_num.style.left = (document.body.clientWidth * 1.2 / 3).toString() + "px";
            followed_num.style.top = (document.body.clientWidth / 3).toString() + "px";
        }

        locate_title();
	    window.addEventListener('orientationchange',locate_title,false);

    </script>
    <div class="row" style="background:url(images/split_title.jpg); height:28px" >
        
    </div>
    <div class="row" >
        <div id="article_list" class="col-md-12 list-group">
            <a href="#" class="list-group-item">
                <h4 class="list-group-item-heading">List group item heading</h4>
                <p class="list-group-item-text">...</p>
            </a>
            <a href="#" class="list-group-item" style="border:1px solid #337ab7;">
                <h4 class="list-group-item-heading">List group item heading</h4>
                <p class="list-group-item-text">...</p>
            </a>
            <a href="#" class="list-group-item">
                <h4 class="list-group-item-heading">List group item heading</h4>
                <p class="list-group-item-text">...</p>
            </a>
            <a href="#" class="list-group-item">
                <h4 class="list-group-item-heading">List group item heading</h4>
                <p class="list-group-item-text">...</p>
            </a>
        </div>
    </div>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="js/bootstrap.min.js"></script>
    <script type="text/javascript" >
        var article_list_node = document.getElementById("article_list");
        article_list_node.innerHTML = "";
        for (var i = 0 ; i < article_array_json.article_array.length; i++)
        {
            article_list_node.innerHTML = article_list_node.innerHTML
                + "<a href=\"show_content.aspx?articleid=" + article_array_json.article_array[i].article_id + "\" class=\"list-group-item\" style=\"border:1px solid #337ab7;\" >"
                + "<h4 class=\"list-group-item-heading\">" + article_array_json.article_array[i].article_title + "</h4>"
                + "<p class=\"list-group-item-text\">" + ((article_array_json.article_array[i].shared == 0) ? "未" : "已") + "分享&nbsp;&nbsp;&nbsp;&nbsp;"
                + "阅读数：" + article_array_json.article_array[i].read_num + "&nbsp;&nbsp;&nbsp;&nbsp;分享数：" + article_array_json.article_array[i].share_num + "</p>"
                + "</a>";
        }

    </script>
</body>
</html>
