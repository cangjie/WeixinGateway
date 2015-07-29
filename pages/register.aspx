<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    public string token = "a7319737ab87e79b9e651457c01ffec4274da233b0881e3a3ef91d9225acba6e9125f67f";
    
    public string openId = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        //Authorize();
        
    }

    public void Authorize()
    {
        token = Session["user_token"] == null ? "" : Session["user_token"].ToString();
        if (token.Trim().Equals(""))
        {
            Response.Redirect("../authorize.aspx?callback="
                + Server.UrlEncode(Request.Url.ToString().Trim()), true);
        }
        openId = WeixinUser.CheckToken(token);
        if (openId.Trim().Equals(""))
        {
            Response.Redirect("../authorize.aspx?callback="
                + Server.UrlEncode(Request.Url.ToString().Trim()), true);
        }
        token = Session["user_token"].ToString().Trim();
        openId = WeixinUser.CheckToken(token);
    }
        
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
    <link href="dist/css/bootstrap-switch.css" rel="stylesheet" />
    <link href="src/docs.min.css" rel="stylesheet" />
    <link href="docs/css/main.css" rel="stylesheet" />
    <link href="docs/css/bootstrap-datetimepicker.min.css" rel="stylesheet" media="screen" />
    <script type="text/javascript" >

        function register() {
            var role = "child";
            if (!document.getElementById("check-box-role").checked)
                role = "parent";
            var name = document.getElementById("text-name").value.trim();
            var school = document.getElementById("text-school").value.trim();
            var major = document.getElementById("text-major").value.trim();
            var checkin_date = document.getElementById("datetimepicker").value.trim();
            var ajax_url = "../api/user_register.aspx?token=<%=token%>&name=" + name 
                    + "&school=" + school + "&major=" + major + "&role=" + role;
            $.ajax({
                url: ajax_url,
                type: "get",
                async: false,
                success: function (data) {
                    var dataObject = eval("(" + data + ")");
                    if (dataObject.status == "0") {
                        var family_id = dataObject.family_id;
                        window.location.href = "register_member.aspx?family_id="+family_id;
                    }
                },
                error: function (request, status, err) {
                    alert(request + status + err);
                }
            });

        }

    </script>
</head>
<body>
   
    <div class="form-horizontal" >
        <div class="form-group">
            <label for="inputEmail3" class="col-sm-2 control-label">您是：</label>
            <div class="col-sm-10">
                <input id="check-box-role" type="checkbox" checked data-on-text="学生" data-off-text="家长" >  
            </div>
        </div>
        <div class="form-group">
            <label for="inputEmail3" class="col-sm-2 control-label">您的姓名：</label>
            <div class="col-sm-10">
                <input type="text" id="text-name" class="form-control" style="width:100px" >  
            </div>
        </div>
        <div class="form-group">
            <label for="inputEmail3" class="col-sm-2 control-label">您要去的学校：</label>
            <div class="col-sm-10">
                <input type="text" id="text-school" class="form-control" style="width:200px" >  
            </div>
        </div>
        <div class="form-group">
            <label for="inputEmail3" class="col-sm-2 control-label">您即将入学的专业：</label>
            <div class="col-sm-10">
                <input type="text" id="text-major" class="form-control" style="width:200px" >  
            </div>
        </div>
        <div class="form-group">
            <label for="inputEmail3" class="col-sm-2 control-label">入学时间：</label>
            <div class="col-sm-10">
                <input type="text"  value="2016-01-15" id="datetimepicker">
                 
            </div>
        </div>
        <div class="form-group">
            <label for="inputEmail3" class="col-sm-2 control-label"> </label>
            <div class="col-sm-10">
                <button type="button" class="btn btn-default" onclick="register();" > 注 &nbsp; 册 </button> 
            </div>
        </div>
        
    </div>
   
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

        $('#datetimepicker').datetimepicker().on('changeDate', function(ev){
            $('#datetimepicker').datetimepicker('hide');
        });

    </script>
</body>
</html>
