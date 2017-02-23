<%@ Page Language="C#" %>
<script runat="server">

    public WeixinUser currentUser;

    public string openId = "";

    public string userToken = "4aa99be7feb90a931ed9deb37ecbf4e948aac5a667babce1a93b6cf35a0283bdfca491e9";

    public double unitPrice = 0;

    public int productId = 0;

    protected void Page_Load(object sender, EventArgs e)
    {
        productId = int.Parse(Util.GetSafeRequestValue(Request, "productid", "16"));

        Product product = new Product(productId);

        unitPrice = double.Parse(product._fields["sale_price"].ToString());

        string currentPageUrl = Server.UrlEncode("/pages/activity_registrtion.aspx");
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
            Response.Redirect("register_cell_number.aspx?refurl=" + currentPageUrl, true);

        int orderId = OnlineOrder.GetAcivityOrderId(openId, productId);
        if (orderId != 0)
            Response.Redirect("activity_registration_review.aspx?orderid=" + orderId.ToString(), true);

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

        var product_id = <%=productId%>;
        var unit_price = <%=unitPrice%>;


        var local_storage_key = "snow_meet_act_" + product_id + "_registration";
        var registration_json = get_registration_info_from_local_storage();
        var person_json_str_template = '{ "name": "", "cell_number": "<%=currentUser.CellNumber.Trim() %>", "length": "", "boot_size": "", "rent": 0, "idcard": ""}';
        function update_registration_json() {
            registration_json.my_registration.name = document.getElementById("text_name").value;
            registration_json.my_registration.cell_number = document.getElementById("text_cell").value;
            registration_json.my_registration.idcard = document.getElementById("text_idcard").value;
            registration_json.my_registration.rent = document.getElementById("check_rent").checked ? 1 : 0;
            if (registration_json.my_registration.rent == 1) {
                registration_json.my_registration.boot_size = document.getElementById("text_boot_size").value;
                registration_json.my_registration.length = document.getElementById("text_length").value;
            }
            else {
                registration_json.my_registration.boot_size = "";
                registration_json.my_registration.length = "";
            }
            window.localStorage.setItem(local_storage_key, JSON.stringify(registration_json));
            fill_page();
        }

        function get_registration_info_from_local_storage() {
            var success_get = true;
            try{
                var registration_json_str = window.localStorage.getItem(local_storage_key);
                var registration_json = JSON.parse(registration_json_str);
                if (registration_json.my_registration == NaN || registration_json.my_registration == undefined
                    || registration_json.others_registration == NaN || registration_json.others_registration == undefined) {
                    success_get = false;
                }
                else {
                    return registration_json;
                }
                
            }
            catch (e) {
                success_get = false;
            }
            if (!success_get) {
                
                var registration_json_str = '{"my_registration": ' + person_json_str_template + ', "others_registration": []  }';
                return JSON.parse(registration_json_str);
            }
            else
                return null;
        }

        function launch_add_person_modal() {
            $("#booking_modal").modal();
        }
        function add_person_from_modal_input() {
            var others_person_json = JSON.parse(person_json_str_template);
            others_person_json.name = document.getElementById("text_add_name").value;
            document.getElementById("text_add_name").value = "";
            others_person_json.cell_number = document.getElementById("text_add_cell").value;
            document.getElementById("text_add_cell").value = "";
            others_person_json.idcard = document.getElementById("text_add_idcard").value;
            document.getElementById("text_add_idcard").value = "";
            others_person_json.rent = document.getElementById("check_add_rent").checked ? 1 : 0;
            document.getElementById("check_add_rent").checked = false;
            if (others_person_json.rent == 1) {
                others_person_json.boot_size = document.getElementById("text_add_boot_size").value;
                document.getElementById("text_add_boot_size").value = "";
                document.getElementById("text_add_boot_size").disabled = true;
                others_person_json.length = document.getElementById("text_add_length").value;
                document.getElementById("text_add_length").value = "";
                document.getElementById("text_add_length").disabled = true;
            }
            else {
                others_person_json.boot_size = "";
                others_person_json.length = "";
            }
            registration_json.others_registration.push(others_person_json);
            update_registration_json();
            //alert(JSON.stringify(registration_json));
        }
        function enable_rent_items() {
            document.getElementById("text_add_boot_size").value = "";
            document.getElementById("text_add_length").value = "";
            if (document.getElementById("check_add_rent").checked) {
                document.getElementById("text_add_boot_size").disabled = false;
                document.getElementById("text_add_length").disabled = false;
            }
            else {
                document.getElementById("text_add_boot_size").disabled = true;
                document.getElementById("text_add_length").disabled = true;
            }
                
        }
        function pay() {
            var cart_item_json = '';
            var token = '<%=userToken%>';
            for (var i = 0; i <= registration_json.others_registration.length; i++) {
                if (i == 0) {
                    cart_item_json = '{"product_id": "' + product_id + '", "count": "1", "memo": '
                        + JSON.stringify(registration_json.my_registration) + '}';
                }
                else {
                    cart_item_json = cart_item_json + ', {"product_id": "' + product_id + '", "count": "1", "memo": '
                        + JSON.stringify(registration_json.others_registration[i - 1]) + '}';
                }
            }
            cart_item_json = '{"cart_array": [' + cart_item_json + ']}';
            $.ajax({
                url: "/api/place_online_order.aspx",
                async: false,
                type: "GET",
                data: { "cart": cart_item_json, "token": token },
                success: function(msg, status) {
                    var msg_object = eval("(" + msg + ")");
                    window.location.href = "../payment/haojin_pay_online_order.aspx?orderid=" + msg_object.order_id;
                },
                error: function (msg, status) {
                    alert("error");
                }
            });
        }
    </script>
</head>
<body>
    <div><h1>2017-3-10~2017-3-12 第三期北大湖活动（预付款<span id="unit_price" ></span>/人起）</h1></div>
    <div>共<span id="span_person_count" >1</span>人参加活动，其中<span id="span_person_rent_count" >1</span>人租板，需要预先缴纳<span id="span_amount_summary" >1</span>元。<div><button type="button" onclick="pay()" class="btn btn-success" >现在支付</button></div></div>
    <div class="panel panel-danger" >
        <div class="panel-heading"><h3 class="panel-title">联系人</h3></div>
        <div class="panel-body" >
            <div class="row" >
                <div class="col-xs-4" >姓名：</div>
                <div class="col-xs-8" ><input type="text" id="text_name" onchange="update_registration_json()" /></div>
            </div>
            <div class="row" >
                <div class="col-xs-4" >电话：</div>
                <div class="col-xs-8" ><input type="text" id="text_cell" onchange="update_registration_json()" /></div>
            </div>
            <div class="row" >
                <div class="col-xs-4" >身份证：</div>
                <div class="col-xs-8" ><input type="text" id="text_idcard" onchange="update_registration_json()" /></div>
            </div>
            <div class="row" >
                <div class="col-xs-4" ></div>
                <div class="col-xs-8" ><input type="checkbox" id="check_rent" onchange="update_registration_json()" />我要租板</div>
            </div>
            <div class="row" >
                <div class="col-xs-4" >身高：</div>
                <div class="col-xs-8" ><input type="text" id="text_length" onchange="update_registration_json()" /></div>
            </div>
            <div class="row" >
                <div class="col-xs-4" >鞋码：</div>
                <div class="col-xs-8" ><input type="text" id="text_boot_size" onchange="update_registration_json()" /></div>
            </div>
        </div>
    </div>
    <div><button type="button" class="btn btn-success" onclick="launch_add_person_modal()" >添加雪友</button></div>
    <div><br /></div>
    <div id="others_person">
        <div class="panel panel-info" id="others_person_template" name="others_person_info" style="display:none" >
            <div class="panel-heading"><h3 class="panel-title">雪友</h3></div>
            <div class="panel-body" >
                <div class="row" >
                    <div class="col-xs-4" >姓名：</div>
                    <div class="col-xs-8" name="div_add_name" ></div>
                </div>
                <div class="row" >
                    <div class="col-xs-4" >电话：</div>
                    <div class="col-xs-8" name="div_add_cell" ></div>
                </div>
                <div class="row" >
                    <div class="col-xs-4" >身份证：</div>
                    <div class="col-xs-8" name="div_add_id_card" ></div>
                </div>
                <div class="row" >
                    <div class="col-xs-4" ></div>
                    <div class="col-xs-8" name="div_add_rent" ></div>
                </div>
                <div class="row" >
                    <div class="col-xs-4" >身高：</div>
                    <div class="col-xs-8" name="div_add_length" ></div>
                </div>
                <div class="row" >
                    <div class="col-xs-4" >鞋码：</div>
                    <div class="col-xs-8" name="div_add_boot_size" ></div>
                </div>
                <div class="row" >
                    <div class="col-xs-12" ><button class="btn btn-danger" name="btn_del"  >删 除</button></div>
                </div>
            </div>
        </div>
    </div>
    <div id="booking_modal" class="modal fade bs-example-modal-lg" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header" id="modal-header" >添加同行雪友</div>
                <div class="modal-body" >
                    <div class="row" >
                        <div class="col-xs-4" >姓名：</div>
                        <div class="col-xs-8" ><input type="text" id="text_add_name" /></div>
                    </div>
                    <div class="row" >
                        <div class="col-xs-4" >电话：</div>
                        <div class="col-xs-8" ><input type="text" id="text_add_cell" /></div>
                    </div>
                    <div class="row" >
                        <div class="col-xs-4" >身份证：</div>
                        <div class="col-xs-8" ><input type="text" id="text_add_idcard" /></div>
                    </div>
                    <div class="row" >
                        <div class="col-xs-4" ></div>
                        <div class="col-xs-8" ><input type="checkbox" onchange="enable_rent_items()"  id="check_add_rent"/>我要租板</div>
                    </div>
                    <div class="row" >
                        <div class="col-xs-4" >身高：</div>
                        <div class="col-xs-8" ><input type="text" id="text_add_length" disabled /></div>
                    </div>
                    <div class="row" >
                        <div class="col-xs-4" >鞋码：</div>
                        <div class="col-xs-8" ><input type="text" id="text_add_boot_size" disabled /></div>
                    </div>
                    <div class="modal-footer" >
                        <button class="btn btn-success" data-dismiss="modal" onclick="add_person_from_modal_input()"  >确  认</button>
                        <button class="btn btn-danger" data-dismiss="modal"  >取 消</button>
                    </div>
                </div>    
            </div>
        </div>
    </div>
</body>
</html>
<script type="text/javascript" >
    function fill_page() {
        document.getElementById("text_name").value = registration_json.my_registration.name;
        document.getElementById("text_cell").value = registration_json.my_registration.cell_number;
        document.getElementById("text_idcard").value = registration_json.my_registration.idcard;
        document.getElementById("check_rent").checked = registration_json.my_registration.rent == 0 ? false : true;
        document.getElementById("unit_price").innerHTML = unit_price;
        if (document.getElementById("check_rent").checked) {
            document.getElementById("text_boot_size").disabled = false;
            document.getElementById("text_length").disabled = false;
            document.getElementById("text_boot_size").value = registration_json.my_registration.boot_size;
            document.getElementById("text_length").value = registration_json.my_registration.length;
        }
        else {
            document.getElementById("text_boot_size").disabled = true;
            document.getElementById("text_length").disabled = true;
            document.getElementById("text_boot_size").value = "";
            document.getElementById("text_length").value = "";
        }
        var others_person_template = document.getElementById("others_person_template");
        var div_others_person = document.getElementById("others_person");
        var child_count = div_others_person.childElementCount;
        for (var i = 1; i < child_count; i++)
            div_others_person.removeChild(div_others_person.lastChild);
        for (var i = 0; i < registration_json.others_registration.length; i++) {
            var new_node = others_person_template.cloneNode();
            new_node.style.display = "";
            new_node.innerHTML = others_person_template.innerHTML;
            document.getElementById("others_person").appendChild(new_node);
            var onclick_attr = document.createAttribute("onclick");
            onclick_attr.value = "del_person(" + i + ")";
            var btn_del_arr = document.getElementsByName("btn_del");
            var last_child_index = btn_del_arr.length - 1
            btn_del_arr[last_child_index].attributes.setNamedItem(onclick_attr);
            document.getElementsByName("div_add_name")[last_child_index].innerHTML = registration_json.others_registration[i].name;
            document.getElementsByName("div_add_cell")[last_child_index].innerHTML = registration_json.others_registration[i].cell_number;
            document.getElementsByName("div_add_id_card")[last_child_index].innerHTML = registration_json.others_registration[i].idcard;
            document.getElementsByName("div_add_rent")[last_child_index].innerHTML = registration_json.others_registration[i].rent == 0 ? "自带板" : "租板"
            if (document.getElementsByName("div_add_rent")[last_child_index].innerHTML == "租板") {
                document.getElementsByName("div_add_length")[last_child_index].innerHTML = registration_json.others_registration[i].length;
                document.getElementsByName("div_add_boot_size")[last_child_index].innerHTML = registration_json.others_registration[i].boot_size;
            }
            else {
                document.getElementsByName("div_add_length")[last_child_index].innerHTML = "-";
                document.getElementsByName("div_add_boot_size")[last_child_index].innerHTML = "-";
            }
        }
        document.getElementById("span_person_count").innerHTML = registration_json.others_registration.length + 1;
        var rent_num = 0;
        if (registration_json.my_registration.rent)
            rent_num++;
        for (var i = 0; i < registration_json.others_registration.length; i++) {
            if (registration_json.others_registration[i].rent)
                rent_num++;
        }
        document.getElementById("span_person_rent_count").innerHTML = rent_num;
        document.getElementById("span_amount_summary").innerHTML = (registration_json.others_registration.length + 1) * unit_price;
    }
    fill_page();
    function del_person(i) {
        var old_arr = registration_json.others_registration;
        var new_arr = JSON.parse("[]");
        for (var j = 0; j < old_arr.length; j++) {
            if (i != j) {
                new_arr.push(old_arr[j]);
            }
        }
        registration_json.others_registration = new_arr;
        update_registration_json();
    }
</script>
