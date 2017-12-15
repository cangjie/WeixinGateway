using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Threading;
using System.Data;
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
        repliedMessage.content = "感谢您关注易龙雪聚，请<a href=\"http://weixin-snowmeet.chinacloudsites.cn/pages/register_cell_number.aspx\" >点击这里</a>以完成注册。";
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
        WeixinUser user = new WeixinUser(receivedMessage.from);
        switch (receivedMessage.userEvent.ToUpper())
        {
            case "SCAN":
                if (receivedMessage.eventKey.Length == 10)
                {
                    if (receivedMessage.eventKey.Trim().StartsWith("3"))
                    {
                        try
                        {
                            string ticketCode = receivedMessage.eventKey.Substring(1, 9);
                            Card card = new Card(ticketCode);
                            repliedMessage.type = "news";
                            RepliedMessage.news content = new RepliedMessage.news();
                            switch (card._fields["type"].ToString().Trim())
                            {
    
                                case "雪票":
                                    if (user.IsAdmin)
                                    {
                                        if (card.Used)
                                        {
                                            repliedMessage.type = "text";
                                            repliedMessage.content = card._fields["type"].ToString() + ":"
                                                + ticketCode.Trim() + "已经使用，点击<a href=\"http://weixin-snowmeet.chinacloudsites.cn/pages/admin/wechat/card_confirm_finish.aspx?code=" + ticketCode.Trim() + "\" >这里</a>查看详情";

                                        }
                                        else
                                        {
                                            if (card._fields["type"].ToString().Equals("雪票"))
                                            {
                                                content.title = "确认雪票-" + ticketCode;
                                                content.picUrl = "http://www.nanshanski.com/web_cn/images/bppt.jpg";
                                                content.url = "http://weixin-snowmeet.chinacloudsites.cn/pages/admin/wechat/card_confirm.aspx?code=" + ticketCode.Trim();
                                                content.description = "";
                                            }
                                            else
                                            {
                                                content.title = "确认消费抵用券-" + ticketCode;
                                                content.picUrl = "http://www.nanshanski.com/web_cn/images/bppt.jpg";
                                                content.url = "http://weixin-snowmeet.chinacloudsites.cn/pages/admin/wechat/ticket_confirm.aspx?code=" + ticketCode.Trim();
                                                content.description = "";
                                            }


                                            repliedMessage.newsContent = new RepliedMessage.news[] { content };

                                        }
                                    }
                                    break;
                                default:
                                    Ticket ticket = new Ticket(ticketCode.Trim());
                                    WeixinUser fatherUser = ticket.Owner;
                                    bool ret = ticket.Transfer(receivedMessage.from.Trim());
                                    if (ret)
                                    {
                                        repliedMessage.type = "text";
                                        repliedMessage.content = "恭喜您获得由" + fatherUser.Nick.Trim() + "分享的" + ticket.Name.Trim();
                                    }

                                    break;
                            }
                            
                            return repliedMessage;
                        }
                        catch
                        {
                            repliedMessage.type = "text";
                            repliedMessage.content = "精彩活动，正在路上";
                        }
                    }

                    if (int.Parse(receivedMessage.eventKey.Substring(0,2))>13)
                    {
                        repliedMessage = ScanDeviceQrCode(receivedMessage);
                    }

                    if (receivedMessage.eventKey.Trim().StartsWith("4294"))
                    {
                        repliedMessage = GenerateChargeMessage(receivedMessage);
                    }
                    if (receivedMessage.eventKey.Trim().StartsWith("4293"))
                    {
                        repliedMessage = ExchangHandRing(receivedMessage);
                    }
                }
                else
                {
                    if (receivedMessage.eventKey.Trim().Equals("1") || receivedMessage.eventKey.Equals("2"))
                    {
                        repliedMessage = ScanSignin(receivedMessage);
                    }
                }

                break;
            case "SUBSCRIBE":
                string eventKey = receivedMessage.eventKey.Replace("qrscene_", "").Trim();
                repliedMessage.type = "text";
                repliedMessage.content = eventKey.Trim();
                if (eventKey.Length == 10)
                {
                    if (int.Parse(eventKey.Substring(0, 2)) > 13 && eventKey.StartsWith("1"))
                    {
                        repliedMessage = ScanDeviceQrCode(receivedMessage);
                    }
                    else
                    {
                        if (eventKey.StartsWith("4294"))
                        {
                            repliedMessage = GenerateChargeMessage(receivedMessage);
                        }
                        if (eventKey.StartsWith("4293"))
                        {
                            repliedMessage = ExchangHandRing(receivedMessage);
                        }
                        if (eventKey.StartsWith("3"))
                        {
                            string ticketCode = eventKey.Substring(1, 9);
                            Card card = new Card(ticketCode);
                            switch (card._fields["type"].ToString().Trim())
                            {
                                case "雪票":

                                    break;
                                default:
                                    
                                    Ticket ticket = new Ticket(ticketCode.Trim());
                                    WeixinUser currentUser = new WeixinUser(receivedMessage.from.Trim());
                                    if (currentUser.VipLevel == 0 && currentUser.FatherOpenId.Trim().Equals(""))
                                    {
                                        currentUser.FatherOpenId = ticket.Owner.OpenId.Trim();
                                    }
                                    WeixinUser fatherUser = ticket.Owner;
                                    repliedMessage.content = eventKey.Trim();
                                    //repliedMessage.content = "恭喜您获得由" + fatherUser.Nick.Trim() + "分享的" + ticket.Name.Trim();
                                    bool ret = ticket.Transfer(receivedMessage.from.Trim());
                                    if (ret)
                                    {

                                        repliedMessage.type = "text";
                                        repliedMessage.content = "恭喜您获得由" + fatherUser.Nick.Trim() + "分享的" + ticket.Name.Trim();
                                    }

                                    break;
                            }
                        }
                    }
                }
                else
                {
                    if (eventKey.Trim().Equals("1") || eventKey.Equals("2"))
                    {
                        repliedMessage = ScanSignin(receivedMessage);
                    }
                }
                break;
            default:
                break;
        }
        return repliedMessage;
    }

    public static RepliedMessage GenerateChargeMessage(ReceivedMessage receivedMessage)
    {
        RepliedMessage replyMessage = new RepliedMessage();
        replyMessage.from = receivedMessage.to;
        replyMessage.to = receivedMessage.from;
        int chargeId = int.Parse(receivedMessage.eventKey.Replace("qrscene_", "").Substring(4, 6));
        OrderTemp orderTemp = new OrderTemp(chargeId);
        if (orderTemp._fields["pay_method"].ToString().Trim().Equals("现金") || orderTemp._fields["pay_method"].ToString().Trim().Equals("刷卡"))
        {
            int i = orderTemp.PlaceOnlineOrder(receivedMessage.from);
            if (i > 0)
            {
                OnlineOrder order = new OnlineOrder(i);
                order.SetOrderPaySuccess(DateTime.Now);
                orderTemp.FinishOrder();
                Point.AddNew(receivedMessage.from.Trim(), int.Parse(orderTemp._fields["generate_score"].ToString()),
                    DateTime.Now, orderTemp._fields["memo"].ToString());
                replyMessage.content = "感谢惠顾，您已经获得" + orderTemp._fields["generate_score"].ToString()
                    + "颗龙珠，您可以<a href=\"http://weixin-snowmeet.chinacloudsites.cn/pages/dragon_ball_list.aspx\" >点击查看详情</a>。";
                replyMessage.type = "text";
            }
            WeixinUser user = new WeixinUser(receivedMessage.from);
            ServiceMessage serviceMessage = new ServiceMessage();
            serviceMessage.from = receivedMessage.to;
            serviceMessage.to = orderTemp._fields["admin_open_id"].ToString();
            serviceMessage.content = user.Nick.Trim() + "因店铺销售，已经获得" + orderTemp._fields["generate_score"].ToString()
                + "颗龙珠";
            serviceMessage.type = "text";
            ServiceMessage.SendServiceMessage(serviceMessage);
        }
        if (orderTemp._fields["pay_method"].ToString().Trim().Equals("支付宝") || orderTemp._fields["pay_method"].ToString().Trim().Equals("微信"))
        {
            replyMessage.content = "<a href=\"http://weixin-snowmeet.chinacloudsites.cn/pages/confirm_order_info.aspx?id=" + orderTemp._fields["id"].ToString() + "\" >请点击确认支付</a>。";
            replyMessage.type = "text";
        }
        return replyMessage;
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
                repliedMessage.content = "http://weixin-snowmeet.chinacloudsites.cn/pages/register_cell_number.aspx";
                break;
            case "收款":
                repliedMessage.type = "text";
                repliedMessage.content = "http://weixin-snowmeet.chinacloudsites.cn/pages/admin/wechat/admin_charge_shop_sale_new.aspx";
                break;
            case "邀请":
                repliedMessage = GetInviteMessage(receivedMessage);
                break;
            default:
                break;
        }
        return repliedMessage;
    }

    public static RepliedMessage CreateQrCodeReplyMessage(ReceivedMessage receivedMessage, RepliedMessage repliedMessage)
    {
        WeixinUser user = new WeixinUser(receivedMessage.from);
        repliedMessage.messageCount = 1;
        repliedMessage.type = "text";
        repliedMessage.content = "<a href=\"http://weixin-snowmeet.chinacloudsites.cn/show_qrcode.aspx?sceneid=" + user.QrCodeSceneId.ToString() + "\"  >点击查看二维码</a>";
        return repliedMessage;
    }

    public static RepliedMessage ScanDeviceQrCode(ReceivedMessage receivedMessage)
    {
        RepliedMessage repliedMessage = new RepliedMessage();
        repliedMessage.from = receivedMessage.to;
        repliedMessage.to = receivedMessage.from;
        string eventKey = receivedMessage.eventKey.Replace("qrcode_", "");
        WeixinUser user = new WeixinUser(receivedMessage.from.Trim());
        if (user.VipLevel == 0)
        {
            repliedMessage.content = "请<a href=\"http://weixin-snowmeet.chinacloudsites.cn/pages/register_cell_number.aspx\" >点击这里</a>绑定手机号码后重新扫描设备的二维码。";
        }
        else
        {
            Device device = Device.ScanDeviceQrCode(eventKey);
            if (device != null)
            {
                int needPoints = int.Parse(device._fields["need_point"].ToString());
                if (user.Points < needPoints)
                    Device.FirstTimeToUse(receivedMessage.from.Trim(), int.Parse(device._fields["id"].ToString()));
                if (user.Points >= needPoints)
                {
                    Point.AddNew(user.OpenId, -1 * needPoints, DateTime.Now, "使用" + device._fields["name"].ToString());
                    Device.AddNewScanRecord(int.Parse(device._fields["id"].ToString()), Util.GetTimeStamp(), user.OpenId);
                    repliedMessage.type = "text";
                    repliedMessage.content = "请稍候，设备将在5秒钟内启动。";

                }
                else
                {

                    repliedMessage.content = "您的龙珠不够。";
                }
            }
        }
        repliedMessage.type = "text";
        return repliedMessage;
    }

    public static RepliedMessage ScanSignin(ReceivedMessage receivedMessage)
    {
        RepliedMessage repliedMessage = new RepliedMessage();
        repliedMessage.from = receivedMessage.to;
        repliedMessage.to = receivedMessage.from;
        string eventKey = receivedMessage.eventKey.Replace("qrscene_", "");
        WeixinUser user = new WeixinUser(receivedMessage.from.Trim());
        switch (eventKey)
        {
            case "1":
                Thread.Sleep(3000);
                string nanShanLocResult = Location.FindInResort(receivedMessage.from);
                if (nanShanLocResult.Trim().Equals("南山"))
                {
                    repliedMessage.content = "欢迎签到易龙雪聚南山店。";
                    if (!Location.HaveSignedInADay(receivedMessage.from, "南山", DateTime.Now))
                        Point.AddNew(user.OpenId.Trim(), 10, DateTime.Now, "南山签到");
                    else
                        repliedMessage.content = "您今日已经签过到了，感谢您的激情支持。";
                    if (user.VipLevel < 1)
                    {
                        repliedMessage.content = repliedMessage.content + "请<a href=\"http://weixin-snowmeet.chinacloudsites.cn/pages/register_cell_number.aspx\" >点击这里</a>绑定手机号码以获得签到积分。";
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
                break;
            case "2":
                Thread.Sleep(2500);
                string baYiLocResult = Location.FindInResort(receivedMessage.from);
                if (baYiLocResult.Trim().Equals("八易"))
                {
                    repliedMessage.content = "欢迎签到易龙雪聚八易店。";
                    if (!Location.HaveSignedInADay(receivedMessage.from, "八易", DateTime.Now))
                        Point.AddNew(user.OpenId.Trim(), 10, DateTime.Now, "八易签到");
                    else
                        repliedMessage.content = "您今日已经签过到了，感谢您的激情支持。";
                    if (user.VipLevel < 1)
                    {
                        repliedMessage.content = repliedMessage.content + "请<a href=\"http://weixin-snowmeet.chinacloudsites.cn/pages/register_cell_number.aspx\" >点击这里</a>绑定手机号码以获得签到积分。";
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
                break;
            default:
                break;
        }

        return repliedMessage;
    }

    public static RepliedMessage ExchangHandRing(ReceivedMessage receivedMessage)
    {
        string content = "";
        int id = int.Parse(receivedMessage.eventKey.Substring(4, 6));
        DataTable dt = DBHelper.GetDataTable(" select * from hand_ring_use  where [id] = " + id.ToString());
        string code = dt.Rows[0]["code"].ToString();
        string adminOpenId = dt.Rows[0]["admin_open_id"].ToString();
        WeixinUser user = new WeixinUser(receivedMessage.from);
        if (dt.Rows[0]["is_confirm"].ToString().Equals("0"))
        {
           
            int i = 0;
            foreach (string c in code.Split(','))
            {
                i++;
            }
            content = "手环兑换成功，共" + i.ToString() + "个，共花费" + i * 100 + "个龙珠。";
            Point.AddNew(receivedMessage.from, -1 * i * 100, DateTime.Now, "兑换" + i.ToString() + "个手环。");
            string[,] updateParam = { { "is_confirm", "int", "1" } };
            string[,] keyParam = { { "id", "int", dt.Rows[0]["id"].ToString() } };
            DBHelper.UpdateData("hand_ring_use", updateParam, keyParam, Util.conStr);
        }
        else
        {
            content = "手环已经兑换。";
        }
        dt.Dispose();
        ServiceMessage serviceMessage = new ServiceMessage();
        serviceMessage.from = receivedMessage.to;
        serviceMessage.to = adminOpenId;
        serviceMessage.type = "text";
        serviceMessage.content = user.Nick.Trim() + "的" + content.Trim();
        ServiceMessage.SendServiceMessage(serviceMessage);

        RepliedMessage repliedMessage = new RepliedMessage();
        repliedMessage.from = receivedMessage.to;
        repliedMessage.to = receivedMessage.from;
        repliedMessage.type = "text";
        repliedMessage.content = "您的" + content.Trim();
        return repliedMessage;
    }

    public static RepliedMessage GetInviteMessage(ReceivedMessage receiveMessage)
    {
        RepliedMessage repliedMessage = new RepliedMessage();
        repliedMessage.from = receiveMessage.to;
        repliedMessage.to = receiveMessage.from;
        repliedMessage.type = "news";
        RepliedMessage.news content = new RepliedMessage.news();
        content.title = "易龙雪聚会籍邀请";
        content.picUrl = "http://weixin-snowmeet.chinacloudsites.cn/images/invite_ticket.jpg";
        content.url = "http://weixin-snowmeet.chinacloudsites.cn/pages/register_cell_number.aspx?fatheropenid=" + receiveMessage.from;
        content.description = "请将此消息转发给他人。";
        repliedMessage.newsContent = new RepliedMessage.news[] { content };
        return repliedMessage;
    }

}