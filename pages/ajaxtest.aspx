<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">

    <title></title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">

     <script src="docs/js/jquery.min.js"></script>
    <script src="docs/js/bootstrap.min.js"></script>
    <script src="docs/js/highlight.js"></script>
    <script src="dist/js/bootstrap-switch.min.js"></script>
    <script src="docs/js/main.js"></script>
    
    
    <script type="text/javascript" >

        function test() {
           
            $.ajax({
                url: "../api/ajax_test.aspx",
                type: "post",
                success: function (data, status) {
                    alert(eval("(" + data + ")").status);
                },
                error: function (request, status, err) {
                    alert(request + status + err);
                }
            });
        }

    </script>

</head>
<body>
    <form id="form1" runat="server">
    <div>
        <input type="button" value="ajax test"  onclick="test()" />
    </div>
    </form>
</body>
</html>
