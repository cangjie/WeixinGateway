using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Threading;

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
        repliedMessage.from = receivedMessage.to;
        repliedMessage.to = receivedMessage.from;
        /*
        if (receivedMessage.eventKey.ToLower().Trim().StartsWith("http://www.luqinwenda.com/index.php?app=public&mod=landingpage"))
        {
            Util.DealLandingRequest(receivedMessage.from);
        }
        */
        WeixinUser user = new WeixinUser(receivedMessage.from);
        switch (receivedMessage.userEvent.ToUpper())
        {
            case "SCAN":
                
                if (receivedMessage.eventKey.Trim().StartsWith("3") && user.IsAdmin)
                {
                    try
                    {
                        string ticketCode = receivedMessage.eventKey.Substring(1, 9);
                        Card card = new Card(ticketCode);
                        repliedMessage.type = "news";
                        RepliedMessage.news content = new RepliedMessage.news();
                        if (card.Used)
                        {
                            repliedMessage.type = "text";
                            repliedMessage.content = card._fields["type"].ToString() + ":"
                                + ticketCode.Trim() + "已经使用，点击<a href=\"http://weixin.snowmeet.com/pages/admin/wechat/card_confirm_finish.aspx?code=" + ticketCode.Trim()  +"\" >这里</a>查看详情";

                        }
                        else
                        {
                            if (card._fields["type"].ToString().Equals("雪票"))
                            {
                                content.title = "确认雪票-" + ticketCode;
                                content.picUrl = "http://www.nanshanski.com/web_cn/images/bppt.jpg";
                                content.url = "http://weixin.snowmeet.com/pages/admin/wechat/card_confirm.aspx?code=" + ticketCode.Trim();
                                content.description = "";
                            }
                            else
                            {
                                content.title = "确认消费抵用券-" + ticketCode;
                                content.picUrl = "http://www.nanshanski.com/web_cn/images/bppt.jpg";
                                content.url = "http://weixin.snowmeet.com/pages/admin/wechat/ticket_confirm.aspx?code=" + ticketCode.Trim();
                                content.description = "";
                            }

                            repliedMessage.newsContent = new RepliedMessage.news[] { content };
                            
                        }
                        return repliedMessage;
                    }
                    catch
                    {

                    }
                }

                //签到
                double latNorth = 0;
                double latSourth = 0;
                double lonWest = 0;
                double lonEast = 0;

                

                Location lastLocation;
                switch (receivedMessage.eventKey)
                {
                    case "1":
                        Thread.Sleep(3000);
                        string nanShanLocResult = Location.FindInResort(receivedMessage.from);
                        if (nanShanLocResult.Trim().Equals("南山"))
                        {
                            repliedMessage.content = "欢迎签到易龙雪聚南山店。";

                            if (user.VipLevel < 1)
                            {
                                repliedMessage.content = repliedMessage.content + "请<a href=\"http://weixin.snowmeet.com/pages/register_cell_number.aspx\" >点击这里</a>绑定手机号码以获得签到积分。";
                            }

                        }
                        else
                        {
                            if (!nanShanLocResult.Trim().Equals(""))
                                repliedMessage.content = nanShanLocResult.Trim();
                            else
                                repliedMessage.content = "您不在南山，不能签到。";
                        }
                        repliedMessage.type = "text";
                        return repliedMessage;
                        break;
                    case "2":
                        Thread.Sleep(2500);
                        string baYiLocResult = Location.FindInResort(receivedMessage.from);
                        if (baYiLocResult.Trim().Equals("八易"))
                        {
                            repliedMessage.content = "欢迎签到易龙雪聚八易店。";
                            if (user.VipLevel < 1)
                            {
                                repliedMessage.content = repliedMessage.content + "请<a href=\"http://weixin.snowmeet.com/pages/register_cell_number.aspx\" >点击这里</a>绑定手机号码以获得签到积分。";
                            }
                        }
                        else
                        {
                            if (!baYiLocResult.Trim().Equals(""))
                                repliedMessage.content = baYiLocResult.Trim();
                            else
                                repliedMessage.content = "您不在八易，不能签到。";
                        }
                        repliedMessage.type = "text";
                        return repliedMessage;
                        break;
                    default:
                        break;
                }


                if (receivedMessage.eventKey.StartsWith("1"))
                {
                    if (user.VipLevel == 0)
                    {

                    }
                    else
                    {
                        Device device = Device.ScanDeviceQrCode(receivedMessage.eventKey);
                        if (device != null)
                        {
                            int needPoints = int.Parse(device._fields["need_point"].ToString());
                            if (user.Points < needPoints)
                                Device.FirstTimeToUse(receivedMessage.from.Trim(), int.Parse(device._fields["id"].ToString()));
                            if (user.Points >= needPoints)
                            {
                                Point.AddNew(user.OpenId, -1 * needPoints, DateTime.Now, "使用" + device._fields["name"].ToString());
                                Device.AddNewScanRecord(int.Parse(device._fields["id"].ToString()), Util.GetTimeStamp(), user.OpenId);

                            }
                            else
                            {
                                ServiceMessage userMessage = new ServiceMessage();
                                userMessage.from = "gh_0427e9838339";
                                userMessage.to = user.OpenId;
                                userMessage.type = "text";
                                userMessage.content = "您的龙珠不够。";
                                ServiceMessage.SendServiceMessage(userMessage);
                            }


                        }
                    }
                }
                break;
            case "subscribe":
                if (receivedMessage.eventKey.StartsWith("qrscene_1"))
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