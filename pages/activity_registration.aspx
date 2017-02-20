<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {

    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <!-- 新 Bootstrap 核心 CSS 文件 -->
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="css/normalize.css" />
    <!-- 可选的Bootstrap主题文件（一般不用引入） -->
    <link rel="stylesheet" href="css/bootstrap-theme.min.css">
    <!-- jQuery文件。务必在bootstrap.min.js 之前引入 -->
    <script src="js/jquery.min.js"></script>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="js/bootstrap.min.js"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <script type="text/javascript" >
        function launch_add_person_modal() {
            $("#booking_modal").modal();
        }
    </script>
</head>
<body>
    <div><h1>2017-3-10~2017-3-12 第三期北大湖活动（预付款1500元/人起）</h1></div>
    <div>共xxx人参加活动，其中xxx人租板，需要预先缴纳xxx元。<div><button type="button" class="btn btn-success" >现在支付</button></div></div>
    <div class="panel panel-danger" >
        <div class="panel-heading"><h3 class="panel-title">联系人</h3></div>
        <div class="panel-body" >
            <div class="row" >
                <div class="col-xs-4" >姓名：</div>
                <div class="col-xs-8" ><input type="text" /></div>
            </div>
            <div class="row" >
                <div class="col-xs-4" >电话：</div>
                <div class="col-xs-8" ><input type="text" /></div>
            </div>
            <div class="row" >
                <div class="col-xs-4" >身份证：</div>
                <div class="col-xs-8" ><input type="text" /></div>
            </div>
            <div class="row" >
                <div class="col-xs-4" ></div>
                <div class="col-xs-8" ><input type="checkbox" />我要租板</div>
            </div>
            <div class="row" >
                <div class="col-xs-4" >身高：</div>
                <div class="col-xs-8" ><input type="text" /></div>
            </div>
            <div class="row" >
                <div class="col-xs-4" >鞋码：</div>
                <div class="col-xs-8" ><input type="text" /></div>
            </div>
        </div>
    </div>
    <div><button type="button" class="btn btn-primary" onclick="launch_add_person_modal()" >添加雪友</button></div>
    <div><br /></div>
    <div class="panel panel-info" >
        <div class="panel-heading"><h3 class="panel-title">联系人</h3></div>
        <div class="panel-body" >
            <div class="row" >
                <div class="col-xs-4" >姓名：</div>
                <div class="col-xs-8" ></div>
            </div>
            <div class="row" >
                <div class="col-xs-4" >电话：</div>
                <div class="col-xs-8" ></div>
            </div>
            <div class="row" >
                <div class="col-xs-4" >身份证：</div>
                <div class="col-xs-8" ></div>
            </div>
            <div class="row" >
                <div class="col-xs-4" ></div>
                <div class="col-xs-8" ><input type="checkbox" />我要租板</div>
            </div>
            <div class="row" >
                <div class="col-xs-4" >身高：</div>
                <div class="col-xs-8" ></div>
            </div>
            <div class="row" >
                <div class="col-xs-4" >鞋码：</div>
                <div class="col-xs-8" ></div>
            </div>
        </div>
    </div>
    <div id="booking_modal" class="modal fade bs-example-modal-lg" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header" id="modal-header" >添加同行雪友</div>
                <div class="modal-body" >
                    <div class="row" >
                        <div class="col-xs-4" >姓名：</div>
                        <div class="col-xs-8" ></div>
                    </div>
                    <div class="row" >
                        <div class="col-xs-4" >电话：</div>
                        <div class="col-xs-8" ></div>
                    </div>
                    <div class="row" >
                        <div class="col-xs-4" >身份证：</div>
                        <div class="col-xs-8" ></div>
                    </div>
                    <div class="row" >
                        <div class="col-xs-4" ></div>
                        <div class="col-xs-8" ><input type="checkbox" />我要租板</div>
                    </div>
                    <div class="row" >
                        <div class="col-xs-4" >身高：</div>
                        <div class="col-xs-8" ></div>
                    </div>
                    <div class="row" >
                        <div class="col-xs-4" >鞋码：</div>
                        <div class="col-xs-8" ></div>
                    </div>
                </div>    
            </div>
        </div>
    </div>
</body>
</html>
