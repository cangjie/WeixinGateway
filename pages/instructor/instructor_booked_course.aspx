<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    public WeixinUser currentUser;

    public string openId = "";

    public string userToken = "";

    public Course[] myCourseArr;// = Course.GetOnlieCourseByOwnerOpenId

    protected void Page_Load(object sender, EventArgs e)
    {
        string currentPageUrl = Request.Url.ToString().Split('?')[0].Trim();
        if (!Request.QueryString.ToString().Trim().Equals(""))
        {
            currentPageUrl = currentPageUrl + "?" + Request.QueryString.ToString().Trim();
        }

        if (Session["user_token"] == null || Session["user_token"].ToString().Trim().Equals(""))
        {
            Response.Redirect("../../authorize.aspx?callback=" + currentPageUrl, true);
        }
        userToken = Session["user_token"].ToString();

        openId = WeixinUser.CheckToken(userToken);
        if (openId.Trim().Equals(""))
        {
            Response.Redirect("../../authorize.aspx?callback=" + currentPageUrl, true);
        }
        currentUser = new WeixinUser(WeixinUser.CheckToken(userToken));
        if (!currentUser._fields["is_instructor"].ToString().Trim().Equals("1"))
        {
            Response.End();
        }

        myCourseArr = Course.GetOnlieCourseByOwnerOpenId(openId.Trim());
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
    <script type="text/javascript" src="../js/popper.min.js" ></script>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="../js/bootstrap.min.js"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
</head>
<body>
    <div>
        <ul class="nav nav-tabs" >
            <li class="nav-item" ><a class="nav-link" href="instructor_booking_resort.aspx" >场地预约</a></li>
            <li class="nav-item" ><a class="nav-link active" href="instructor_booked_course.aspx" >我的课程</a></li>
        </ul>
        <%
            foreach (Course c in myCourseArr)
            {
                Product p = new Product(c.associateOnlineOrderDetail.productId);
                %>
        <div id="ticket-1" name="ticket" class="card" style="width:350px" onclick="go_to_detail('<%=c.associateOnlineOrder._fields["id"].ToString().Trim() %>','<%=c.cardCode %>')" >
            <div class="card-header">
                <h3 class="card-title"><%=p._fields["name"].ToString() %></h3>
            </div>
            <div class="card-body">
                时间：<%=c.AppointDate.ToShortDateString() %> 人数：1
            </div>
        </div>
                    <%
            }
             %>
    </div>
    <script type="text/javascript" >
        function go_to_detail(order_id, card_code) {
            window.location.href = "course_detail.aspx?orderid=" + order_id + "&code=" + card_code;
        }
    </script>
</body>
</html>
