<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    public string currentResort = "nanshan";

    public Product[] prodArr;

    public WeixinUser currentUser;

    public string openId = "";

    public string userToken = "";

    protected void Page_Load(object sender, EventArgs e)
    {

        string currentPageUrl = Server.UrlEncode("/pages/ski_pass_product_list.aspx");
        if (Session["user_token"] == null || Session["user_token"].ToString().Trim().Equals(""))
        {
            Response.Redirect("../authorize.aspx?callback=" + currentPageUrl, true);
        }
        userToken = Session["user_token"].ToString();
        openId = WeixinUser.CheckToken(userToken);
        if (openId.Trim().Equals(""))
        {
            Response.Redirect("../authorize.aspx?callback=" + currentPageUrl, true);
        }
        currentUser = new WeixinUser(WeixinUser.CheckToken(userToken));



        string resort = Util.GetSafeRequestValue(Request, "resort", "");
        if (!resort.Trim().Equals(""))
        {
            currentResort = resort;
            Session["default_resort"] = currentResort;
        }
        else
        {
            if (Session["default_resort"] != null && !Session["default_resort"].ToString().Equals(""))
            {
                currentResort = Session["default_resort"].ToString().Trim();
            }
            else
            {
                currentResort = "nanshan";
                Session["default_resort"] = currentResort;
            }
        }

        prodArr = Product.GetSkiPassList(currentResort);
        /*
        if (Session["default_resort"] == null || Session["default_resort"].ToString().Equals("") || resort.Trim().Equals(""))
        {
            Session["default_resort"] = "nanshan";
        }
        */
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

        function book_ski_pass(product_id) {
            alert(product_id);
        }

    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <ul class="nav nav-tabs" role="tablist">
            <li role="presentation" <%if (currentResort.Trim().Equals("nanshan"))
                { %> class="active" <%}  %> ><a href="ski_pass_product_list.aspx?resort=nanshan">南山</a></li>
            <li role="presentation" <%if (currentResort.Trim().Equals("bayi"))
                { %> class="active" <%}  %> ><a href="ski_pass_product_list.aspx?resort=bayi">八易</a></li>
        </ul>
        <%
            foreach (Product p in prodArr)
            {



             %>
        <br />
        <div id="ticket-1" name="ticket" class="panel panel-success" style="width:350px" onclick="book_ski_pass(<%=p._fields["id"].ToString() %>)" >
            <div class="panel-heading">
                <h3 class="panel-title"><%=p._fields["name"].ToString() %></h3>
            </div>
            <div class="panel-body">
                <ul>
                    <li>价格：<font color="red" ><%=p._fields["sale_price"].ToString() %></font>元。</li>
                    <li>请看清雪票的使用时段。</li>
                    <li>一旦下单，不退不换。</li>
                    <%
                        if (currentResort.Trim().Equals("nanshan"))
                        {
                            %>
                    <li>如需租赁雪具，请下单时加入备注。</li>
                    <%
                        }
                        else
                        {
                            %>
                    <li>不支持租赁，<font color="red" >请自带雪具</font>。</li>
                                <%
                        }
                         %>
                    
                    <li>到店请出示雪票二维码。</li>
                </ul>
            </div>
        </div>
        <%} %>
    </div>
    </form>
</body>
</html>
