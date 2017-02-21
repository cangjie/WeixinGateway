﻿<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {

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
        var local_storage_key = "snow_meet_act_16_registration";
        var registration_json = get_registration_info_from_local_storage();
        var person_json_str_template = '{ "name": "", "cell_number": "", "length": "", "boot_size": "", "rent": 0, "idcard": ""}';
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
            others_person_json.cell_number = document.getElementById("text_add_cell").value;
            others_person_json.idcard = document.getElementById("text_add_idcard").value;
            others_person_json.rent = document.getElementById("check_add_rent").checked ? 1 : 0;
            if (others_person_json.rent == 1) {
                others_person_json.boot_size = document.getElementById("text_add_boot_size").value;
                others_person_json.length = document.getElementById("text_add_length").value;
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
    </script>
</head>
<body>
    <div><h1>2017-3-10~2017-3-12 第三期北大湖活动（预付款1500元/人起）</h1></div>
    <div>共xxx人参加活动，其中xxx人租板，需要预先缴纳xxx元。<div><button type="button" class="btn btn-success" >现在支付</button></div></div>
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
            <div class="panel-heading"><h3 class="panel-title">联系人</h3></div>
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
        //alert(others_person_template.innerHTML);
        
        var div_others_person = document.getElementById("others_person");
        //alert(div_others_person.innerHTML);
        //div_others_person.innerHTML = others_person_template.outerHTML;
        //alert(div_others_person.innerHTML);
        var child_count = div_others_person.childElementCount;
        for (var i = 1; i < child_count; i++)
            div_others_person.removeChild(div_others_person.lastChild);
        //alert(div_others_person.childElementCount);
        //alert(registration_json.others_registration.length);
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
            //alert(div_others_person.innerHTML);
        }
        
        /*
        for (var i = 0; i < 5; i++) {
            var new_node = others_person_template.cloneNode();
            alert(document.getElementsByName("btn_del").length);
            new_node.style.display = "";
            new_node.innerHTML = others_person_template.innerHTML;
            var id_attr = document.createAttribute("id");
            id_attr.value = "others_" + i;
            new_node.attributes.setNamedItem(id_attr);
            document.getElementById("others_person").appendChild(new_node);
            var onclick_attr = document.createAttribute("onclick");
            onclick_attr.value = "del_person(" + i + ")";
            var btn_del_arr = document.getElementsByName("btn_del");
            btn_del_arr[btn_del_arr.length - 1].attributes.setNamedItem(onclick_attr);
        }
        */
        

        
    }
    fill_page();
    function del_person(i) {
        alert(i);
    }
</script>
