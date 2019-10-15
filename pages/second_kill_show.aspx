<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    public WeixinUser currentUser;

    public string userToken = "";

    public string openId = "";

    public SecondKill secondKillItem;

    public int id;

    public DateTime startTime;

    protected void Page_Load(object sender, EventArgs e)
    {
        string currentPageUrl = Request.Url.ToString();
        if (Session["user_token"] == null || Session["user_token"].ToString().Trim().Equals(""))
        {
            Response.Redirect("../authorize.aspx?callback=" + currentPageUrl, true);
        }
        userToken = Session["user_token"].ToString();
        openId = WeixinUser.CheckToken(userToken);
        if (openId.Trim().Equals(""))
        {
            Response.Redirect("../authorize.aspx?callback=" + currentPageUrl, true);
        }
        currentUser = new WeixinUser(WeixinUser.CheckToken(userToken));


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
        startTime = secondKillItem.activityStartTime;
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
                <br />开始时间：<%=startTime.Year.ToString() %>年<%=startTime.Month.ToString() %>月<%=startTime.Day.ToString() %>日 <%=startTime.Hour.ToString() %>:<%=startTime.Minute.ToString() %>
                还剩 <span id="second_num" > 23 </span> 秒 <button type="button" class="btn btn-warning" data-toggle="modal" data-target="#exampleModalCenter"> 点 击 秒 杀 </button>
            </div>
        </div>
    </div>
    <div class="modal fade" id="exampleModalCenter" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLongTitle">输入验证码</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body" style="align-self:center"><input id="verify_code" style="width:75px" /> <img src="/show_image_verify_code.aspx" /></div>
                <div class="modal-footer">
                    <!--button type="button" class="btn btn-secondary" data-dismiss="modal">Close</!--butto-->
                    <button type="button" class="btn btn-warning"> 验证码输入无误，开始秒杀！</button>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
