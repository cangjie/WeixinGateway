<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {

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
    </div>
</body>
</html>
