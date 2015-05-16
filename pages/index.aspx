<%@ Page Language="C#" %>
<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        //Authorize();
        
    }

    public void Authorize()
    {
        string token = Session["token"] == null ? "" : Session["token"].ToString();
        if (token.Trim().Equals(""))
        {
            Response.Redirect("../authorize.aspx?callback="
                + Server.UrlEncode(Request.Url.ToString().Trim()), true);
        }
        string openId = WeixinUser.CheckToken(token);
        if (openId.Trim().Equals(""))
        {
            Response.Redirect("../authorize.aspx?callback="
                + Server.UrlEncode(Request.Url.ToString().Trim()), true);
        } 
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <title></title>
    <link href="docs/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="docs/css/highlight.css" rel="stylesheet"/>
    <link href="dist/css/bootstrap3/bootstrap-switch.css" rel="stylesheet"/>
    <link href="src/docs.min.css" rel="stylesheet"/>
    <link href="docs/css/main.css" rel="stylesheet"/>
    <style type="text/css">
        .auto-style1 {
            font-size: xx-large;
        }
        .auto-style3 {
            font-size: large;
        }
        .auto-style4 {
            font-size: small;
        }
        .auto-style5 {
            font-size: medium;
        }
    </style>
</head>
<body>


    <div id="root" style="padding:20px 20px 20px 20px" >


        <div style="border:1px solid #BEBEBE;padding: 5px" >
            <div class="auto-style1"><strong>礼拜二中午TRX</strong></div>
            <div style="background-color: #CCCCCC" class="auto-style5">教练：糖果&nbsp;&nbsp;&nbsp;&nbsp;时间：<span class="gr">2015-5-19 12:00</span></div>
            <div class="auto-style3">备注信息 备注信息 备注信息 备注信息 备注信息 备注信息 备注信息</div>
            <br />
            <div>
                <button data-toggle="modal" data-target="#modal-switch-0" class="btn btn-default"  > 点 击 报 名</button>
                <div>
                    <p class="auto-style3">一起参加的同学：</p>
                    <table style="border:none">
                        <tr>
                            <td width="60" ><img src="http://wx.qlogo.cn/mmopen/lYeXJEq4yBXCBkz392CNewFrcqo63Oas4rsFmGlib1kAntRhsQHTMkUoJnUU4IQgcusEJEvcL61PCtbhCZIlTs1iaXUn24bumN/0" style="width:50px;height:50px" /></td>
                            <td width="60" ><img src="http://wx.qlogo.cn/mmopen/lYeXJEq4yBXCBkz392CNewFrcqo63Oas4rsFmGlib1kAntRhsQHTMkUoJnUU4IQgcusEJEvcL61PCtbhCZIlTs1iaXUn24bumN/0" style="width:50px;height:50px" /></td>
                            <td width="60" ><img src="http://wx.qlogo.cn/mmopen/lYeXJEq4yBXCBkz392CNewFrcqo63Oas4rsFmGlib1kAntRhsQHTMkUoJnUU4IQgcusEJEvcL61PCtbhCZIlTs1iaXUn24bumN/0" style="width:50px;height:50px" /></td>
                            <td width="60" ><img src="http://wx.qlogo.cn/mmopen/lYeXJEq4yBXCBkz392CNewFrcqo63Oas4rsFmGlib1kAntRhsQHTMkUoJnUU4IQgcusEJEvcL61PCtbhCZIlTs1iaXUn24bumN/0" style="width:50px;height:50px" /></td>
                            <td width="60" ><img src="http://wx.qlogo.cn/mmopen/lYeXJEq4yBXCBkz392CNewFrcqo63Oas4rsFmGlib1kAntRhsQHTMkUoJnUU4IQgcusEJEvcL61PCtbhCZIlTs1iaXUn24bumN/0" style="width:50px;height:50px" /></td>
                        </tr>
                        <tr>
                            <td class="auto-style4" >苍杰</td>
                            <td class="auto-style4" >苍杰</td>
                            <td class="auto-style4" >苍杰</td>
                            <td class="auto-style4" >苍杰</td>
                            <td class="auto-style4" >苍杰</td>
                        </tr>

                    </table>

                </div>
                <div id="modal-switch-0" tabindex="-1" role="dialog" aria-labelledby="modal-switch-label" class="modal fade">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" data-dismiss="modal" class="close"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                                <div id="modal-switch-label-0" class="modal-title">Title-0</div>
                            </div>
                            <div class="modal-body">
                                <div class="switch switch-small">
                                    <input type="checkbox" checked />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        
        <br />

                <div style="border:1px solid #BEBEBE;padding: 5px" >
            <div class="auto-style1"><strong>礼拜二中午TRX</strong></div>
            <div style="background-color: #CCCCCC" class="auto-style5">教练：糖果&nbsp;&nbsp;&nbsp;&nbsp;时间：<span class="gr">2015-5-19 12:00</span></div>
            <div class="auto-style3">备注信息 备注信息 备注信息 备注信息 备注信息 备注信息 备注信息</div>
            <br />
            <div>
                <button data-toggle="modal" data-target="#modal-switch-1" class="btn btn-default"  > 点 击 报 名</button>
                <div>
                    <p class="auto-style3">一起参加的同学：</p>
                    <table style="border:none">
                        <tr>
                            <td width="60" ><img src="http://wx.qlogo.cn/mmopen/lYeXJEq4yBXCBkz392CNewFrcqo63Oas4rsFmGlib1kAntRhsQHTMkUoJnUU4IQgcusEJEvcL61PCtbhCZIlTs1iaXUn24bumN/0" style="width:50px;height:50px" /></td>
                            <td width="60" ><img src="http://wx.qlogo.cn/mmopen/lYeXJEq4yBXCBkz392CNewFrcqo63Oas4rsFmGlib1kAntRhsQHTMkUoJnUU4IQgcusEJEvcL61PCtbhCZIlTs1iaXUn24bumN/0" style="width:50px;height:50px" /></td>
                            <td width="60" ><img src="http://wx.qlogo.cn/mmopen/lYeXJEq4yBXCBkz392CNewFrcqo63Oas4rsFmGlib1kAntRhsQHTMkUoJnUU4IQgcusEJEvcL61PCtbhCZIlTs1iaXUn24bumN/0" style="width:50px;height:50px" /></td>
                            <td width="60" ><img src="http://wx.qlogo.cn/mmopen/lYeXJEq4yBXCBkz392CNewFrcqo63Oas4rsFmGlib1kAntRhsQHTMkUoJnUU4IQgcusEJEvcL61PCtbhCZIlTs1iaXUn24bumN/0" style="width:50px;height:50px" /></td>
                            <td width="60" ><img src="http://wx.qlogo.cn/mmopen/lYeXJEq4yBXCBkz392CNewFrcqo63Oas4rsFmGlib1kAntRhsQHTMkUoJnUU4IQgcusEJEvcL61PCtbhCZIlTs1iaXUn24bumN/0" style="width:50px;height:50px" /></td>
                        </tr>
                        <tr>
                            <td class="auto-style4" >苍杰</td>
                            <td class="auto-style4" >苍杰</td>
                            <td class="auto-style4" >苍杰</td>
                            <td class="auto-style4" >苍杰</td>
                            <td class="auto-style4" >苍杰</td>
                        </tr>

                    </table>

                </div>
                <div id="modal-switch-1" tabindex="-1" role="dialog" aria-labelledby="modal-switch-label" class="modal fade">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" data-dismiss="modal" class="close"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                                <div id="modal-switch-label-1" class="modal-title">Title-1</div>
                            </div>
                            <div class="modal-body">
                                <div class="switch switch-small">
                                    <input type="checkbox" checked />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>



    </div>
    
    
    
     
    <script src="docs/js/jquery.min.js"></script>
    <script src="docs/js/bootstrap.min.js"></script>
    <script src="docs/js/highlight.js"></script>
    <script src="dist/js/bootstrap-switch.js"></script>
    <script src="docs/js/main.js"></script>
</body>

</html>
