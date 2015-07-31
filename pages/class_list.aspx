<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<!DOCTYPE html>

<script runat="server">

    public string token = "1c792df6f7b93aac5af90d343ce5723891ecced317df16ecb69cc55d5b2e39b71c4ed2ac";

    public string openId = "";

    public string className = "";

    public DataTable dtProducts;

    public int classId = 1;

    protected void Page_Load(object sender, EventArgs e)
    {
        Authorize();
        classId = int.Parse(Util.GetSafeRequestValue(Request, "class_id", "1"));

        DataTable dt = DBHelper.GetDataTable(" select * from product_classes where [id] = " + classId.ToString());
        if (dt.Rows.Count > 0)
        {
            className = dt.Rows[0]["text_name"].ToString().Trim();
        }
        dt.Dispose();

        dtProducts = DBHelper.GetDataTable("  select * from products where class =  " + classId.ToString());
        
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
    <title></title>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" />
    <link href="datetime_picker/bootstrap/css/bootstrap.min.css" rel="stylesheet" media="screen" />
    <link href="docs/css/highlight.css" rel="stylesheet" />
    <link href="dist/css/bootstrap3/bootstrap-switch.css" rel="stylesheet" />
    <link href="src/docs.min.css" rel="stylesheet" />
    <link href="docs/css/main.css" rel="stylesheet" />
    <link href="datetime_picker/css/bootstrap-datetimepicker.min.css" rel="stylesheet" media="screen" />
</head>
<body>
  
    <div>
        <ul class="list-group">
            <li class="list-group-item">
                <b><%=className.Trim() %></b><br />
                <table class="table">
                    <tr>
                        <td><b>名称</b></td>
                        <td><b>价格</b></td>
                        <td> </td>
                    </tr>
                    <%
                        for(int i = 0 ; i < dtProducts.Rows.Count ; i++)
                        {
                         %>
                    <tr>
                        <td><%=dtProducts.Rows[i]["name"].ToString().Trim() %></td>
                        <td>$<%=dtProducts.Rows[i]["price"].ToString().Trim() %></td>
                        <td><button class="btn btn-default" type="submit" onclick="javascript:order_product(<%=dtProducts.Rows[i]["id"].ToString().Trim() %>)"> 订 购 </button></td>
                    </tr>
                    <%
                    }
                         %>
                </table>
            </li>
            
        </ul>
    </div>
    <script type="text/javascript" >

        function order_product(product_id) {
        
            window.location.href = "../payment/payment.aspx?product_id=" + product_id;

        
        }

    </script>
</body>
</html>