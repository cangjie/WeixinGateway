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
<body>
    <div class="row" >
        <div id="article_list" class="list-group">
            <a href="#" class="list-group-item">
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
                + "<a href=\"show_content.aspx?articleid=" + article_array_json.article_array[i].article_id + "\" class=\"list-group-item\">"
                + "<h4 class=\"list-group-item-heading\">" + article_array_json.article_array[i].article_title + "</h4>"
                + "<p class=\"list-group-item-text\">" + ((article_array_json.article_array[i].shared == 0) ? "未" : "已") + "分享&nbsp;&nbsp;&nbsp;&nbsp;"
                + "阅读数：" + article_array_json.article_array[i].read_num + "&nbsp;&nbsp;&nbsp;&nbsp;分享数：" + article_array_json.article_array[i].share_num + "</p>"
                + "</a>";
        }

    </script>
</body>
</html>
