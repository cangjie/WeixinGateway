<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    public string token = "1c792df6f7b93aac5af90d343ce5723891ecced317df16ecb69cc55d5b2e39b71c4ed2ac";
    
    public string openId = "";

    public string familyId = "";
    
    public string school = "";
    
    public string major = "";

    public string currentRole = "";

    public string checkInDate="";

    protected void Page_Load(object sender, EventArgs e)
    {
        Authorize();
        familyId = Util.GetSafeRequestValue(Request, "family_id", "0").Trim();
        if (!familyId.Equals("0"))
        {
            Family family = new Family(int.Parse(familyId));
            school = family._fields["school"].ToString().Trim();
            major = family._fields["major"].ToString().Trim();
            checkInDate = family._fields["checkin_date"].ToString().Trim();
            if (family.children.Length == 0)
            {
                currentRole = "child";
            }
            if (family.parents.Length == 0)
            {
                currentRole = "parent";
            }
        }
        
        
        
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
    <!--link href="docs/css/bootstrap.min.css" rel="stylesheet" /-->
    <link href="datetime_picker/bootstrap/css/bootstrap.min.css" rel="stylesheet" media="screen" />

    <link href="docs/css/highlight.css" rel="stylesheet" />
    <link href="dist/css/bootstrap3/bootstrap-switch.css" rel="stylesheet" />
    <link href="src/docs.min.css" rel="stylesheet" />
    <link href="docs/css/main.css" rel="stylesheet" />
    <!--link href="docs/css/bootstrap-datetimepicker.min.css" rel="stylesheet" media="screen" /-->
    <link href="datetime_picker/css/bootstrap-datetimepicker.min.css" rel="stylesheet" media="screen" />
    <script type="text/javascript" >

        function register() {

            var family_id = "<%=int.Parse(familyId)%>";
            
            var role = "child";
            if (!document.getElementById("check-box-role").checked)
                role = "parent";
            var name = document.getElementById("text-name").value.trim();
            var school = document.getElementById("text-school").value.trim();
            var major = document.getElementById("text-major").value.trim();
            var checkin_date = document.getElementById("text-checkin-date").value.trim();
            var ajax_url = "../api/user_register.aspx?token=<%=token%>&name=" + name 
                    + "&school=" + school + "&major=" + major + "&role=" + role + "&checkin_date=" + checkin_date;
            if (family_id != "0") {
                ajax_url = ajax_url + "&family_id=" + family_id;
            }
            alert(checkin_date);
            $.ajax({
                url: ajax_url,
                type: "get",
                async: false,
                success: function (data) {
                    var dataObject = eval("(" + data + ")");
                    if (dataObject.status == "0") {
                        //var family_id = dataObject.family_id;
                        if (family_id == "0") {
                            family_id = dataObject.family_id;
                            window.location.href = "register_member.aspx?family_id=" + family_id;
                        } else {
                            window.location.href = "register_member_finish.aspx?family_id=" + family_id;
                        }
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
                <input id="check-box-role" type="checkbox" checked data-on-text="学生" data-off-text="家长"  >  
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
            <div style="width:200px;float:left" class="input-group date form_date col-md-10" data-date="" data-date-format="yyyy-mm-dd" data-link-field="dtp_input2" data-link-format="yyyy-mm-dd">
                <input class="form-control" id="text-checkin-date" size="16" type="text" value="" readonly>
                <span class="input-group-addon"><span class="glyphicon glyphicon-remove"></span></span>
				<span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
            </div>
            <input type="hidden" id="hidden_checkin_date" value="" />
        </div>
        <div class="form-group">
            <label for="inputEmail3" class="col-sm-2 control-label"> </label>
            <div class="col-sm-10">
                <button type="button" class="btn btn-default" onclick="register();" > 注 &nbsp; 册 </button> 
            </div>
        </div>
        
       

    </div>
   
   <!--script src="docs/js/jquery.min.js"></script-->
    <script type="text/javascript" src="datetime_picker/jquery/jquery-1.8.3.min.js" charset="UTF-8"></script>
    <!--script src="docs/js/bootstrap.min.js"></script-->
    <script type="text/javascript" src="datetime_picker/bootstrap/js/bootstrap.min.js"></script>
    <script src="docs/js/highlight.js"></script>
    <script src="dist/js/bootstrap-switch.js"></script>
    <script src="docs/js/main.js"></script>
    <!--script type="text/javascript" src="docs/js/bootstrap-datetimepicker.js" charset="UTF-8"></script-->
    <script type="text/javascript" src="datetime_picker/js/bootstrap-datetimepicker.js" charset="UTF-8"></script>
    <script type="text/javascript" src="datetime_picker/js/locales/bootstrap-datetimepicker.zh-CN.js" charset="UTF-8"></script>
    
    <script type="text/javascript" >

        var role = "<%=currentRole%>";
        var check_role = document.getElementById("check-box-role");

        var school = "<%=school%>";
        var major = "<%=major%>";
        var check_in_date = "<%=checkInDate%>";

        if (school != '') {
            var txt_school = document.getElementById("text-school");
            txt_school.value = school;
            txt_school.disabled = true;

        }
            
        

        if (major != '') {

            var txt_major = document.getElementById("text-major");
            txt_major.value = major;
            txt_major.disabled = true;

        }

        if (role == 'child') {
            check_role.checked = true;
            check_role.disabled = true;
        }
        if (role == 'parent') {
            check_role.checked = false;
            check_role.disabled = true;
        }
        


        $('.form_date').datetimepicker({
            language: 'zh-CN',
            weekStart: 1,
            todayBtn: 1,
            autoclose: 1,
            todayHighlight: 1,
            startView: 2,
            minView: 2,
            forceParse: 0
        });

        if (check_in_date != '') {
            var text_checkin_date = document.getElementById("text-checkin-date");
            text_checkin_date.value = check_in_date;
            text_checkin_date.readOnly = true;
            text_checkin_date.disabled = true;
            $('.input-group-addon').hide();
        }


    </script>
</body>
</html>
