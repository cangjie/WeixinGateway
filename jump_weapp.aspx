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
    <script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.6.0.js" ></script>
</head>
<body>

        <div>
            <wx-open-launch-weapp id="launch-btn" username="gh_073f25bbdadc" path="pages/index/index" >
                <template>
                    <style>.btn { padding: 12px }</style>
                    <button class="btn">打开小程序</button>
                </template>
            </wx-open-launch-weapp>
            <script>
                var btn = document.getElementById('launch-btn');
                btn.addEventListener('launch', function (e) {
                    console.log('success');
                });
                btn.addEventListener('error', function (e) {
                    console.log('fail', e.detail);
                });
            </script>
        </div>
</body>
</html>
