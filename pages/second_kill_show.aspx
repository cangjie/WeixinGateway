<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    public SecondKill secondKillItem;

    public int id;

    protected void Page_Load(object sender, EventArgs e)
    {
        id = int.Parse(Util.GetSafeRequestValue(Request, "id", "64"));
        bool existsInMemory = true;
        string applicationHandle = "second_kill_" + id.ToString();
        if (Application[applicationHandle] == null)
        {
            existsInMemory = false;
        }
        else
        {
            try
            {
                secondKillItem = (SecondKill)Application[applicationHandle];
            }
            catch
            {
                existsInMemory = false;
            }
        }
        if (!existsInMemory)
        {
            secondKillItem = new SecondKill(id);
            Application.Lock();
            Application[applicationHandle] = secondKillItem;
            Application.UnLock();
        }
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>易龙雪聚-秒杀商品-<%=secondKillItem.name.Trim() %></title>
    <!-- 新 Bootstrap 核心 CSS 文件 -->
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="css/normalize.css" />
    <!-- 可选的Bootstrap主题文件（一般不用引入） -->
    <link rel="stylesheet" href="css/bootstrap-theme.min.css">
    <!-- jQuery文件。务必在bootstrap.min.js 之前引入 -->
    <script src="js/jquery.min.js"></script>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="js/bootstrap.min.js"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
</head>
<body>
    <div class="container" >
        <div class="row" >
            <div class="col" style="height:100px">
                <br />
                <center>商品大图</center>
            </div>
        </div>
        <div class="row">
            <div class="col" >
                秒杀价格：<%=Math.Round(secondKillItem.killingPrice,2).ToString() %>元 
                活动价格：<%=Math.Round(secondKillItem.activityPrice, 2).ToString() %>元 
                开始时间：<%=secondKillItem.activityStartTime.ToString() %>
            </div>
        </div>
    </div>
</body>
</html>
