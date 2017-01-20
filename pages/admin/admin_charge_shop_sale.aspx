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
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="../js/bootstrap.min.js"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
</head>
<body>
    <table class="table table-striped">
        <tr>
            <td>市场价：</td>
            <td><input type="text" class="form-control" /></td>
        </tr>
        <tr>
            <td>成交价：</td>
            <td><input type="text" class="form-control" /></td>
        </tr>
        <tr>
            <td>使用代金券：</td>
            <td><input type="text" class="form-control" /></td>
        </tr>
        <tr>
            <td>实际支付金额：</td>
            <td><input type="text" class="form-control" /></td>
        </tr>
        <tr>
            <td colspan="2"><button type="button" class="btn btn-default" style="align-items:center">获取支付二维码</button></td>
        </tr>
        <tr>
            <td colspan="2" ></td>
        </tr>
    </table>
</body>
</html>
