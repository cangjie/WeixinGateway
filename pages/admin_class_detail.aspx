<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    public string token = "";

    public string openId = "";

    public Class cls;

    public string[] openIdArr;

    public int classId = 0;

    protected void Page_Load(object sender, EventArgs e)
    {
        Authorize();
        classId = int.Parse(Util.GetSafeRequestValue(Request, "id", "9"));
        cls = new Class(classId);
        openIdArr = cls.GetRegistedWeixinOpenId();
    }

    public void Authorize()
    {
        token = Session["token"] == null ? "" : Session["token"].ToString();
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
        token = Session["token"].ToString().Trim();
        openId = WeixinUser.CheckToken(token);

        if (!(new WeixinUser(openId)).IsAdmin)
        {
            Response.Write("没有权限");
            Response.End();
        }
    }

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" />
    <title></title>
    <link href="docs/css/bootstrap.min.css" rel="stylesheet" media="screen" />
    <link href="docs/css/bootstrap-datetimepicker.min.css" rel="stylesheet" media="screen" />
</head>
<body>
 <div class="panel panel-default">
  <div class="panel-heading"><%=cls.Title.Trim() %></div>
  <div class="panel-body">
   
      <div class="form-group">
                    <label style="width:100px" for="dtp_input3" class="col-md-2 control-label"> <%=cls.BeginTime.ToShortDateString()%> </label>
                    <div style="width:110px" class="input-group date form_time col-md-5" data-date="" data-date-format="hh:ii" data-link-field="dtp_input3" data-link-format="hh:ii">
                        <input class="form-control" style="width:100px" type="text" id="class_time" value="<%=cls.BeginTime.ToShortTimeString() %>" onchange="ajust_time()" readonly>
                        <span class="input-group-addon"><span class="glyphicon glyphicon-remove"></span></span>
                        <span class="input-group-addon"><span class="glyphicon glyphicon-time"></span></span>
                    </div>
                    <input type="hidden" id="dtp_input3" value="" /><br />
                </div> 
  </div>
  <div class="panel-body">
    <div class="panel panel-default">
        <div class="panel-heading">报名列表</div>
        <div class="panel-body" >

            <ul class="list-group">

                <%
                    int i = 0;
                    foreach (string s in openIdArr)
                    {
                        WeixinUser user = new WeixinUser(s);
                    %>
                <li class="list-group-item">
                    <img src="<%=user.HeadImage.Trim() %>" width="50" height="50" /> 
                    <%=user.Nick.Trim() %>
                    <button data-toggle="modal" data-target="#modal-switch-<%=i.ToString() %>" class="btn btn-default badge" aria-label="right align"  >取消报名</button> 
                      <div id="modal-switch-<%=i.ToString().Trim() %>" tabindex="-1" role="dialog" aria-labelledby="modal-switch-label" class="modal fade">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" data-dismiss="modal" class="close"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                                <div id="modal-switch-label" class="modal-title">确认取消报名</div>
                            </div>
                            <div class="modal-body" >
                                <div class="switch switch-small">
                                    <button type="button" class="btn btn-default" data-dismiss="modal" onclick="cancel_user('<%=s %>')" >是</button> <button type="button" class="btn btn-default" data-dismiss="modal" >否</button>
                                </div>
                                
                            </div>
                        </div>
                    </div>
                </div>
                    </li>
<%
                        i++;
                    }
                     %>

                </ul>

        </div>
    </div>
  </div>
     
</div>
        <script  src="docs/js/jquery.min.js" ></script>
    <!--script type="text/javascript" src="docs/js/bootstrap/js/bootstrap.min.js"></script-->

    <script src="docs/js/bootstrap.min.js"></script>


     <script src="docs/js/highlight.js"></script>
    <script src="dist/js/bootstrap-switch.js"></script>
    <script src="docs/js/main.js"></script>

    <script type="text/javascript" src="docs/js/bootstrap-datetimepicker.js" charset="UTF-8"></script>
    <script type="text/javascript" src="docs/js/locales/bootstrap-datetimepicker.zh-CN.js" charset="UTF-8"></script>
    
    <!--script src="docs/js/jquery.min.js"></script-->
    <!--script src="docs/js/bootstrap.min.js"></script-->
   

    <script type="text/javascript">

        function ajust_time(){
            //alert(document.)
            var time = document.getElementById("class_time");
            var time_str = "<%=cls.BeginTime.ToShortDateString()%> " + time.value;

            //alert(time_str);

            var url =  "../api/class_change_begin_time.aspx?token=<%=token%>&classid=<%=classId%>&begintime=" + time_str;

            //alert(url);

            $.ajax({
                url:url,
                type: "get",
                async:false,
                success: function (data, status) {
                    var dataObject = eval("(" + data + ")");
                    if (dataObject.status != "0") {
                        alert(dataObject.message);
                    }
                }
            });
        }

        function cancel_user(open_id) {
            //alert(open_id);
            var url = "../api/user_register_class.aspx?token=<%=token%>&openid=" + open_id
                + "&classid=<%=classId%>&action=unregister";
            //alert(url);
            $.ajax({
                url: url,
                type: "get",
                async:false,
                success: function (data, status) {
                    window.location.reload();
                }
            });
        }
       
        $('.form_time').datetimepicker({
            language: 'zh-CN',
            weekStart: 1,
            todayBtn: 1,
            autoclose: 1,
            todayHighlight: 1,
            startView: 1,
            minView: 0,
            maxView: 1,
            forceParse: 0
        });
</script>

</body>
</html>
