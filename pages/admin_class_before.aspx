<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    public Class[] classArray;

    public string token = "";

    public string openId = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        Authorize();
        classArray = GetClass();
    }

    public Class[] GetClass()
    {
        DateTime end = DateTime.Parse(DateTime.Now.ToShortDateString());
        DateTime start = DateTime.Parse(DateTime.Now.AddDays(-60).ToShortDateString());
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

        if (!(new WeixinUser(openId)).IsAdmin)
        {
            Response.Write("没有权限");
            Response.End();
        }


    }
    
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
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
                    <li role="presentation" ><a href="admin_users.aspx">会员</a></li>
                    <li role="presentation"  ><a href="admin_classes.aspx">课程</a></li>
                    <li role="presentation" class="active"  ><a href="#" >过课</a></li>
                </ul>
            </div>
        </nav>
        <br />
        <br />
        <ul class="list-group">
            <% foreach(Class cls in classArray )
               {%>
            <li class="list-group-item" style="height:50px" >
                <a href ="admin_class_detail.aspx?id=<%=cls.ID.ToString() %>" >
                <%=cls.Title.Trim() %>
                    </a>
                <button data-toggle="modal"  class="btn btn-default badge" aria-label="right align"  ><%=cls.RegistedPersonNumber.ToString() %></button> 
                
            </li>
            <%
            }
                 %>
        </ul>
    </div>
         <script type="text/javascript" src="docs/js/jquery.min.js" charset="UTF-8"></script>
    <script type="text/javascript" src="docs/js/bootstrap/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="docs/js/bootstrap-datetimepicker.js" charset="UTF-8"></script>
    <script type="text/javascript" src="docs/js/locales/bootstrap-datetimepicker.zh-CN.js" charset="UTF-8"></script>
    
</body>
</html>
