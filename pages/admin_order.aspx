<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<!DOCTYPE html>

<script runat="server">

    public string token = "1c792df6f7b93aac5af90d343ce5723891ecced317df16ecb69cc55d5b2e39b71c4ed2ac";

    public string openId = "";

    public DataTable dt;

    public WeixinUser user;

    protected void Page_Load(object sender, EventArgs e)
    {
        Authorize();
        string sql = " select * from orders where order_is_paid = 2 order by order_out_trade_no desc ";
        if (!user.IsAdmin)
            sql = " select * from orders where order_is_paid = 2  and order_openid = '" + user.OpenId.Trim() + "' order by order_out_trade_no desc ";
        dt = DBHelper.GetDataTable(sql);
        
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

        user = new WeixinUser(openId.Trim());

        
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="docs/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="docs/css/highlight.css" rel="stylesheet"/>
    <link href="dist/css/bootstrap3/bootstrap-switch.css" rel="stylesheet"/>
    <link href="src/docs.min.css" rel="stylesheet"/>
    <link href="docs/css/main.css" rel="stylesheet"/>
</head>
<body>
    <div>
        <!--nav class="navbar navbar-default navbar-fixed-top">
            <div class="container">
                <ul class="nav nav-pills">
                    <li role="presentation" class="active"><a href="#">会员</a></li>
                    <li role="presentation"><a href="admin_classes.aspx">课程</a></li>
                    <li role="presentation"  ><a href="admin_class_before.aspx" >过课</a></li>
                </ul>
            </div>
        </nav-->
        <table class="table">
            <tr>
                <td><b>订单号</b></td>
                <td><b>头像</b></td>
                <td><b>昵称</b></td>
                <td><b>产品</b></td>
                <td><b>支付金额</b></td>
            </tr>
            <%
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    WeixinUser user = new WeixinUser(dt.Rows[i]["order_openid"].ToString().Trim());
                    
                %>
            <tr>
                <td><%=dt.Rows[i]["order_out_trade_no"].ToString().Trim() %></td>
                <td><img src="<%=user.HeadImage %>" width="50" height="50" /></td>
                <td><%=user.Nick %></td>
                <td><%=dt.Rows[i]["order_body"].ToString().Trim() %></td>
                <td><%=double.Parse(dt.Rows[i]["order_total_fee"].ToString().Trim())/100 %></td>
            </tr>
            <%
                }
                 %>
        </table>
    </div>
</body>
</html>
