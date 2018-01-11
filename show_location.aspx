<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    public string timeStamp = "";
    public string nonceStr = "e4bf6e00dd1f0br0fcab93bd5ae8f";
    public string ticketStr = "";
    public string shaParam = "";
    public string appId = System.Configuration.ConfigurationManager.AppSettings["wxappid"];



    protected void Page_Load(object sender, EventArgs e)
    {
        timeStamp = Util.GetTimeStamp().Trim();
        ticketStr = Util.GetTicket();
        string shaString = "jsapi_ticket=" + ticketStr.Trim() + "&noncestr=" + nonceStr.Trim()
            + "&timestamp=" + timeStamp.Trim() + "&url=" + Request.Url.ToString().Trim();
        shaParam = Util.GetSHA1(shaString);
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.2.0.js" ></script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <script type="text/javascript" >

        </script>
    </div>
    </form>
</body>
</html>
<script type="text/javascript" >
    wx.config({
            debug: false, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
            appId: '<%=appId%>', // 必填，公众号的唯一标识
            timestamp: '<%=timeStamp%>', // 必填，生成签名的时间戳
            nonceStr: '<%=nonceStr%>', // 必填，生成签名的随机串
            signature: '<%=shaParam %>', // 必填，签名，见附录1
            jsApiList: [
                    'openLocation',
                    'getLocation']
    });

    wx.ready(function () {
        wx.getLocation({
            type: 'wgs84', // 默认为wgs84的gps坐标，如果要返回直接给openLocation用的火星坐标，可传入'gcj02'
            success: function (res) {
                var latitude = res.latitude; // 纬度，浮点数，范围为90 ~ -90
                var longitude = res.longitude; // 经度，浮点数，范围为180 ~ -180。
                var speed = res.speed; // 速度，以米/每秒计
                var accuracy = res.accuracy; // 位置精度
                var done = false;
                if (longitude < 115.75 && latitude > 40)
                {
                    alert("万龙" + " " + longitude + " " + latitude);
                    done = true;
                }
                if (longitude > 115.75 && longitude < 116.25 && latitude < 40)
                {
                    alert("八易" + " " + longitude + " " + latitude);
                    done = true;
                }
                if (longitude > 116.5 && longitude < 116.75 && latitude > 40 && latitude < 40.25)
                {
                    alert("乔波" + " " + longitude + " " + latitude);
                    done = true;
                }
                if (longitude > 116.75 && latitude > 40.25)
                {
                    alert("南山" + " " + longitude + " " + latitude);
                    done = true;
                }
                if (!done)
                {
                    //alert(longitude + " " + latitude);
                    alert("万龙" + " " + longitude + " " + latitude);
                }
                //alert(latitude + " " + longitude);
            }
        });
    });
</script>