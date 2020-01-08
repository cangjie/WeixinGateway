<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    public WeixinUser currentUser;
    public string openId = "";
    public string userToken = "";


    public string timeStamp = "";
    public string nonceStr = "";
    public string ticketStr = "";
    public string shaParam = "";
    public string appId = System.Configuration.ConfigurationManager.AppSettings["wxappid"];
    public string customerOpenId = "";
    public WeixinUser customerUser;
    public string cellNumber = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        string currentPageUrl = Request.Url.ToString();
        if (!Util.GetSafeRequestValue(Request, "cell", "").Trim().Equals(""))
        {
            currentPageUrl = currentPageUrl + "?cell=" + Util.GetSafeRequestValue(Request, "cell", "").Trim();
        }

        
        if (Session["user_token"] == null || Session["user_token"].ToString().Trim().Equals(""))
        {
            Response.Redirect("../../../authorize.aspx?callback=" + currentPageUrl, true);
        }
        userToken = Session["user_token"].ToString();
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
    <link rel="stylesheet" href="../../css/bootstrap.min.css">
    <link rel="stylesheet" href="../../css/normalize.css" />
    <!-- 可选的Bootstrap主题文件（一般不用引入） -->
    <link rel="stylesheet" href="../../css/bootstrap-theme.min.css">
    <link type="text/css" href="../../third/alertjs/alert.css" rel="stylesheet"/>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.2.0.js" ></script>
</head>
<body>
    <table class="table table-striped" >
        <tr>
            <td style="width:140px" >物品名称：</td>
            <td><input type="text" id="item_name" onchange="check_valid()" /></td>
        </tr>
        <tr><td colspan="2" >&nbsp;</td></tr>
        <tr>
            <td style="width:140px" >物品说明：</td>
            <td><textarea id="item_content" onchange="check_valid()" ></textarea></td>
        </tr>
        <tr><td colspan="2" >&nbsp;</td></tr>
        <tr>
            <td style="width:140px" >抵押类别：</td>
            <td>
                <select id="security_type" onchange="check_valid()" >
                    <option selected value="现金" >现金</option>
                    <option value="身份证" >身份证</option>
                    <option value="驾照" >驾照</option>
                    <option value="护照" >护照</option>
                </select>
            </td>
        </tr>
        <tr><td colspan="2" >&nbsp;</td></tr>
        <tr>
            <td style="width:140px" >抵押内容：</td>
            <td><input type="text" id="security_content" onchange="check_valid()" /></td>
        </tr>
        <tr><td colspan="2" >&nbsp;</td></tr>
        <tr>
            <td style="width:140px" >归还时间：</td>
            <td><input type="text" id="return_date_year" style="width:60px" onchange="check_valid()" />年
                <input type="text" style="width:30px" id="return_date_month" onchange="check_valid()" />月
                <input type="text" style="width:30px" id="return_date_day" onchange="check_valid()" />日
                <input type="text" style="width:30px" id="return_date_hour" onchange="check_valid()" />时</td>
        </tr>
        <tr><td colspan="2" >&nbsp;</td></tr>
        <tr>
            <td colspan="2" ><input type="button" id="btn" disabled  value=" 获 取 二 维 码 "/></td>
        </tr>
        <tr><td colspan="2" >&nbsp;</td></tr>
        <tr>
            <td colspan="2" ></td>
        </tr>
        <tr><td colspan="2" >&nbsp;</td></tr>
    </table>
    <script type="text/javascript" >
        var valid = true;
        var current_date = new Date();
        var year = current_date.getFullYear().toString();
        var month = current_date.getMonth().toString();
        var day = current_date.getDay().toString();
        document.getElementById("return_date_year").value = year;
        document.getElementById("return_date_month").value = month;
        document.getElementById("return_date_day").value = day;

        var item_name = '';
        var item_content = '';
        var security_type = '';
        var security_content = '';
        var return_date_year = '';
        var return_date_month = '';
        var return_date_day = '';
        var return_date_hour = '';

        function check_valid() {
            item_name = document.getElementById("item_name").value.trim();
            item_content = document.getElementById("item_content").value.trim();
            security_type = document.getElementById("security_type").value.trim();
            security_content = document.getElementById("security_content").value.trim();
            return_date_year = document.getElementById("return_date_year").value.trim();
            return_date_month = document.getElementById("return_date_month").value.trim();
            return_date_day = document.getElementById("return_date_day").value.trim();
            return_date_hour = document.getElementById("return_date_hour").value.trim();
            
            if (item_name == '') {
                valid = false;
            }
            if (item_content == '') {
                valid = false;
            }
            if (security_type == '') {
                valid = false;
            }
            if (security_content == '') {
                valid = false;
            }
            if (return_date_year == '') {
                valid = false;
            }
            if (return_date_month == '') {
                valid = false;
            }
            if (return_date_day == '') {
                valid = false;
            }
            if (return_date_hour == '') {
                valid = false;
            }
            if (valid) {
                document.getElementById("btn").disabled = false;
            }
        }
    </script>
</body>
</html>
