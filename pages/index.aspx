<%@ Page Language="C#" %>
<!DOCTYPE html>

<script runat="server">

    public Class[] classArray;

    public string token = "";

    public string openId = "";

    public WeixinUser user;
    
    protected void Page_Load(object sender, EventArgs e)
    {
        Authorize();
        classArray = GetClass();
        user = new WeixinUser(openId);
        
    }

    public Class[] GetClass()
    {
        DateTime start = DateTime.Parse(DateTime.Now.ToShortDateString());
        DateTime end = DateTime.Parse(DateTime.Now.AddDays(8).ToShortDateString());
        Class[] classArr = Class.GetClasses(start, end);
        return classArr;
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
    <style type="text/css">
        .auto-style1 {
            font-size: xx-large;
        }
        .auto-style3 {
            font-size: large;
        }
        .auto-style4 {
            font-size: small;
        }
        .auto-style5 {
            font-size: medium;
        }
    </style>
    <script type="text/javascript" >

        var token = "<%=token%>";
        var open_id = "<%=openId%>";

        function refresh() {
            //alert("aa");
            window.location.reload();
        }

        function confirm_class(cls_id, action)
        {
            //alert("token=" + token+ "&opneid=" + open_id+ "&classid=" + cls_id + "&action=" + action);
            var ajax_url = "../api/user_register_class.aspx?token=" + token + "&openid=" + open_id
                + "&classid=" + cls_id + "&action=" + ((action == "1") ? "unregister" : "register");
            //alert(ajax_url);
            $.ajax({
                type: "get",
                url: ajax_url,
                success: function (data, status) {
                    //alert(data["status"]);
                    //alert(status);
                    var dataObject = eval("(" + data + ")");
                    if (dataObject.status == "0") {
                        //alert("NB");
                    }
                    else {
                        //alert(dataObject.message);
                        var divTitle = document.getElementById("modal-switch-label-" + cls_id);
                        divTitle.innerText = "操作错误";
                        var pDetail = document.getElementById("modal-body-" + cls_id);
                        pDetail.innerText = dataObject.message;
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


    <div id="root" style="padding:20px 20px 20px 20px" >
        
        <%
            for(int i = 0 ; i < classArray.Length ; i++)
            {
                Class currentClass = classArray[i];
                bool joined = currentClass.IsJoin(openId);
                string[] openIdArr = currentClass.GetRegistedWeixinOpenId();
                
                
             %>

        <div style="border:1px solid #BEBEBE;padding: 5px" >
            <div class="auto-style1"><strong><%=currentClass.Title.Trim() %></strong></div>
            <div style="background-color: #CCCCCC" class="auto-style5">教练：<%=currentClass.Teacher.Trim() %>&nbsp;&nbsp;&nbsp;&nbsp;时间：<span class="gr"><%=currentClass.BeginTime.ToShortDateString() %> <%=currentClass.BeginTime.Hour.ToString() %>:<%=currentClass.BeginTime.Minute.ToString().PadLeft(2,'0') %></span></div>
             <div class="auto-style3">名额：<%=currentClass.TotalPersonNumber.ToString() %>人 已报：<%=currentClass.RegistedPersonNumber.ToString() %>人</div>
            <div class="auto-style3"><%=currentClass.Memo.Trim() %></div>
            <br />
            <div>
                <button data-toggle="modal" <%
                    if ((!joined && currentClass.TotalPersonNumber<= currentClass.RegistedPersonNumber) 
                        || (joined && !currentClass.CanCancel)
                        || user.VipLevel ==0)
                    {
                    %>
                     disabled 
                    <%
                    }
                     %> data-target="#modal-switch-<%=currentClass.ID.ToString() %>" class="btn btn-default" onclick="confirm_class('<%=currentClass.ID %>', '<%= ((joined)? "1" : "0")  %>')"  > <%if (!joined) { %>点 击 报 名<%} else {%>取 消 报 名<%} %></button>
                <div>
                    <p class="auto-style3">一起参加的同学：</p>
                    <table style="border:none">
                        <tr>
                            <%
                                for(int j = 0 ; j < 5 ; j++)
                                {
                                    if (j < openIdArr.Length )
                                    {
                                        WeixinUser currentUser = new WeixinUser(openIdArr[j]);
                                        
                                 %>
                            <td width="60" ><img  src="<%=currentUser.HeadImage.Trim() %>" style="width:50px;height:50px;" /></td>
                            <%
                            }
                            else
                            {
                                    %>
                            <td width="60" >&nbsp;</td>
                            <%
                                    }
                            }
                                 %>
                        </tr>
                        <tr>
                            <%
                                for(int j = 0 ; j < 5 ; j++)
                                {
                                    if (j < openIdArr.Length )
                                    {
                                        WeixinUser currentUser = new WeixinUser(openIdArr[j]);
                                        
                                 %>
                            <td class="auto-style4" ><p ><%=currentUser.Nick.Trim() %></p></td>
                            <%
                            }
                            else
                            {
                                    %>
                            <td class="auto-style4" ><p >&nbsp;</p></td>
                            <%
                                    }
                                    }
                                 %>
                        </tr>
                        <tr>
                        <%
                                for(int j = 0 ; j < 5 ; j++)
                                {
                                    if (j+5 < openIdArr.Length )
                                    {
                                        WeixinUser currentUser = new WeixinUser(openIdArr[j + 5]);
                                        
                                 %>
                            <td width="60" ><img  src="<%=currentUser.HeadImage.Trim() %>" style="width:50px;height:50px;" /></td>
                            <%
                            }
                            else
                            {
                                    %>
                            <td width="60" >&nbsp;</td>
                            <%
                                    }
                            }
                                 %>
                        </tr>
                        <tr>
                         <%
                                for(int j = 0 ; j < 5 ; j++)
                                {
                                    if (j+5 < openIdArr.Length )
                                    {
                                        WeixinUser currentUser = new WeixinUser(openIdArr[j + 5]);
                                        
                                 %>
                            <td class="auto-style4" ><p ><%=currentUser.Nick.Trim() %></p></td>
                            <%
                            }
                            else
                            {
                                    %>
                            <td class="auto-style4" ><p >&nbsp;</p></td>
                            <%
                                    }
                                    }
                                 %>
                        
                        </tr>
                    </table>

                </div>
                <div id="modal-switch-<%=currentClass.ID.ToString() %>" tabindex="-1" role="dialog" aria-labelledby="modal-switch-label" class="modal fade">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <!--button type="button" data-dismiss="modal" class="close"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button-->
                                <div id="modal-switch-label-<%=currentClass.ID.ToString() %>" class="modal-title"><%if (!joined) {%>您的报名已经成功<%} else  {%>您的取消已经成功<%} %></div>
                            </div>
                            <div class="modal-body" >
                                <!--div class="switch switch-small">
                                    <input type="checkbox" checked />
                                </div-->
                                <p id="modal-body-<%=currentClass.ID %>" >
                                <%
                if (joined)
                { 
                %>
                                您已经成功取消了 <%=currentClass.Title.Trim() %> 的预约。
                                <%
                }
                else
                {
                %>
                                您成功预约了 <%=currentClass.Title.Trim() %>，课程的时间是 <%=currentClass.BeginTime.ToShortDateString() %> 
                                <%=currentClass.BeginTime.Hour.ToString() + ":"+currentClass.BeginTime.Minute.ToString().PadLeft(2,'0') %>。
                                如您临时有变动，请在上课前4小时取消。
                                <%
                }
                                     %></p>
                                <br /><button type="button" data-dismiss="modal"  class="btn btn-default" onclick="refresh()" >我 知 道 了</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <br />
        <%
        }
             %>
       

    </div>
    
    
    
     
    <script src="docs/js/jquery.min.js"></script>
    <script src="docs/js/bootstrap.min.js"></script>
    <script src="docs/js/highlight.js"></script>
    <script src="dist/js/bootstrap-switch.js"></script>
    <script src="docs/js/main.js"></script>
        
</body>

</html>
