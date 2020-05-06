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
            //Response.Write("error");
            //Response.End();
        }
        product = new Product(int.Parse(card._fields["product_id"].ToString()));
        if (product._fields["id"].ToString().Equals("145"))
        {
            Response.Redirect("service_card_detail_covid19_express_trans.aspx?code=" + code.Trim(), true);
        }
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
        <div id="card-<%=card.Code.Trim()%>" name="card" class="panel panel-info" style="width:390px"  >
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
                <script type="text/javascript">

                    var has_fill_info = false;
                    var has_fill_waybill = false;
                    $.ajax({
                        url: '/api/maintain_equip_service_card_info_20_get.aspx?cardno=<%=card.Code.Trim() %>',
                        type: 'GET',
                        success: function (msg, status) {
                            var msg_object = eval("(" + msg + ")");
                            if (msg_object.covid19_service.length > 0) {
                                has_fill_info = true;
                                if (msg_object.covid19_service[0].waybill_no != '') {
                                    has_fill_waybill = true;
                                }
                            }
                            if (!has_fill_info) {
                                $('#fill-skis-info-modal').modal('show');
                            }
                            if (has_fill_info && !has_fill_waybill) {
                                $('#fill-waybill-modal').modal('show');
                                document.getElementById('btn_fill_waybill').disabled = '';
                            }
                            if (has_fill_waybill) {
                                document.getElementById('btn_fill_info').disabled = 'disabled';
                            }

                            display_info();
                        }
                    });
                    
                </script>
                <div style="text-align:center" >
                    <button id="btn_fill_info" type="button" class="btn btn-primary" data-toggle="modal" data-target="#fill-skis-info-modal">填写/修改 雪板信息</button>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <button id="btn_fill_waybill" type="button" class="btn btn-primary" data-toggle="modal" data-target="#fill-waybill-modal" disabled="disabled" >填写快递单号</button>
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
            雪板类型：<input type="radio" id="equip_type_ski" name="equip_type" style="width:20px;height:20px" />双板 <input type="radio" style="width:20px;height:20px" id="equip_type_ski_board" name="equip_type" />单板<br />
            雪板品牌：<input type="text" id="equip_brand" style="width:100px;height:20px" /><br />
            雪板规格：<input type="text" id="equip_scale" style="width:100px;height:20px" /><br />
            单板固定器品牌：<input  id="board_binder_brand" type="text" style="width:100px;height:20px" /><br />
            单板固定器颜色：<input id="board_binder_color" type="text" style="width:100px;height:20px" /><br />
            邮寄形式：<input type="radio" id="package_content_label" name="package_content" style="width:20px;height:20px" />万龙存板牌 <input type="radio" id="package_content_equip" name="package_content" style="width:20px;height:20px" />快递雪板<br />
            万龙存板牌编号：<input type="text" id="wanlong_no" style="width:100px;height:20px" /><br />
            存板牌包含的雪板以外的其它物品：<input id="others_in_wanlong" type="text" style="width:100px;height:20px" />
            是否寄存：<input type="radio" id="keep" name="is_keep" style="width:20px;height:20px" />寄存 <input type="radio" style="width:20px;height:20px" id="unkeep" name="is_keep" />不寄存<br />
            不寄存快递联系人：<input type="text" id="contact" style="width:100px;height:20px" /><br />
            快递地址：<input type="text" id="address" style="width:200px;height:20px" /><br />
            联系电话：<input type="text" id="contact_cell" style="width:150px;height:20px" /><br />
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal">关闭</button>
            <button type="button" class="btn btn-primary" onclick="fill_info()" >保存</button>
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
            快递公司：<input type="text" id="express_company" style="width:100px;height:20px" /><br /><br />
            快递单号：<input type="text" id="waybill_no" style="width:100px;height:20px" />
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal">关闭</button>
            <button type="button" class="btn btn-primary" onclick="fill_info()" >保存</button>
          </div>
        </div>
      </div>
    </div>
    <script type="text/javascript" >
        var ctl_equip_type_ski = document.getElementById('equip_type_ski');
        var ctl_equip_type_ski_board = document.getElementById('equip_type_ski_board');
        var ctl_equip_brand = document.getElementById('equip_brand');
        var ctl_equip_scale = document.getElementById('equip_scale');
        var ctl_board_binder_brand = document.getElementById('board_binder_brand');
        var ctl_board_binder_color = document.getElementById('board_binder_color');
        var ctl_package_content_label = document.getElementById('package_content_label');
        var ctl_package_content_equip = document.getElementById('package_content_equip');
        var ctl_wanlong_no = document.getElementById('wanlong_no');
        var ctl_others_in_wanlong = document.getElementById('others_in_wanlong');
        var ctl_express_company = document.getElementById('express_company');
        var ctl_waybill_no = document.getElementById('waybill_no');
        var ctl_keep = document.getElementById('keep');
        var ctl_unkeep = document.getElementById('unkeep');
        var ctl_address = document.getElementById('address');
        var ctl_contact = document.getElementById('contact');
        var ctl_cell = document.getElementById('contact_cell');

        function display_info() {
            $.ajax({
                url: '/api/maintain_equip_service_card_info_20_get.aspx?cardno=<%=card.Code.Trim()%>',
                type: 'GET',
                success: function (msg, status) {
                    var msg_obj = eval('(' + msg + ')');
                    if (msg_obj.status == 0 && msg_obj.covid19_service.length > 0) {
                        if (msg_obj.covid19_service[0].equip_type == '双板') {
                            ctl_equip_type_ski.checked = true;
                            ctl_equip_type_ski_board.checked = false;
                        }
                        else {
                            ctl_equip_type_ski.checked = false;
                            ctl_equip_type_ski_board.checked = true;
                        }
                        ctl_equip_brand.value = msg_obj.covid19_service[0].equip_brand.trim();
                        ctl_equip_scale.value = msg_obj.covid19_service[0].equip_scale.trim();
                        ctl_board_binder_brand.value = msg_obj.covid19_service[0].board_binder_brand.trim();
                        ctl_board_binder_color.value = msg_obj.covid19_service[0].board_binder_color.trim();
                        if (msg_obj.covid19_service[0].send_item == '万龙存板牌') {
                            ctl_package_content_label.checked = true;
                            ctl_package_content_equip.checked = false;
                        }
                        else {
                            ctl_package_content_label.checked = false;
                            ctl_package_content_equip.checked = true;
                        }
                        ctl_wanlong_no.value = msg_obj.covid19_service[0].wanlong_no.trim();
                        ctl_others_in_wanlong.value = msg_obj.covid19_service[0].others_in_wanlong.trim();
                        ctl_express_company.value = msg_obj.covid19_service[0].express_company.trim();
                        ctl_waybill_no.value = msg_obj.covid19_service[0].waybill_no.trim();

                        var keep = false;

                        if (msg_obj.covid19_service[0].cell.trim() == ''
                            && msg_obj.covid19_service[0].address.trim() == ''
                            && msg_obj.covid19_service[0].contact_name.trim() == '') {
                            keep = true;
                        }
                        if (keep) {
                            ctl_keep.checked = true;
                            ctl_unkeep.checked = false;
                            ctl_contact.value = '';
                            ctl_cell.value = '';
                            ctl_address.value = '';
                        }
                        else {
                            ctl_keep.checked = false;
                            ctl_unkeep.checked = true;
                            ctl_contact.value = msg_obj.covid19_service[0].contact_name.trim();
                            ctl_cell.value = msg_obj.covid19_service[0].cell.trim();
                            ctl_address.value = msg_obj.covid19_service[0].address.trim();
                        }

                    }
                }
            });
        }
        function fill_info() {
            if (ctl_equip_type_ski_board.checked) {
                if (ctl_board_binder_brand.value == '' && ctl_board_binder_color.value == '') {
                    alert('单板的固定器品牌和颜色必须告知其一。');
                    ctl_board_binder_brand.focus();
                    return;
                }
            }
            if (ctl_package_content_label.checked && ctl_wanlong_no.value == '') {
                alert('如果邮寄万龙存板牌，请填写编号。');
                ctl_wanlong_no.focus();
                return;
            }
            if (ctl_unkeep.checked && (ctl_contact.value.trim() == ''
                || ctl_cell.value.trim() == '' || ctl_address.value.trim())) {
                alert('如果不寄存，请填写联系人，电话以及快递地址。');
                ctl_cell.focus();
                $('#fill-skis-info-modal').modal('show');
                return;
            }
            var equip_type = (ctl_equip_type_ski.checked ? '双板' : '单板');
            var send_item = (ctl_package_content_label.checked ? '万龙存板牌' : '雪板');
            var post_json = '{"token": "<%=userToken%>", "card_no": "<%=card.Code.Trim()%>", "equip_type": "' + equip_type + '", '
                + '"equip_brand": "' + ctl_equip_brand.value.trim() + '", "equip_scale": "' + ctl_equip_scale.value.trim() + '", '
                + '"board_binder_brand": "' + ctl_board_binder_brand.value.trim() + '", "board_binder_color": "' + ctl_board_binder_color.value.trim() + '", '
                + '"send_item": "' + send_item.trim() + '", "wanlong_no": "' + ctl_wanlong_no.value.trim() + '", "others_in_wanlong": "' + ctl_others_in_wanlong.value.trim() + '", '
                + '"contact_name": "' + ctl_contact.value.trim() + '", "address": "' + ctl_address.value.trim() + '", "cell": "' + ctl_cell.value.trim() + '", '
                + '"express_company": "' + ctl_express_company.value.trim() + '", "waybill_no": "' + ctl_waybill_no.value.trim() + '" }';
            $.ajax({
                url: '/api/maintain_equip_service_card_info_20.aspx',
                type: 'POST',
                data: post_json,
                success: function (msg, status) {
                    var msg_obj = eval('(' + msg + ')');
                    if (msg_obj.status == 0) {
                        alert('信息保存成功，请尽快于快递发出后填写快递单号。');
                        window.location.reload();
                    }
                }

            });
        }
    </script>
</body>
</html>