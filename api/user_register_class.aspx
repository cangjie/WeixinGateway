<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
       // WeixinUser u = new WeixinUser("ocTHCuPdHRCPZrcJb2qWOE_EYjeI");

        string token = Util.GetSafeRequestValue(Request, "token", " a871cb97eb550ca5cc3f4c3c5ab473639e7a67e655deaf1caa050b4d0191e4edc489974a");
        string openId = Util.GetSafeRequestValue(Request, "openid", "ocTHCuPdHRCPZrcJb2qWOE_EYjeI");
        string strClassId = Util.GetSafeRequestValue(Request, "classid", "1");
        string action = Util.GetSafeRequestValue(Request, "action", "register");

        string tokenOpenId = WeixinUser.CheckToken(token);
        Class currentClass = new Class(int.Parse(strClassId));

        string msg = "没有操作";
        
        if (!tokenOpenId.Trim().Equals(""))
        {
            WeixinUser operateUser = new WeixinUser(tokenOpenId);
            WeixinUser user = new WeixinUser(openId);
            if (operateUser.OpenId.Trim().Equals(user.OpenId.Trim()))
            {
                if (user.VipLevel > 0)
                {
                    switch (action)
                    {
                        case "register":
                            if (currentClass.TotalPersonNumber > currentClass.RegistedPersonNumber)
                            {
                                if (currentClass.Regist(user.OpenId.Trim()))
                                {
                                    msg = "";
                                }
                                else
                                {
                                    msg = "报名失败";
                                }
                            }
                            else
                                msg = "报名满了";
                            break;
                        case "unregister":
                            if (currentClass.BeginTime > DateTime.Now.AddHours(4))
                            {
                                if (currentClass.UnRegist(user.OpenId.Trim()))
                                {
                                    msg = "";
                                }
                                else
                                {
                                    msg = "取消失败";
                                }
                            }
                            else
                                msg = "时间晚了";
                            break;
                        default:
                            msg = "没有操作";
                            break;
                    }
                }
                else
                {
                    msg = "没有权限";
                }
            }
            if (operateUser.IsAdmin)
            {
                switch (action)
                {
                    case "register":
                        if (currentClass.Regist(user.OpenId.Trim()))
                            msg = "";
                        else
                            msg = "报名失败";
                        break;
                    case "unregister":
                        if (currentClass.UnRegist(user.OpenId.Trim()))
                            msg = "";
                        else
                            msg = "取消失败";
                        break;
                    default:
                        msg = "没有操作";
                        break;
                }
            }
            
        }

        if (msg.Trim().Equals(""))
        {
            Response.Write("{\"status\":0 }");
        }
        else
        {
            Response.Write("{\"status\":1 , \"message\":\"" + msg.Trim() + "\"  }");
        }

    }
</script>