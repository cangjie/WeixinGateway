<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="js/jquery.min.js"></script>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="js/bootstrap.min.js"></script>
    <script type="text/javascript" >
        var start_time_string = "2019-9-30 15:00:00".replace(/-/g,'/');
        var start_time = Date.parse(start_time_string)/1000;
        var current_time = <%=Util.GetServerLocalTimeStamp()%>;

        function syn_time() {
            $.ajax({
                url: "/api/get_server_time_stamp.aspx",
                type: "GET",
                success: function (msg, status) {
                    var msg_object = eval("(" + msg + ")");
                    current_time = parseInt(msg_object.timestamp);
                }
            });
        }

        function display_seconds() {
            var div = document.getElementById("show_seconds");
            if (div.innerText.trim() == '') {
                div.innerText = (start_time - current_time).toString();
            }
            else {
                var div_seconds = parseInt(document.getElementById("show_seconds").innerText.trim());
                div_seconds--;
                document.getElementById("show_seconds").innerText = div_seconds.toString();
            }
        }

        var syn_time_handle = setInterval("syn_time()", 10000);

        var display_time_handle = setInterval("display_seconds()", 1000);

        syn_time();
    </script>
</head>
<body>
    <form id="form1" runat="server">
        距<script type="text/javascript">
             document.write(start_time_string)
         </script>秒杀开始，还有：
    <div id="show_seconds">
    
    </div>秒

        <br />
        <script type="text/javascript" >
            document.write(start_time.toString() + "<br/>" + current_time.toString());
        </script>
    </form>
</body>
</html>
