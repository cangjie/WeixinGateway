<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<!DOCTYPE html>

<script runat="server">

    public Class[] classArray;

    public string token = "3b9423c7ba9b1a9707e65ad5ab3279d995d378be22075b42f39c0e0c9b053bc8e4beee96";

    public string openId = "ocTHCuLoQdOkJZONBA10gTCYfenU";

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

     <script src="docs/js/jquery.min.js"></script>
    <script src="docs/js/bootstrap.min.js"></script>
    <script src="docs/js/highlight.js"></script>
    <script src="dist/js/bootstrap-switch.min.js"></script>
    <script src="docs/js/main.js"></script>


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

        var class_id = 0;
        var op_action = "";

        
        
        
        function refresh() {
            //alert(parseInt(document.getElementById("reg_num_" + class_id).value));

            var txt_num = 0;

            try {
                txt_num = parseInt(document.getElementById("reg_num_" + class_id).value);
                txt_num = txt_num + 1;
            } catch (msg) {
            }
           // alert(txt_num);
            confirm_class(class_id, op_action, txt_num);

            window.location.reload();
        }

        function pre_confirm_class(cls_id, action) {
            class_id = cls_id;
            op_action = action;
        }

        function confirm_class(cls_id, action, num)
        {
            //return;
            //alert("token=" + token+ "&opneid=" + open_id+ "&classid=" + cls_id + "&action=" + action);
            //alert(num);
            var ajax_url = "../api/user_register_class.aspx?token=" + token + "&openid=" + open_id
                + "&classid=" + cls_id +  "&num=" + num + "&action=" + ((action == "1") ? "unregister" : "register");
            $.ajax({
                type: "post",
                url: ajax_url,
                async:false,
                success: function (data, status) {
                 
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
                //string[] openIdArr = currentClass.GetRegistedWeixinOpenId();

                DataTable dtRegist = currentClass.GetRegistedTable();
                    
                
                
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
                        || user.VipLevel ==0 )
                    {
                    %>
                     disabled 
                    <%
                    }
                     %> data-target="#modal-switch-<%=currentClass.ID.ToString() %>" class="btn btn-default" onclick="pre_confirm_class('<%=currentClass.ID %>', '<%= ((joined)? "1" : "0")  %>')"  > <%if (!joined) { %>点 击 报 名<%} else {%>取 消 报 名<%} %></button>
                <div>
                    <p class="auto-style3">一起参加的同学：</p>
                    <table style="border:none">
                        <tr>
                            <%
                                for(int j = 0 ; j < 5 ; j++)
                                {
                                    if (j < dtRegist.Rows.Count )
                                    {
                                        WeixinUser currentUser = new WeixinUser(dtRegist.Rows[j]["weixin_open_id"].ToString().Trim());
                                        
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
                                    if (j < dtRegist.Rows.Count )
                                    {
                                        WeixinUser currentUser = new WeixinUser(dtRegist.Rows[j]["weixin_open_id"].ToString().Trim());
                                        
                                 %>
                            <td class="auto-style4" ><p ><%=currentUser.Nick.Trim() %><%
                                        if (int.Parse(dtRegist.Rows[j]["num"].ToString().Trim()) > 1)
                                        { 
                                            %><font color="red" >(<%=dtRegist.Rows[j]["num"].ToString().Trim() %>人)</font><%
                                        }
                                                                                            
                                                                                           %></p></td>
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
                                    if (j+5 < dtRegist.Rows.Count )
                                    {
                                        WeixinUser currentUser = new WeixinUser(dtRegist.Rows[j + 5]["weixin_open_id"].ToString().Trim());
                                        
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
                                    if (j + 5 < dtRegist.Rows.Count)
                                    {
                                        WeixinUser currentUser = new WeixinUser(dtRegist.Rows[j + 5]["weixin_open_id"].ToString().Trim());
                                        
                                 %>
                            <td class="auto-style4" ><p ><%=currentUser.Nick.Trim() %><%
                                        if (int.Parse(dtRegist.Rows[j + 5]["num"].ToString().Trim()) > 1)
                                        { 
                                            %><font color="red" >(<%=dtRegist.Rows[j+5]["num"].ToString().Trim() %>人)</font><%
                                        }
                                                                                            
                                                                                           %></p></td>
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
                                <button type="button" data-dismiss="modal" class="close"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                                <div id="modal-switch-label-<%=currentClass.ID.ToString() %>" class="modal-title"><%if (!joined) {%>报名确认<%} else  {%>您的取消已经成功<%} %></div>
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
                                您即将取消 <%=currentClass.Title.Trim() %> 的预约。
                                <%
                }
                else
                {
                %>
                                您即将预约 <%=currentClass.Title.Trim() %>，课程的时间是 <%=currentClass.BeginTime.ToShortDateString() %> 
                                <%=currentClass.BeginTime.Hour.ToString() + ":"+currentClass.BeginTime.Minute.ToString().PadLeft(2,'0') %>。
                                如您临时有变动，请在<%=currentClass._fields["cancel_time"].ToString().Trim() %>前取消。我还要替<input id="reg_num_<%=currentClass.ID.ToString() %>" value="0"  style="width:40px" />个朋友报名。
                                  

                                    

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
    
    
    
     
   
        
</body>

</html>
