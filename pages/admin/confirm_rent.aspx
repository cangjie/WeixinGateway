<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    public int i = 0;

    protected void Page_Load(object sender, EventArgs e)
    {
        string id = Util.GetSafeRequestValue(Request, "id", "1");
        string openId = Util.GetSafeRequestValue(Request, "openid", "aaa");

        if (DBHelper.GetDataTable(" select * from rent_log where product_id = " + id.Trim() + " and return_time is null ").Rows.Count == 0)
        {

            i = DBHelper.InsertData("rent_log", new string[,] {
            {"product_id", "int", id.Trim() }, {"rent_user_open_id", "varchar", openId.Trim() },
            {"rent_time", "datetime", DateTime.Now.ToString() }});
        }
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
