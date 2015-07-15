<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data"%>
<%@ Import Namespace="System.Data.SqlClient"%>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
       // WeixinUser u = new WeixinUser("ocTHCuPdHRCPZrcJb2qWOE_EYjeI");

        string token = Util.GetSafeRequestValue(Request, "token", " 5c803e0e060fef127483fefe2c3d4247c842cb42ae9e08014428670871111a819b078a0e");
        string openId = Util.GetSafeRequestValue(Request, "openid", "ocTHCuPdHRCPZrcJb2qWOE_EYjeI");
        string strClassId = Util.GetSafeRequestValue(Request, "classid", "19");
        string action = Util.GetSafeRequestValue(Request, "action", "unregister");
        int num = int.Parse(Util.GetSafeRequestValue(Request, "num", "0"));

        string tokenOpenId = WeixinUser.CheckToken(token);
        Class currentClass = new Class(int.Parse(strClassId));

        string msg = "没有操作";
        
        if (!tokenOpenId.Trim().Equals(""))
        {
            WeixinUser operateUser = new WeixinUser(tokenOpenId);
            WeixinUser user = new WeixinUser(openId);
            if (operateUser.OpenId.Trim().Equals(user.OpenId.Trim()) && !operateUser.IsAdmin)
            {
                if (user.VipLevel > 0)
                {
                    switch (action)
                    {
                        case "register":
                            if (currentClass.TotalPersonNumber > currentClass.RegistedPersonNumber)
                            {
                                if (currentClass.Regist(user.OpenId.Trim(),num))
                                {
                                    msg = "";
                                    SendConfirmClassMessage();
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
                            if (currentClass.CanCancel)
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
            else
            {
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

    public void SendConfirmClassMessage()
    {
        string openId = Util.GetSafeRequestValue(Request, "openid", "ocTHCuPdHRCPZrcJb2qWOE_EYjeI");
        string strClassId = Util.GetSafeRequestValue(Request, "classid", "19");
        //"ocTHCuDCNDVo6OMmBFuQMMBWsZE0" "ocTHCuPdHRCPZrcJb2qWOE_EYjeI"
        Class cls = new Class(int.Parse(strClassId));
        
       string content = "您报名的课程：" + cls.Title.Trim() + " 的最后确认时间是：" + cls._fields["cancel_time"].ToString().Trim() 
                + " 。如果的确有事来不了，请在此时间之前取消。";
        DateTime cancelTime =  DateTime.Parse(cls._fields["cancel_time"].ToString()).AddHours(-1);

        ReminderMessage.SendRedminderMessage(openId, content, cancelTime);
    }
    
</script>