<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {

    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>雪票产品维护-列表</title>
    <!-- 新 Bootstrap 核心 CSS 文件 -->
    <!--
    <link rel="stylesheet" href="../../css/bootstrap.min.css">
    <link rel="stylesheet" href="../../css/bootstrap.bundle.min.css">
    <link rel="stylesheet" href="../../css/normalize.css" />
    -->
    <!-- 可选的Bootstrap主题文件（一般不用引入） -->
    <!--
    <link rel="stylesheet" href="../../css/bootstrap-theme.min.css">
    -->
    <!-- jQuery文件。务必在bootstrap.min.js 之前引入 -->
    <!--
    <script src="../../js/jquery.min.js"></script>
    -->
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <!--
    <script src="../../js/bootstrap.min.js"></script>
    <script src="../../js/popper.js"></script>
    -->
    <link rel="stylesheet" href="https://cdn.bootcss.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
    <script src="https://cdn.bootcss.com/jquery/3.2.1/jquery.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
    <script src="https://cdn.bootcss.com/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
    <script src="https://cdn.bootcss.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
</head>
<body> 
    <div class="container">
        <div class="row">
            <div class="col-3" style="text-align:right">筛选：</div>
            <div class="col-9">
                <div class="dropdown">
                    <button class="btn btn-secondary btn-sm dropdown-toggle" type="button" id="dropdownMenuButton" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        所有的
                    </button>
                    <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                        <a class="dropdown-item" href="#">南山</a>
                        <a class="dropdown-item" href="#">八易</a>
                        <a class="dropdown-item" href="#">万龙</a>
                        <a class="dropdown-item" href="#">云顶</a>
                    </div>
                </div>
            </div>
        </div>
        <div class="row" >
            <br />
        </div>
        <div class="row" >
            <div class="col-sm  card" style="width:80%" >
                <div class="card-body">
                    <h5 class="card-title">南山-周末票</h5>
                    <h6 class="card-subtitle mb-2 text-muted">价格：200</h6>
                    <h6 class="card-subtitle mb-2 text-muted">租鞋+板:200 雪服+雪镜+头盔:100</h6>
                    <p class="card-text">上架时间：2019-9-1<br />下架时间：2020-5-1<br />使用时间：周六、周日<br />库存：无限制</p>
                    <a href="#" class="card-link">修改</a>
                </div>
            </div>
        </div>
        <div class="row" >
            <br />
        </div>
        <div class="row">
            <div class="col-sm  card" style="width:80%"  >
                <div class="card-body">
                    <h5 class="card-title">南山-元旦假日票</h5>
                    <h6 class="card-subtitle mb-2 text-muted">价格：200</h6>
                    <h6 class="card-subtitle mb-2 text-muted">租鞋+板:200 雪服+雪镜+头盔:不提供</h6>
                    <p class="card-text">上架时间：2019-9-1<br />下架时间：2020-5-1<br />使用时间：2019-12-31--2020-1-2<br />库存：无限制</p>
                    <a href="#" class="card-link">修改</a>
                </div>
            </div>
        </div>
        <div class="row" >
            <br />
        </div>
        <div class="row" >
            <div class="col-sm  card" style="width:80%"  >
                <div class="card-body">
                    <h5 class="card-title">八易-平日票</h5>
                    <h6 class="card-subtitle mb-2 text-muted">价格：200</h6>
                    <h6 class="card-subtitle mb-2 text-muted">租鞋+板:不提供 雪服+雪镜+头盔:不提供</h6>
                    <p class="card-text">上架时间：2019-9-1<br />下架时间：2020-5-1<br />使用时间：平日<br />库存：无限制</p>
                    <a href="#" class="card-link">修改</a>
                </div>
            </div>
        </div>
        <div class="row" >
            <br />
        </div>
        <div class="row" >
            <div class="col-sm card" style="width:80%"  >
                <div class="card-body">
                    <h5 class="card-title">万龙-大众比赛票</h5>
                    <h6 class="card-subtitle mb-2 text-muted">价格：200</h6>
                    <h6 class="card-subtitle mb-2 text-muted">租鞋+板:不提供 雪服+雪镜+头盔:不提供</h6>
                    <p class="card-text">上架时间：2019-9-1<br />下架时间：2020-5-1<br />使用时间：2019-12-1,2019-12-5<br />库存：100</p>
                    <a href="#" class="card-link">修改</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
