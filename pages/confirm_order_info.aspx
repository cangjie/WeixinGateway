<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    public OrderTemp orderTemp;

    public string openId = "";

    public WeixinUser currentUser;

    public Dictionary<string, object>[] detailArr;

    protected void Page_Load(object sender, EventArgs e)
    {
        orderTemp = new OrderTemp(int.Parse(Util.GetSafeRequestValue(Request, "id", "35")));


        string currentPageUrl = Server.UrlEncode("/pages/confirm_order_info.aspx");
        if (Session["user_token"] == null || Session["user_token"].ToString().Trim().Equals(""))
        {
            Response.Redirect("../authorize.aspx?callback=" + currentPageUrl, true);
        }
        string userToken = Session["user_token"].ToString();
        openId = WeixinUser.CheckToken(userToken);
        if (openId.Trim().Equals(""))
        {
            Response.Redirect("../authorize.aspx?callback=" + currentPageUrl, true);
        }
        currentUser = new WeixinUser(WeixinUser.CheckToken(userToken));
        if (currentUser.CellNumber.Trim().Equals(""))
            Response.Redirect("register_cell_number.aspx", true);

        detailArr = Util.GetObjectArrayFromJsonByKey(orderTemp._fields["order_detail_json"].ToString().Trim(), "order_details");


        //DBHelper.UpdateData("order_online_temp", new string[,] { { "customer_open_id", "varchar", openId.Trim() } },
        //    new string[,] { { "id", "int", orderTemp._fields["id"].ToString().Trim() } }, Util.conStr.Trim());


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
    <form id="form1" runat="server">
    <table class="table table-striped">
        <tr>
            <td colspan="2" >&nbsp;</td>
        </tr>
        <%
            for(int i = 0; i < detailArr.Length; i++)
            {
                %>
        <tr name="product_tr_0" >
            <td colspan="2" >商品<%=(i+1).ToString() %>：<%=detailArr[i]["name"].ToString().Trim() %> 数量：<%=detailArr[i]["num"].ToString().Trim() %></td>
        </tr>
        <tr name="product_tr_0" >
            <td colspan="2" >零售价：<%=detailArr[i]["market_price"].ToString().Trim() %> 成交价：<%=detailArr[i]["deal_price"].ToString().Trim() %></td>
        </tr>
        <tr name="product_tr_0" >
            <td colspan="2" id="product_info_0" >&nbsp;</td>
        </tr>

        <%

            }
             %>
        
        <tr style="display:none" name="product_tr_4" >
            <td colspan="2" id="product_info_4" >&nbsp;</td>
        </tr>
        
        <tr>
            <td style="width:140px">零售价(元)：</td>
            <td style="white-space:nowrap; overflow:hidden"><%=orderTemp._fields["market_price"].ToString() %></td>
        </tr>
        <tr>
            <td>成交价(元)：</td>
            <td><%=orderTemp._fields["sale_price"].ToString() %></td>
        </tr>
        <tr>
            <td>使用代金券(元)：</td>
            <td><%=orderTemp._fields["ticket_amount"].ToString() %></td>
        </tr>
        <tr>
            <td>实际支付金额(元)：</td>
            <td><%=orderTemp._fields["real_paid_price"].ToString() %></td>
        </tr>
        <tr>
            <td>龙珠系数：</td>
            <td><%=orderTemp._fields["score_rate"].ToString().Trim() %></td>
        </tr>
        <tr>
            <td>生成龙珠：</td>
            <td><%=orderTemp._fields["generate_score"].ToString() %></td>
        </tr>
        <tr>
            <td>支付方式：</td>
            <td><%=orderTemp._fields["pay_method"].ToString() %></td>
        </tr>
        <tr>
            <td>门店：</td>
            <td><%=orderTemp._fields["shop"].ToString() %></td>
        </tr>
        <tr>
            <td colspan="2" style="text-align:center"><button type="button" class="btn btn-default" >支付</button></td>
        </tr>
        <tr>
            <td colspan="2" id="qrcode_td" style="text-align:center"></td>
        </tr>
    </table>
    </form>
</body>
</html>
