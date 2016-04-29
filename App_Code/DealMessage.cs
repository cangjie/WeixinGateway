﻿using System;
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
        RepliedMessage repliedMessage;
        if (receivedMessage.isEvent)
            repliedMessage = DealEventMessage(receivedMessage);
        else
            repliedMessage = DealUserInputMessage(receivedMessage);
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
            case "DANFANG":
                Util.GetProductNews("单方", repliedMessage);
                break;
            case "FUFANG":
                Util.GetProductNews("复方", repliedMessage);
                break;
            case "WENDA":
                repliedMessage.content = Util.GetMenuWodeHit(receivedMessage.from, "http://weixin.luqinwenda.com/dingyue/images/2.jpg"
                                , 2, "卢老师的回答", "卢勤老师的回答都在这里，点击即可浏览。");
                repliedMessage.messageCount = 1;
                repliedMessage.type = "news";
                break;
            case "WODE":
                repliedMessage.content = Util.GetMenuWodeHit(receivedMessage.from, "http://weixin.luqinwenda.com/dingyue/images/4.jpg"
                                , 4, "还记得自己提过的问题吗？点击进入，即可查看提问历史。", "还记得自己提过的问题吗？点击进入，即可查看提问历史。");
                repliedMessage.messageCount = 1;
                repliedMessage.type = "news";
                break;
            case "ABOUT":
                repliedMessage.content = "选用青海新鲜无污染的牛奶，加入天然老酵母，融入西方先进的奶制品工艺，历经8-10小时自然发酵，口感独特浓稠，入口即化，回味无穷。质朴的包装，纯粹的滋味。";
                repliedMessage.type = "text";
                break;
            case "CONTACT":
                repliedMessage.content = "18531008530蜜思家小C";
                repliedMessage.type = "text";
                break;
            case "ADDR":
                repliedMessage.content = "1. 建外SOHO西区16号楼一层1605，电话010-53657956.\r\n2. 海淀区温泉镇东埠头路王庄4号院龙溪农庄，电话18513008530.";
                repliedMessage.type = "text";
                break;
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
        repliedMessage.from = receivedMessage.to;
        repliedMessage.to = receivedMessage.from;
        repliedMessage.rootId = receivedMessage.id;
        if (receivedMessage.eventKey.ToLower().Trim().StartsWith("http://www.luqinwenda.com/index.php?app=public&mod=landingpage"))
        {
            Util.DealLandingRequest(receivedMessage.from);
        }

        
 
        switch(receivedMessage.userEvent.Trim().ToLower())
        {
            case "subscribe":
                try
                {
                    RepliedMessage.news[] newsArray = new RepliedMessage.news[1];
                    newsArray[0] = new RepliedMessage.news();
                    newsArray[0].title = "免费喝酸奶，真的不要钱！";
                    newsArray[0].url = "http://miss.dotera.cn/pages/show_content.aspx?articleid=9&userid=" + receivedMessage.from;
                    newsArray[0].description = "分享此消息至朋友圈，并邀请15个朋友识别其中的二维码，即可免费得到蜜思手工酸奶一份。";
                    newsArray[0].picUrl = "http://miss.dotera.cn/images/free_black.jpg";
                    repliedMessage.newsContent = newsArray;


                    //Util.GetSubcribeWelcomeMessage(receivedMessage, repliedMessage);
                    WeixinUser userSubscribe = new WeixinUser(receivedMessage.from);
                    userSubscribe.Subscribe = true;
                    if (receivedMessage.eventKey.StartsWith("qrscene_"))
                    {
                        int sceneId = int.Parse(receivedMessage.eventKey.Replace("qrscene_", ""));

                        userSubscribe.LinkFatherUser(sceneId);

                        UserAction.AddUserAction(userSubscribe.FatherOpenId.Trim(), "", userSubscribe.OpenId, sceneId, "subscribe");
                    }
                }
                catch
                { 
                
                }
                break;
            case "unsubscribe":
                try
                {
                    WeixinUser userUnsubscribe = new WeixinUser(receivedMessage.from);
                    userUnsubscribe.Subscribe = false;
                    UserAction.AddUserAction(userUnsubscribe.FatherOpenId.Trim() , "", userUnsubscribe.OpenId, 0, "unsubscribe");
                }
                catch
                { 
                
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
                CreateQrCodeReplyMessage(receivedMessage, repliedMessage);
                break;
            case "单方":
                Util.GetProductNews("单方", repliedMessage);
                break;
            case "我要喝酸奶":
                RepliedMessage.news[] newsArray = new RepliedMessage.news[1];
                newsArray[0] = new RepliedMessage.news();
                newsArray[0].title = "免费喝酸奶，真的不要钱！";
                newsArray[0].url = "http://miss.dotera.cn/pages/show_content.aspx?articleid=9&userid=" + receivedMessage.from;
                newsArray[0].description = "分享此消息至朋友圈，并邀请15个朋友识别其中的二维码，即可免费得到蜜思手工酸奶一份。";
                newsArray[0].picUrl = "http://miss.dotera.cn/images/free_black.jpg";
                repliedMessage.newsContent = newsArray;
                break;
            default:
                if (receivedMessage.type.Trim().Equals("text"))
                {
                    Util.SearchKeyword(receivedMessage, repliedMessage);
                }
                break;
        }
        return repliedMessage;
    }

    public static void CreateQrCodeReplyMessage(ReceivedMessage receivedMessage, RepliedMessage repliedMessage)
    {
        string token = Util.GetToken();
        long scene = long.Parse(Util.GetInviteCode(receivedMessage.to.Trim()));
        string ticket = Util.GetQrCodeTicketTemp(token, scene);
        byte[] qrCodeByteArr = Util.GetQrCodeByTicket(ticket);
        string filePathName = System.Configuration.ConfigurationSettings.AppSettings["qrcode_path"].Trim() + "\\" + scene.ToString() + ".jpg";
        Util.SaveBytesToFile(filePathName, qrCodeByteArr);
        string mediaId = Util.UploadImageToWeixin(filePathName, token);
        repliedMessage.messageCount = 1;
        repliedMessage.type = "image";
        repliedMessage.content = mediaId;
        //return repliedMessage;
    }

}