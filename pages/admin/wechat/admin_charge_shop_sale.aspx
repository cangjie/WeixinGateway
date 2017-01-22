﻿<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    public WeixinUser currentUser;
    public string openId = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        string currentPageUrl = Server.UrlEncode("/pages/admin/wechat/admin_charge_shop_sale.aspx");
        if (Session["user_token"] == null || Session["user_token"].ToString().Trim().Equals(""))
        {
            Response.Redirect("../../../authorize.aspx?callback=" + currentPageUrl, true);
        }
        string userToken = Session["user_token"].ToString();
        openId = WeixinUser.CheckToken(userToken);
        if (openId.Trim().Equals(""))
        {
            Response.Redirect("../../../authorize.aspx?callback=" + currentPageUrl, true);
        }
        currentUser = new WeixinUser(WeixinUser.CheckToken(userToken));

        if (!currentUser.IsAdmin)
            Response.End();
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
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="../js/bootstrap.min.js"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <script type="text/javascript" >
        var market_price = 0.00;
        var sale_price = 0.00;
        var ticket_amount = 0.00;
        var real_pay_price = 0.00;
        var discount_rate = 1.0;
        var score_rate = 1.0;
        var score = 0;
        function compute_score() {
            if (check_valid()) {
                real_pay_price = sale_price - ticket_amount;
                discount_rate = real_pay_price / market_price;
                if (discount_rate == 1)
                    score_rate = 1;
                else if (discount_rate >= 0.95)
                    score_rate = 0.925;
                else if (discount_rate >= 0.9)
                    score_rate = 0.85;
                else if (discount_rate >= 0.85)
                    score_rate = 0.775;
                else if (discount_rate >= 0.8)
                    score_rate = 0.7;
                else if (discount_rate >= 0.75)
                    score_rate = 0.625;
                else if (discount_rate >= 0.7)
                    score_rate = 0.55;
                else if (discount_rate >= 0.65)
                    score_rate = 0.475;
                else if (discount_rate >= 0.6)
                    score_rate = 0.4;
                else if (discount_rate >= 0.55)
                    score_rate = 0.325;
                else if (discount_rate >= 0.5)
                    score_rate = 0.25;
                else if (discount_rate >= 0.45)
                    score_rate = 0.175;
                else if (discount_rate >= 0.4)
                    score_rate = 0.1;
                else
                    score_rate = 0;
                score = parseInt(real_pay_price * score_rate);
                document.getElementById("lbl_score").innerText = score.toString();
                document.getElementById("real_pay_price").innerText = real_pay_price;
                document.getElementById("lbl_score_rate").innerText = score_rate;
            }
            else {
                //alert("aa");
            }
        }

        function check_valid() {
            var valid = true;
            market_price = parseFloat(document.getElementById("txt_market_price").value);
            if (isNaN(market_price))
                valid = false;
            sale_price = parseFloat(document.getElementById("txt_sale_price").value);
            if (isNaN(sale_price))
                valid = false;
            ticket_amount = parseFloat(document.getElementById("txt_ticket_amout").value);
            if (isNaN(ticket_amount))
                ticket_amount = 0;
            return valid;
        }
    </script>
</head>
<body>
    <table class="table table-striped">
        <tr>
            <td style="width:140px">市场价(元)：</td>
            <td style="white-space:nowrap; overflow:hidden">
                <input type="text" id="txt_market_price" style="width:100px"  oninput="compute_score()" />
                <span style="color:red; width:10px; word-wrap:break-word" ></span>
            </td>
        </tr>
        <tr>
            <td>成交价(元)：</td>
            <td>
                <input type="text" id="txt_sale_price"  style="width:100px"  oninput="compute_score()"  />
                <span style="color:red; width:10px; word-wrap:break-word" ></span>
            </td>
        </tr>
        <tr>
            <td>使用代金券(元)：</td>
            <td>
                <input type="text" id="txt_ticket_amout" style="width:100px" oninput="compute_score()" />
                <span style="color:red; width:10px; word-wrap:break-word" ></span>
            </td>
        </tr>
        <tr>
            <td>实际支付金额(元)：</td>
            <td>
                <span style="color:red; width:10px; word-wrap:break-word;font-size:large"  id="real_pay_price"></span>
            </td>
        </tr>
        <tr>
            <td>龙珠系数：</td>
            <td>
                <span style="color:red; width:10px; word-wrap:break-word; font-size:large" id="lbl_score_rate" ></span>
            </td>
        </tr>
        <tr>
            <td>生成龙珠(元)：</td>
            <td>
                <span style="color:red; width:10px; word-wrap:break-word; font-size:large" id="lbl_score" ></span>
            </td>
        </tr>
        <tr>
            <td>备注：</td>
            <td><textarea cols="30" rows="3" id="txt_memo" ></textarea></td>
        </tr>
        <tr>
            <td colspan="2" style="text-align:center"><button type="button" class="btn btn-default" >获取支付二维码</button></td>
        </tr>
        <tr>
            <td colspan="2" ></td>
        </tr>
    </table>
</body>
</html>