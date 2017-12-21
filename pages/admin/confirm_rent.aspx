<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    public int i = 0;

    protected void Page_Load(object sender, EventArgs e)
    {
        string id = Util.GetSafeRequestValue(Request, "id", "1");
        string openId = Util.GetSafeRequestValue(Request, "openid", "aaa");
        i = DBHelper.InsertData("rent_log", new string[,] {
            {"product_id", "int", id.Trim() }, {"rent_user_open_id", "varchar", openId.Trim() },
            {"rent_time", "datetime", DateTime.Now.ToString() }});
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    <%
        if (i == 1)
        {
            %>
        开始试滑
        <%
            }
            else
            {
                %>
        系统故障
                    <%
            }
         %>
    </div>
    </form>
</body>
</html>
