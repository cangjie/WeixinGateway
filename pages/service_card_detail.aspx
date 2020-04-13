<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">
    /*
    public string timeStamp = "";
    public string nonceStr = "e4bf6e00dd1f0br0fcab93bd5ae8f";
    public string ticketStr = "";
    public string shaParam = "";
    public string appId = System.Configuration.ConfigurationManager.AppSettings["wxappid"];
    */

    public WeixinUser currentUser;
    public string openId = "";
    //public Ticket ticket;
    public string userToken = "";
    public Card card;
    public Product product;
    public Card.CardPackageUsage[] packageList;

    public Product.ServiceCard cardInfo;

    protected void Page_Load(object sender, EventArgs e)
    {
        int orderId = int.Parse(Util.GetSafeRequestValue(Request, "orderid", "0"));
        string code = Util.GetSafeRequestValue(Request, "code", "");
        if (orderId != 0 && code.Trim().Equals(""))
        {
            int i = 0;
            for (; i < 10 && code.Trim().Equals(""); i++)
            {
                OnlineOrder order = new OnlineOrder(orderId);
                code = order._fields["code"].ToString().Trim();
                if (code.Trim().Equals(""))
                {
                    System.Threading.Thread.Sleep(1000);
                }
            }
        }





        card = new Card(code);

        string currentPageUrl = Request.Url.ToString().Split('?')[0].Trim();
        if (!Request.QueryString.ToString().Trim().Equals(""))
        {
            currentPageUrl = currentPageUrl + "?" + Request.QueryString.ToString().Trim();
        }
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

        if (currentUser.CellNumber.Trim().Equals("") || currentUser.VipLevel < 1)
            Response.Redirect("register_cell_number.aspx?refurl="+Server.UrlEncode(currentPageUrl), true);
        /*
        if (!currentUser.IsBetaUser)
            Response.Redirect("beta_announce.aspx", true);
            */
        if (!currentUser.OpenId.Trim().Equals(card._fields["owner_open_id"].ToString().Trim()))
        {
            Response.Write("error");
            Response.End();
        }
        product = new Product(int.Parse(card._fields["product_id"].ToString()));
        cardInfo = product.cardInfo;
        packageList = card.CardPackageUsageList;
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
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
    <script type="text/javascript" >
        var current_index = 0;
    </script>
</head>
<body>
    <div style="margin-left: 5px" >
        <div id="card-<%=card.Code.Trim()%>" name="card" class="panel panel-info" style="width:350px"  >
            <div class="panel-heading">
                <h3 class="panel-title"><%=product._fields["name"].ToString().Trim()%></h3>
            </div>
            <div class="panel-body">
                    <%=cardInfo.rules.Trim()%>
                <br />
                <div style="text-align:center" >
                    <%if (!cardInfo.isPackage)
                        { %>
                    <img src="/show_wechat_temp_qrcode.aspx?scene=use_service_card_<%=card.Code.Trim() %>"  id="card_img"   style="width:200px; text-align:center"  />
                    <br />
                    <br /><b style="text-align:center" ><%=card.Code.Substring(0, 3) %>-<%=card.Code.Substring(3, 3) %>-<%=card.Code.Substring(6, 3)%></b>
                    <%}
                        else
                        {
                            Card.CardPackageUsage[] packageList = card.CardPackageUsageList;

                            %>
                    <ul class="nav nav-tabs" id="card_tabs">
                        <%
    for (int i = 0; i < packageList.Length; i++)
    {
                             %>
                        <li role="presentation" class="nav-item"  ><a href="#" onclick="show_item(<%=i.ToString() %>)" class="nav-link <%if (i == 0) {%>active<% }%> "><%=packageList[i].name.Trim() %></a></li>
                       
                        <%} %>
                    </ul>
                    <%
                        for (int i = 0; i < packageList.Length; i++)
                        {
                            %>
                    <div name="card_detail" id="card_detail_<%=i.ToString()%>" style="display:<%if (i > 0)
                        { %>none<%}
                    else {%>block<% }%>" >
                        <p><%=packageList[i].name %></p>
                        <%
                            string longCardCode = packageList[i].firstAvaliableCardCode.Trim();
                            if (longCardCode.Trim().Length == 12)
                            {
                                %>
                        <p><img width="200" src="/show_wechat_temp_qrcode.aspx?scene=use_service_card_detail_<%=longCardCode.Trim() %>" /></p>
                        <%
                            }
                             %>
                        <p>剩余：<%=packageList[i].avaliableCount.ToString() %>/总计：<%=packageList[i].totalCount.ToString() %></p>
                        <p>卡号：<%=longCardCode.Substring(0, 3) %>-<%=longCardCode.Substring(3, 3) %>-<%=longCardCode.Substring(6, 3) %>-<%=longCardCode.Substring(9, 3) %></p>
                    </div>
                    <%
                        }
                         %>


                                <%
                        } %>
                </div>
                <%
                    if (product._fields["id"].ToString().Equals("144"))
                    {
                    %>
                <div style="text-align:center" >
                    <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#fill-skis-info-modal">填写/修改 雪板信息</button>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#fill-waybill-modal">填写快递单号</button>
                </div>
                <%
                    }
                    %>
            </div>
        </div>
    </div>
    <script type="text/javascript" >
        function show_item(i) {
            var tabs_arr = document.getElementById("card_tabs").getElementsByTagName("a");
            var div_arr = document.getElementsByName("card_detail");
            for (var j = 0; j < tabs_arr.length; j++) {
                tabs_arr[j].attributes["class"].value = "nav-link";
                div_arr[j].style.display = "none";
            }
            tabs_arr[i].attributes["class"].value = "nav-link active";
            div_arr[i].style.display = "block";

        }
    </script>
    <!-- Modal -->
    <div class="modal fade" id="fill-skis-info-modal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="exampleModalLabel">填写雪具信息</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <div class="modal-body">
            雪板类型：<input type="radio" id="equip_type_ski" name="equip_type" style="width:20px;height:20px" />双板 <input type="radio" style="width:20px;height:20px" id="equip_type_ski_board" name="equip_type" />双板<br />
            雪板品牌：<input type="text" style="width:100px;height:20px" /><br />
            雪板规格：<input type="text" style="width:100px;height:20px" /><br />
            单板固定器品牌：<input type="text" style="width:100px;height:20px" /><br />
            单板固定器颜色：<input type="text" style="width:100px;height:20px" /><br />
            邮寄形式：<input type="radio" id="package_content_label" name="package_content" style="width:20px;height:20px" />万龙存板牌 <input type="radio" id="package_content_equip" name="package_content" style="width:20px;height:20px" />快递雪板<br />
            万龙存板牌编号：<input type="text" style="width:100px;height:20px" /><br />
            存板牌包含的雪板以外的其它物品：<input type="text" style="width:100px;height:20px" />
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal">关闭</button>
            <button type="button" class="btn btn-primary">保存</button>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal -->
    <div class="modal fade" id="fill-waybill-modal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="exampleModalLabel2">填写快递信息</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <div class="modal-body">
            保存后，已填写的雪板信息不可修改<br /><br />
            快递公司：<input type="text" style="width:100px;height:20px" /><br /><br />
            快递单号：<input type="text" style="width:100px;height:20px" />
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal">关闭</button>
            <button type="button" class="btn btn-primary">保存</button>
          </div>
        </div>
      </div>
    </div>

</body>
</html>