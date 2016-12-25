using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for DealMessage
/// </summary>
public class DealMessage
{
	public DealMessage()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    public static RepliedMessage DealReceivedMessage(ReceivedMessage receivedMessage)
    {
        

        WeixinUser user = new WeixinUser(receivedMessage.from.Trim());
        if (user.VipLevel == 0 && (!receivedMessage.isEvent || receivedMessage.isMenuClick))
        {
            return GetNewSubscribeMessage(receivedMessage);
        }
        else
        {
            RepliedMessage repliedMessage;
            if (receivedMessage.isEvent)
                repliedMessage = DealEventMessage(receivedMessage);
            else
                repliedMessage = DealUserInputMessage(receivedMessage);
            return repliedMessage;
        }
    }


    public static RepliedMessage GetNewSubscribeMessage(ReceivedMessage receivedMessage)
    {
        RepliedMessage repliedMessage = new RepliedMessage();
        repliedMessage.from = receivedMessage.to.Trim();
        repliedMessage.to = receivedMessage.from;
        repliedMessage.type = "text";
        repliedMessage.content = "感谢您关注易龙雪聚，请<a href=\"http://weixin.snowmeet.com/pages/register_cell_number.aspx\" >点击这里</a>以完成注册。";
        return repliedMessage;
    }

    public static RepliedMessage DealEventMessage(ReceivedMessage receivedMessage)
    {
        RepliedMessage repliedMessage;
        if (receivedMessage.isMenuClick)
        {
            repliedMessage = DealMenuClickMessage(receivedMessage);
        }
        else
        {
            if (receivedMessage.isMenuView)
            {
                repliedMessage = DealMenuViewMessage(receivedMessage);
            }
            else
            {
                repliedMessage = DealCommonEventMessage(receivedMessage);
            }
        }

        return repliedMessage;
    }

    public static RepliedMessage DealMenuClickMessage(ReceivedMessage receivedMessage)
    {
        RepliedMessage repliedMessage = new RepliedMessage();
        repliedMessage.from = receivedMessage.to;
        repliedMessage.to = receivedMessage.from;
        repliedMessage.rootId = receivedMessage.id.Trim();
        switch (receivedMessage.eventKey.Trim())
        {
            default:
                break;
        }
        return repliedMessage;
    }

    public static RepliedMessage DealMenuViewMessage(ReceivedMessage receivedMessage)
    {
        RepliedMessage repliedMessage = new RepliedMessage();
        if (receivedMessage.eventKey.ToLower().Trim().StartsWith("http://www.luqinwenda.com/index.php?app=public&mod=landingpage"))
        {
            Util.DealLandingRequest(receivedMessage.from);
        }
        return repliedMessage;
    }

    public static RepliedMessage DealCommonEventMessage(ReceivedMessage receivedMessage)
    {
        RepliedMessage repliedMessage = new RepliedMessage();
        /*
        if (receivedMessage.eventKey.ToLower().Trim().StartsWith("http://www.luqinwenda.com/index.php?app=public&mod=landingpage"))
        {
            Util.DealLandingRequest(receivedMessage.from);
        }
        */
        switch (receivedMessage.userEvent.ToUpper())
        {
            case "SCAN":
                WeixinUser user = new WeixinUser(receivedMessage.from);
                if (receivedMessage.eventKey.Trim().StartsWith("3") && user.IsAdmin)
                {
                    try
                    {
                        string ticketCode = receivedMessage.eventKey.Substring(1, 9);
                        repliedMessage.type = "news";
                        RepliedMessage.news content = new RepliedMessage.news();
                        content.title = "确认消费抵用券-"+ticketCode;
                        content.picUrl = "http://www.nanshanski.com/web_cn/images/bppt.jpg";
                        content.url = "http://weixin.snowmeet.com/pages/admin/wechat/ticket_confirm.aspx?code=" + ticketCode.Trim();
                        content.description = "";
                        repliedMessage.newsContent = new RepliedMessage.news[] { content };
                        repliedMessage.from = receivedMessage.to;
                        repliedMessage.to = receivedMessage.from;
                    }
                    catch
                    {

                    }

                    

                }
                break;
            default:
                break;
        }


        return repliedMessage;
    }

    public static RepliedMessage DealUserInputMessage(ReceivedMessage receivedMessage)
    {
        RepliedMessage repliedMessage = new RepliedMessage();
        repliedMessage.from = receivedMessage.to;
        repliedMessage.to = receivedMessage.from;
        repliedMessage.rootId = receivedMessage.id;
        switch (receivedMessage.content.Trim().ToLower())
        { 
            case "二维码":
                repliedMessage = CreateQrCodeReplyMessage(receivedMessage, repliedMessage);
                break;
            case "绑定手机":
                repliedMessage.type = "text";
                repliedMessage.content = "http://snowmeet.tuyaa.com/pages/register_cell_number.aspx";
                break;
            default:
                break;
        }
        return repliedMessage;
    }

    public static RepliedMessage CreateQrCodeReplyMessage(ReceivedMessage receivedMessage, RepliedMessage repliedMessage)
    {
        /*
        string token = Util.GetToken();
        long scene = long.Parse(Util.GetInviteCode(receivedMessage.to.Trim()));
        string ticket = Util.GetQrCodeTicketTemp(token, scene);
        byte[] qrCodeByteArr = Util.GetQrCodeByTicket(ticket);
        string filePathName = System.Configuration.ConfigurationSettings.AppSettings["qrcode_path"].Trim() + "\\" + scene.ToString() + ".jpg";
        Util.SaveBytesToFile(filePathName, qrCodeByteArr);
        string mediaId = Util.UploadImageToWeixin(filePathName, token);
        */
        WeixinUser user = new WeixinUser(receivedMessage.from);
        repliedMessage.messageCount = 1;
        repliedMessage.type = "text";
        repliedMessage.content = "<a href=\"http://weixin.snowmeet.com/show_qrcode.aspx?sceneid=" + user.QrCodeSceneId.ToString() + "\"  >点击查看二维码</a>";
        return repliedMessage;
    }

}