<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <!-- 新 Bootstrap 核心 CSS 文件 -->
    <link rel="stylesheet" href="../../css/bootstrap.min.css">
    <link rel="stylesheet" href="css/normalize.css" />
    <!-- 可选的Bootstrap主题文件（一般不用引入） -->
    <link rel="stylesheet" href="../../css/bootstrap-theme.min.css">
    <!-- jQuery文件。务必在bootstrap.min.js 之前引入 -->
    <script src="../../js/jquery.min.js"></script>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="../../js/bootstrap.min.js"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
</head>
<body>
    <div>
        顾客手机号码：<input id="cell" type="text" /> <input type="button" value=" 确 认 " onclick="go_to_step_1()" />
    </div>
    <script type="text/javascript" >
        function go_to_step_1() {
            var cell = document.getElementById("cell").value.trim();
            window.location.href = 'admin_maintain_accept.aspx?cell=' + cell;
        }
    </script>
</body>
</html>
