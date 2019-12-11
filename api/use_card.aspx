<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string code = Util.GetSafeRequestValue(Request, "code", "065042308");
        string token = Util.GetSafeRequestValue(Request, "token", "dbb4b41e76861369b698a9288e6ca30caecbaa4873097943dea8b702f58881c74f570e1f");
        string word = Util.GetSafeRequestValue(Request, "word", "test");

        WeixinUser user = new WeixinUser(WeixinUser.CheckToken(token));

        if (user.IsAdmin)
        {
            Card card = new Card(code);
            card.Use(DateTime.Now, word);

            switch (card.Type.Trim())
            {
                case "雪票":
                    try
                    {
                        OnlineSkiPass pass = new OnlineSkiPass(card._fields["card_no"].ToString().Trim());
                        ServiceMessage adminMessage = new ServiceMessage();
                        adminMessage.from = "gh_0427e9838339";
                        adminMessage.to = user.OpenId;
                        adminMessage.type = "text";
                        adminMessage.content = "雪票：" + pass.associateOnlineOrderDetail.productName + "，票号："
                            + code.Substring(0, 3) + "-" + code.Substring(3, 3) + "-" + code.Substring(6, 3) + "，"
                            + "持有人：" + card.Owner.Nick + "，验证成功。";
                        ServiceMessage.SendServiceMessage(adminMessage);

                        ServiceMessage customMessage = new ServiceMessage();
                        customMessage.from = "gh_0427e9838339";
                        customMessage.to = card.Owner.OpenId;
                        customMessage.type = "text";
                        customMessage.content = "您的雪票：" + pass.associateOnlineOrderDetail.productName + "，票号："
                            + code.Substring(0, 3) + "-" + code.Substring(3, 3) + "-" + code.Substring(6, 3) + "，"
                            + "被" + user.Nick.Trim() + "验证成功，详情请点击微信公众号菜单“我的雪票”查看。";
                        ServiceMessage.SendServiceMessage(customMessage);
                    }
                    catch
                    {

                    }
                    break;
                case "课程":
                    try
                    {
                        OnlineSkiPass pass = new OnlineSkiPass(card._fields["card_no"].ToString().Trim());
                        ServiceMessage adminMessage = new ServiceMessage();
                        adminMessage.from = "gh_0427e9838339";
                        adminMessage.to = user.OpenId;
                        adminMessage.type = "text";
                        adminMessage.content = "场地费：" + pass.associateOnlineOrderDetail.productName + "，课程编号："
                            + code.Substring(0, 3) + "-" + code.Substring(3, 3) + "-" + code.Substring(6, 3) + "，"
                            + "教练：" + card.Owner.Nick + "，验证成功。";
                        ServiceMessage.SendServiceMessage(adminMessage);

                        ServiceMessage customMessage = new ServiceMessage();
                        customMessage.from = "gh_0427e9838339";
                        customMessage.to = card.Owner.OpenId;
                        customMessage.type = "text";
                        customMessage.content = "您的报备的课程：" + pass.associateOnlineOrderDetail.productName + "，编号："
                            + code.Substring(0, 3) + "-" + code.Substring(3, 3) + "-" + code.Substring(6, 3) + "，"
                            + "被" + user.Nick.Trim() + "验证成功。";
                        ServiceMessage.SendServiceMessage(customMessage);
                    }
                    catch
                    {

                    }
                    
                    break;
                default:
                    break;
            }

            if (card._fields["type"].ToString().Equals("雪票"))
            {


            }

            Response.Write("{\"status\":0}");
        }
        else
        {
            Response.Write("{\"status\":1}");
        }
    }
</script>