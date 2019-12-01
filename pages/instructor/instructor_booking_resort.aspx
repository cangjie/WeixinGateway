<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    public WeixinUser currentUser;

    public string openId = "";

    public string userToken = "";

    public Product[] prodArr = Product.GetInstructorProduct();

    protected void Page_Load(object sender, EventArgs e)
    {
        string currentPageUrl = Request.Url.ToString().Split('?')[0].Trim();
        if (!Request.QueryString.ToString().Trim().Equals(""))
        {
            currentPageUrl = currentPageUrl + "?" + Request.QueryString.ToString().Trim();
        }

        if (Session["user_token"] == null || Session["user_token"].ToString().Trim().Equals(""))
        {
            Response.Redirect("../authorize.aspx?callback=" + currentPageUrl, true);
        }
        userToken = Session["user_token"].ToString();

        //userToken = "efa86b2cb53ff14b4500298208effda1652c863ac117668953d4ef93f807351b4ff11040";
        openId = WeixinUser.CheckToken(userToken);
        if (openId.Trim().Equals(""))
        {
            Response.Redirect("../authorize.aspx?callback=" + currentPageUrl, true);
        }
        currentUser = new WeixinUser(WeixinUser.CheckToken(userToken));
        if (!currentUser._fields["is_instructor"].ToString().Trim().Equals("1"))
        {
            Response.End();
        }

        
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <!-- 新 Bootstrap 核心 CSS 文件 -->
    <link rel="stylesheet" href="../css/bootstrap.min.css">
    <link rel="stylesheet" href="../css/normalize.css" />
    <!-- 可选的Bootstrap主题文件（一般不用引入） -->
    <link rel="stylesheet" href="../css/bootstrap-theme.min.css">
    <!-- jQuery文件。务必在bootstrap.min.js 之前引入 -->
    <script src="../js/jquery.min.js"></script>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="../js/bootstrap.min.js"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
</head>
<body>

    <div>
        <ul class="nav nav-tabs" >
            <li class="nav-item" ><a class="nav-link active" href="instructor_booking_resort.aspx" >场地预约</a></li>
        </ul>

    </div>
     <%
            foreach (Product p in prodArr)
            {
             %>
        <br />
        <div id="ticket-1" name="ticket" class="panel panel-success" style="width:350px" onclick="launch_book_modal('<%=p._fields["id"].ToString().Trim() %>')" >
            <div class="panel-heading">
                <h3 class="panel-title"><%=p._fields["name"].ToString() %></h3>
            </div>
            <div class="panel-body">
                价格：<%=p.SalePrice.ToString()%><br />
                <%=p._fields["intro"].ToString().Trim() %>
            </div>
        </div>
        <%} %>
    <script type="text/javascript" >
        function launch_book_modal(product_id) {

        }
    </script>
</body>
</html>
