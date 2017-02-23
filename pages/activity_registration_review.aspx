<%@ Page Language="C#" %>
<script runat="server">

    public int orderId = 0;

    public string regJson = "";

    public string code = "";

    public Dictionary<string, object>[] personJsonArr;

    protected void Page_Load(object sender, EventArgs e)
    {
        OnlineOrder order = new OnlineOrder(int.Parse(Util.GetSafeRequestValue(Request, "orderid", "1229")));
        Card card = new Card();
        if (order._fields["code"] != null && !order._fields["code"].ToString().Equals(""))
        {
            code = order._fields["code"].ToString();
            card = new Card(code);
        }
        regJson = card.Memo.Trim();

        personJsonArr = Util.GetObjectArrayFromJsonByKey(regJson, "regist_person");
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
</head>
<body>
    <div><h1>2017-3-10~2017-3-12 第三期北大湖活动</h1></div>
    <div style="text-align:center" ><img src="http://weixin.snowmeet.com/show_qrcode.aspx?sceneid=3<%=code %>" style="width:150px" /></div>
    <div class="panel panel-danger" >
        <div class="panel-heading"><h3 class="panel-title">联系人</h3></div>
        <div class="panel-body" >
            <div class="row" >
                <div class="col-xs-4" >姓名：</div>
                <div class="col-xs-8" ><%=personJsonArr[0]["name"].ToString() %></div>
            </div>
            <div class="row" >
                <div class="col-xs-4" >电话：</div>
                <div class="col-xs-8" ><%=personJsonArr[0]["cell_number"].ToString() %></div>
            </div>
            <div class="row" >
                <div class="col-xs-4" >身份证：</div>
                <div class="col-xs-8" ><%=personJsonArr[0]["idcard"].ToString() %></div>
            </div>
            <div class="row" >
                <div class="col-xs-4" ></div>
                <div class="col-xs-8" ><%=(personJsonArr[0]["rent"].ToString().Equals("1")? "租板": "自带板") %></div>
            </div>
            <div class="row" >
                <div class="col-xs-4" >身高：</div>
                <div class="col-xs-8" ><%=(personJsonArr[0]["rent"].ToString().Equals("1")? personJsonArr[0]["length"].ToString(): "--") %></div>
            </div>
            <div class="row" >
                <div class="col-xs-4" >鞋码：</div>
                <div class="col-xs-8" ><%=(personJsonArr[0]["rent"].ToString().Equals("1")? personJsonArr[0]["boot_size"].ToString(): "--") %></div>
            </div>
        </div>
    </div>
    <div><br /></div>
    <div id="others_person">
        <%
            for (int i = 1; i < personJsonArr.Length; i++)
            {


             %>
        <div class="panel panel-info" id="others_person_template" name="others_person_info"  >
            <div class="panel-heading"><h3 class="panel-title">雪友</h3></div>
        <div class="panel-body" >
            <div class="row" >
                <div class="col-xs-4" >姓名：</div>
                <div class="col-xs-8" ><%=personJsonArr[i]["name"].ToString() %></div>
            </div>
            <div class="row" >
                <div class="col-xs-4" >电话：</div>
                <div class="col-xs-8" ><%=personJsonArr[i]["cell_number"].ToString() %></div>
            </div>
            <div class="row" >
                <div class="col-xs-4" >身份证：</div>
                <div class="col-xs-8" ><%=personJsonArr[i]["idcard"].ToString() %></div>
            </div>
            <div class="row" >
                <div class="col-xs-4" ></div>
                <div class="col-xs-8" ><%=(personJsonArr[i]["rent"].ToString().Equals("1")? "租板": "自带板") %></div>
            </div>
            <div class="row" >
                <div class="col-xs-4" >身高：</div>
                <div class="col-xs-8" ><%=(personJsonArr[i]["rent"].ToString().Equals("1")? personJsonArr[i]["length"].ToString(): "--") %></div>
            </div>
            <div class="row" >
                <div class="col-xs-4" >鞋码：</div>
                <div class="col-xs-8" ><%=(personJsonArr[i]["rent"].ToString().Equals("1")? personJsonArr[i]["boot_size"].ToString(): "--") %></div>
            </div>
        </div>

        </div>

        <%
            }
             %>
    </div>
</body>
</html>