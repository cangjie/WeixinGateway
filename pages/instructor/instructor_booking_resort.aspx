<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    public WeixinUser currentUser;

    public string openId = "";

    public string userToken = "";

    public Product[] prodArr = Product.GetInstructorProduct();

    public DateTime startDate = DateTime.Now.Date.AddDays(1);

    protected void Page_Load(object sender, EventArgs e)
    {
        string currentPageUrl = Request.Url.ToString().Split('?')[0].Trim();
        if (!Request.QueryString.ToString().Trim().Equals(""))
        {
            currentPageUrl = currentPageUrl + "?" + Request.QueryString.ToString().Trim();
        }

        if (Session["user_token"] == null || Session["user_token"].ToString().Trim().Equals(""))
        {
            Response.Redirect("../../authorize.aspx?callback=" + currentPageUrl, true);
        }
        userToken = Session["user_token"].ToString();

        openId = WeixinUser.CheckToken(userToken);
        if (openId.Trim().Equals(""))
        {
            Response.Redirect("../../authorize.aspx?callback=" + currentPageUrl, true);
        }
        currentUser = new WeixinUser(WeixinUser.CheckToken(userToken));
        if (!currentUser._fields["is_instructor"].ToString().Trim().Equals("1"))
        {
            Response.End();
        }

        
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <!-- 新 Bootstrap 核心 CSS 文件 -->
    <link rel="stylesheet" href="../css/bootstrap.min.css">
    <link rel="stylesheet" href="../css/normalize.css" />
    <!-- 可选的Bootstrap主题文件（一般不用引入） -->
    <link rel="stylesheet" href="../css/bootstrap-theme.min.css">
    <!-- jQuery文件。务必在bootstrap.min.js 之前引入 -->

    <script src="../js/jquery.min.js"></script>
    <script type="text/javascript" src="../js/popper.min.js" ></script>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="../js/bootstrap.min.js"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
</head>
<body>

    <div>
        <ul class="nav nav-tabs" >
            <li class="nav-item" ><a class="nav-link active" href="instructor_booking_resort.aspx" >场地预约</a></li>
        </ul>

    </div>
     <%
            foreach (Product p in prodArr)
            {
             %>
        <br />
        <div id="ticket-1" name="ticket" class="panel panel-success" style="width:350px" onclick="launch_book_modal('<%=p._fields["id"].ToString().Trim() %>', '<%=p._fields["name"].ToString() %>')" >
            <div class="panel-heading">
                <h3 class="panel-title"><%=p._fields["name"].ToString() %></h3>
            </div>
            <div class="panel-body">
                价格：<%=p.SalePrice.ToString()%><br />
                <%=p._fields["intro"].ToString().Trim() %>
            </div>
        </div>
        <%} %>
    <script type="text/javascript" >

        function launch_book_modal(product_id, product_name) {
            select_date('<%=startDate.Year.ToString()%>-<%=startDate.Month.ToString()%>-<%=startDate.Day.ToString()%>');
            $("#booking_modal").modal();
        }

        function select_date(selected_date) {
            document.getElementById("current_date").innerText = selected_date;
        }

    </script>
    <div id="booking_modal" class="modal fade bs-example-modal-lg" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header" id="modal-header" ></div>
                <div class="modal-body" >
                    <div>日期：<span class="dropdown">
                            <button class="btn btn-secondary btn-sm dropdown-toggle" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" id="dropdownSelectDate" >
                                <span id="current_date" ></span>
                                <span class="caret"></span>
                            </button>
                            <div class="dropdown-menu" aria-labelledby="dropdownMenuButton" id="drop-down-date-menu" >
                                <%
                                    for (DateTime i = DateTime.Now.Date.AddDays(1); i <= DateTime.Now.Date.AddDays(5); i = i.AddDays(1))
                                    {
                                        string dateStr = i.Year.ToString() + "-" + i.Month.ToString() + "-" + i.Day.ToString();
                                        %>
                                <a href="#"  class="dropdown-item" onclick="select_date('<%=dateStr %>')" ><%=dateStr %></a>
                                            <%
                                    }
                                     %>
                            </div>
                        </span>
                    </div>
			        <br/>
                    <div>
                        人数：<span class="dropdown" >
                            <button class="btn btn-default dropdown-toggle" type="button" id="dropdownSelectNum" data-toggle="dropdown">
                                <span id="current_num" >1</span>
                                <span class="caret"></span>
                            </button>
                            <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1"  >
                                <li role="presentation"><a role="menuitem" tabindex="-1" href="#" onclick="select_num(1)" >1</a></li>
                                <li role="presentation"><a role="menuitem" tabindex="-1" href="#" onclick="select_num(2)" >2</a></li>
                                <li role="presentation"><a role="menuitem" tabindex="-1" href="#" onclick="select_num(3)" >3</a></li>
                                <li role="presentation"><a role="menuitem" tabindex="-1" href="#" onclick="select_num(4)" >4</a></li>
                            </ul>
                        </span>
                            
                    </div>
			        <br/>
                      
                       
                    <div id="summary" >小计：</div>
                </div>
                <div class="modal-footer" ><button type="button" class="btn btn-default" onclick="book_ski_pass()"> 确 认 预 定 </button></div>
            </div>
        </div>
    </div>
</body>
</html>
