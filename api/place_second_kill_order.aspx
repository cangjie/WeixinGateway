﻿<%@ Page Language="C#" %>
<script runat="server">



    protected void Page_Load(object sender, EventArgs e)
    {
        string token = Util.GetSafeRequestValue(Request, "token", "");
        string verifyCode = Util.GetSafeRequestValue(Request, "vcode", "7777");
        if (Session["check_code"] == null || !Session["check_code"].ToString().Trim().Equals(verifyCode.Trim()))
        {
            Response.Write("{\"success\": 0, \"error_message\": \"验证码错误。\" }");
            Response.End();
        }
        int productId = int.Parse(Util.GetSafeRequestValue(Request, "id", "64"));
        string openId = WeixinUser.CheckToken(token);
        if (openId.Trim().Equals(""))
        {
            Response.Write("{\"success\": 0, \"error_message\": \"Token非法。\" }");
            Response.End();
        }

        string activityHandleString = "second_kill_" + productId.ToString();

        SecondKill activity = new SecondKill();
        bool needCreateObject = false;
        if (Application["second_kill_" + productId.ToString()] == null)
        {
            needCreateObject = true;
        }
        else
        {
            try
            {
                activity = (SecondKill)Application[activityHandleString];
            }
            catch
            {
                needCreateObject = true;
            }
        }
        if (needCreateObject)
        {
            activity = new SecondKill(productId);
            Application.Lock();
            Application[activityHandleString] = activity;
            Application.UnLock();
        }
        DateTime currentTime = DateTime.Now;
        if (currentTime < activity.activityStartTime || currentTime > activity.activityEndTime)
        {
            Response.Write("{\"success\": 0, \"error_message\": \"秒杀未开始。\" }");
            Response.End();
        }
        Application.Lock();
        activity = (SecondKill)Application[activityHandleString];
        bool result = activity.Kill(openId);
        if (result)
        {
            Application[activityHandleString] = activity;
        }
        Application.UnLock();



        Response.Write("{\"success\": 1, \"result\": " + (result? "1":"0") + "}");
    }
</script>