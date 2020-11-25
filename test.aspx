<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.Net" %>
<!DOCTYPE html>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
<<<<<<< HEAD
        string aa = "aa";
=======

>>>>>>> 6464c3e8cc168d90309b650afaae20957f2157f7
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="/pages/js/jquery.min.js"></script>
    <script type="text/javascript" >
        $.ajax({
            url: '/api/common_data_helper.aspx',
            type: 'post',
            data: "{ 'status': 0, 'test_message': 'test' }",
            success: function (msg) {
                var msg_obj = eval('(' + msg + ')');
                alert(msg_obj.test_message);
            }
        });
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
       
    </div>
    </form>
</body>
</html>
