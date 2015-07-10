<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    public WeixinUser[] users;

    public string token = "";

    public string openId = "";

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

    protected void Page_Load(object sender, EventArgs e)
    {
        Authorize();
        users = WeixinUser.GetAllUsers();
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <title></title>
    <link href="docs/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="docs/css/highlight.css" rel="stylesheet"/>
    <link href="dist/css/bootstrap3/bootstrap-switch.css" rel="stylesheet"/>
    <link href="src/docs.min.css" rel="stylesheet"/>
    <link href="docs/css/main.css" rel="stylesheet"/>
</head>
<body>
    <div>
        <nav class="navbar navbar-default navbar-fixed-top">
            <div class="container">
                <ul class="nav nav-pills">
                    <li role="presentation" class="active"><a href="#">会员</a></li>
                    <li role="presentation"><a href="admin_classes.aspx">课程</a></li>
                    <li role="presentation"  ><a href="admin_class_before.aspx" >过课</a></li>
                </ul>
            </div>
        </nav>
        <br />
        <br />
        <ul class="list-group">
  
            <%
                for(int i = 0 ; i < users.Length ; i++)
                {
                 %>

  <li class="list-group-item"><img src="<%=users[i].HeadImage.Trim() %>" width="50" height="50" /> <%=users[i].Nick.Trim() %>

     <button data-toggle="modal" data-target="#modal-switch-<%=i.ToString() %>" class="btn btn-default badge" aria-label="right align"  >报名权限</button> 
                      <div id="modal-switch-<%=i.ToString().Trim() %>" tabindex="-1" role="dialog" aria-labelledby="modal-switch-label" class="modal fade">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" data-dismiss="modal" class="close"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                                <div id="modal-switch-label" class="modal-title">是否允许报名</div>
                            </div>
                            <div class="modal-body" >
                                <div class="switch switch-small">
                                    <input type="checkbox" <% if (users[i].VipLevel == 0 ) { %>   <%} else { %> checked <% } %>  onchange="change_user_state('<%=users[i].OpenId.Trim() %>')" id="chk_<%=users[i].OpenId.Trim() %>"  />
                                </div>
                                
                            </div>
                        </div>
                    </div>
                </div>

  </li>
            <%
            }
                 %>
</ul>
        
    </div>
       <script src="docs/js/jquery.min.js"></script>
    <script src="docs/js/bootstrap.min.js"></script>
    <script src="docs/js/highlight.js"></script>
    <script src="dist/js/bootstrap-switch.js"></script>
    <script src="docs/js/main.js"></script>
    <script type="text/javascript" >


        function change_user_state(open_id) {

            

            

            var check_box = document.getElementById("chk_"+open_id);

            var state = 0;


            if (check_box.checked) {
                state = 1;
            }else{
                state = 0;
            }

            var url_str = "../api/user_change_level.aspx?token=<%=token%>&openid=" + open_id + "&state=" + state;

            $.ajax({
                url:url_str,
                type:"get",
                success:function(data,status) {
                    var dataObject = eval("(" + data + ")");
                    if (dataObject.status != "0") {
                        alert(dataObject.message);
                    }
                },
                error:function(request, status, err) {
                
                    alert(request + status + err);
                }
            })
        }

    </script>
</body>
</html>
