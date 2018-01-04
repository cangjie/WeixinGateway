<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {

    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <script type="text/javascript" >
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(
                    function success(pos) {
                        document.writeln(pos.coords.longitude + " ，" + pos.coords.latitude);
                    },
                    function fail(error) {
                    });
            }
        </script>
    </div>
    </form>
</body>
</html>
