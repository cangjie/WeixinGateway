<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <!--script src="docs/js/jquery.min.js"></!--script>
    <script src="docs/js/bootstrap.min.js"></script>
    <script src="docs/js/highlight.js"></script>
    <script src="dist/js/bootstrap-switch.min.js"></script>
    <script src="docs/js/main.js"></script-->

    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" />

    <title></title>
    <link href="docs/css/bootstrap.min.css" rel="stylesheet" />
    <link href="docs/css/highlight.css" rel="stylesheet" />
    <link href="dist/css/bootstrap3/bootstrap-switch.css" rel="stylesheet" />
    <link href="http://getbootstrap.com/assets/css/docs.min.css" rel="stylesheet" />
    <link href="docs/css/main.css" rel="stylesheet" />
    <link href="docs/css/bootstrap-datetimepicker.min.css" rel="stylesheet" media="screen" />
</head>
<body>
    <form id="form1" runat="server">
    <div class="form-horizontal" >
        <div class="form-group">
            <label for="inputEmail3" class="col-sm-2 control-label">您是：</label>
            <div class="col-sm-10">
                <input id="switch-onText" type="checkbox" checked data-on-text="学生" data-off-text="家长" >  
            </div>
        </div>
        <div class="form-group">
            <label for="inputEmail3" class="col-sm-2 control-label">您的姓名：</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" style="width:150px" >  
            </div>
        </div>
        <div class="form-group">
            <label for="inputEmail3" class="col-sm-2 control-label">您要去的学校：</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" style="width:500px" >  
            </div>
        </div>
        <div class="form-group">
            <label for="inputEmail3" class="col-sm-2 control-label">您即将入学的专业：</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" style="width:500px" >  
            </div>
        </div>
        <div class="form-group">
            <label for="inputEmail3" class="col-sm-2 control-label">入学时间：</label>
            <div class="col-sm-10">
                <input type="text" value="2012-05-15" id="datetimepicker">
                 
            </div>
        </div>
    </div>
    </form>
   <script src="docs/js/jquery.min.js"></script>
    <script src="docs/js/bootstrap.min.js"></script>
    <script src="docs/js/highlight.js"></script>
    <script src="dist/js/bootstrap-switch.js"></script>
    <script src="docs/js/main.js"></script>
    <script type="text/javascript" src="docs/js/bootstrap-datetimepicker.js" charset="UTF-8"></script>
    <script type="text/javascript" src="docs/js/locales/bootstrap-datetimepicker.zh-CN.js" charset="UTF-8"></script>
    
    <script type="text/javascript" >

        $('#datetimepicker').datetimepicker({
            format: 'yyyy-mm-dd',
            minView: 2,
            autoClose: true
        });

    </script>
</body>
</html>
