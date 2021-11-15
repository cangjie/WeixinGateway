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
        repliedMessage.content = "感谢您关注易龙雪聚，请<a href=\"http://weixin.snowmeet.top/pages/register_cell_number.aspx\" >点击这里</a>以完成注册。";
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
                long keyNum = 0;
                if (receivedMessage.eventKey.Length == 10 && long.TryParse(receivedMessage.eventKey.Trim(), out keyNum))
                {
                    if (receivedMessage.eventKey.Trim().StartsWith("3"))
                    {
                        try
                        {
                            string ticketCode = receivedMessage.eventKey.Substring(1, 9);
                            Card card = new Card(ticketCode);
                            repliedMessage.type = "news";
                            RepliedMessage.news content = new RepliedMessage.news();

                            switch (card.Type.Trim())
                            {
                                case "雪票":
                                    if (user.IsAdmin)
                                    {
                                        if (!card.Used)
                                        {
                                            content.title = "确认雪票-" + ticketCode;
                                            content.picUrl = "http://www.nanshanski.com/web_cn/images/bppt.jpg";
                                            content.url = "http://weixin.snowmeet.top/pages/admin/wechat/card_confirm.aspx?code=" + ticketCode.Trim();
                                            content.description = "";
                                        }
                                        else
                                        {
                                            repliedMessage.type = "text";
                                            repliedMessage.content = card._fields["type"].ToString() + ":"
                                                + ticketCode.Trim() + "已经使用，点击<a href=\"http://weixin.snowmeet.top/pages/admin/wechat/card_confirm_finish.aspx?code=" + ticketCode.Trim() + "\" >这里</a>查看详情";
                                        }
                                    }
                                    repliedMessage.newsContent = new RepliedMessage.news[] { content };
                                    break;
                                case "课程":
                                    Course course = new Course(card._fields["card_no"].ToString().Trim());
                                    if (course.Resort.Trim().Equals(user.StaffResort.Trim()))
                                    {
                                        if (!card.Used)
                                        {
                                            content.title = "确认课程发放袖标-" + ticketCode;
                                            content.picUrl = "http://www.nanshanski.com/web_cn/images/bppt.jpg";
                                            content.url = "http://weixin.snowmeet.top/pages/admin/wechat/card_confirm.aspx?code=" + ticketCode.Trim();
                                            content.description = "";
                                        }
                                        else
                                        {

                                        }
                                    }
                                    repliedMessage.newsContent = new RepliedMessage.news[] { content };
                                    break;
                                default:
                                    WeixinUser scanUser = new WeixinUser(receivedMessage.from.Trim());
                                    Ticket ticket = new Ticket(ticketCode.Trim());
                                    if (scanUser.IsAdmin)
                                    {
                                        if (!ticket.Used)
                                        {
                                            ticket.Use(scanUser.OpenId.Trim(), "使用核销");
                                            repliedMessage.type = "text";
                                            repliedMessage.content = ticket.Name.Trim() + " " + ticket.Code.Trim() + "核销成功。";
                                        }
                                        else
                                        {
                                            repliedMessage.type = "text";
                                            repliedMessage.content = ticket.Name.Trim() + " " + ticket.Code.Trim() + "已经使用，不能核销。";
                                        }
                                    }
                                    else
                                    {
                                        
                                        WeixinUser fatherUser = new WeixinUser(ticket.Owner.OpenId.Trim());
                                        bool ret = ticket.Transfer(receivedMessage.from.Trim());
                                        if (ret)
                                        {
                                            repliedMessage.type = "text";
                                            repliedMessage.content = "恭喜您获得由" + fatherUser.Nick.Trim() + "分享的" + ticket.Name.Trim();
                                        }
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

           
                    
                    if (receivedMessage.eventKey.Trim().StartsWith("openid_"))
                    {
                        string openId = receivedMessage.eventKey.Trim().Replace("openid_", "");
                        WeixinUser salesUser = new WeixinUser(openId.Trim());
                        if (salesUser.IsAdmin)
                        {
                            repliedMessage.type = "text";
                            repliedMessage.content = "请找" + salesUser.Nick.Trim() + "在手机上完成操作";
                            SendCustomeRequestToAssistant(receivedMessage);
                        }
                    }

                    if (receivedMessage.eventKey.Trim().Equals("pinghuazhiwang"))
                    {
                        repliedMessage.type = "text";
                        repliedMessage.content = "<a href=\"http://weixin.snowmeet.top/scan_jump.aspx?scene='" + receivedMessage.eventKey.Trim() + "\" >参加活动</a>";
                        //SendCustomeRequestToAssistant(receivedMessage);
                    }

                }

                break;
            case "SUBSCRIBE":
                string eventKey = receivedMessage.eventKey.Replace("qrscene_", "").Trim();
                receivedMessage.eventKey = eventKey;
                long numKey = 0;
                if (eventKey.Length == 10 && long.TryParse(eventKey, out numKey))
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
                                    string fatherOpenId = ticket.Owner.OpenId.Trim();
                                    WeixinUser fatherUser = new WeixinUser(fatherOpenId);
                                    WeixinUser currentUser = new WeixinUser(receivedMessage.from.Trim());
                                    if (currentUser.VipLevel == 0 && currentUser.FatherOpenId.Trim().Equals(""))
                                    {
                                        currentUser.FatherOpenId = fatherOpenId.Trim();
                                    }
                                    
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
           
                    if (receivedMessage.eventKey.Trim().StartsWith("openid"))
                    {
                        string openId = receivedMessage.eventKey.Trim().Replace("openid_", "");
                        WeixinUser salesUser = new WeixinUser(openId.Trim());
                        if (salesUser.IsAdmin)
                        {
                            repliedMessage.type = "text";
                            repliedMessage.content = "请找" + salesUser.Nick.Trim() + "在手机上完成操作";
                            SendCustomeRequestToAssistant(receivedMessage);
                        }
                    }
                    if (receivedMessage.eventKey.Trim().Equals("pinghuazhiwang"))
                    {
                        repliedMessage.type = "text";
                        repliedMessage.content = "<a href=\"http://weixin.snowmeet.top/scan_jump.aspx?scene='" + receivedMessage.eventKey.Trim() +  "\" >参加活动</a>";
                        //SendCustomeRequestToAssistant(receivedMessage);
                    }
                }
                break;
            default:
                break;
        }

        if (repliedMessage.type.Trim().Equals(""))
        {
            return DealCommonEventMessageNew(receivedMessage, repliedMessage);
        }
        else
        {
            return repliedMessage;
        }
    }

    public static RepliedMessage DealCommonEventMessageNew(ReceivedMessage receivedMessage, RepliedMessage repliedMessage)
    {
        string eventKey = "";
        switch (receivedMessage.userEvent.Trim().ToUpper())
        {
            case "SUBSCRIBE":
                eventKey = receivedMessage.eventKey.ToLower().Replace("qrscene_", "").Trim();
                break;
            case "SCAN":
                eventKey = receivedMessage.eventKey.ToLower().Trim();
                break;
            default:
                break;
        }
        string[] eventKeyArr = eventKey.Split('_');
        string subKey = "";
        string anyId = "";
        try
        {
            anyId = eventKeyArr[eventKeyArr.Length - 1].Trim();
        }
        catch
        {

        }
        switch (eventKeyArr[0].Trim())
        {
            case "pay":
                
                for (int i = 1; i < eventKeyArr.Length - 1; i++)
                {
                    subKey = subKey.Trim() + ((i > 1)?"_":"") + eventKeyArr[i].Trim();
                }
                anyId = eventKeyArr[eventKeyArr.Length - 1].Trim();
                switch (subKey.Trim())
                {
                    case "temp_order_id":
                        repliedMessage = ScanToPayTempOrder(receivedMessage, repliedMessage, int.Parse(anyId));
                        break;
                    case "order_id":
                        repliedMessage = ScanToPayOrder(receivedMessage, repliedMessage, int.Parse(anyId));
                        break;
                    case "product_id":
                        repliedMessage = ScanToPayProduct(receivedMessage, repliedMessage, int.Parse(anyId));
                        break;
                    case "maintain_task_id":
                        repliedMessage = ScanToPayMaintask(receivedMessage, repliedMessage, int.Parse(anyId));
                        break;
                    case "channeled_product_id":
                        repliedMessage = ScanToPayChanneledProduct(receivedMessage, repliedMessage, int.Parse(anyId.Split('-')[0].Trim()), anyId.Split('-')[1].Trim());
                        break;
                    case "in_shop_maintain_id":
                        repliedMessage = ScanToPayInShopMaintainId(receivedMessage, repliedMessage, int.Parse(anyId));
                        break;
                    case "in_shop_maintain_batch_id":
                        repliedMessage = ScanToPayInShopMaintainBatchId(receivedMessage, repliedMessage, int.Parse(anyId));
                        break;
                    case "expierence_guarantee_cash":
                        repliedMessage = PayExpierenceCash(receivedMessage, repliedMessage, int.Parse(anyId));
                        break;
                    default:
                        break;
                }
                break;
            /*
            case "use_service_card_detail":
            case "use_service_card":
                repliedMessage = UseServiceCard(receivedMessage, repliedMessage, anyId);
                break;
            */
            case "use":
                subKey = "";
                for (int i = 1; i < eventKeyArr.Length - 1; i++)
                {
                    subKey = subKey.Trim() + ((i > 1) ? "_" : "") + eventKeyArr[i].Trim();
                }
                anyId = eventKeyArr[eventKeyArr.Length - 1].Trim();
                repliedMessage = UseServiceCard(receivedMessage, repliedMessage, anyId);
                break;
            case "verify":
                break;
            case "rent":
                repliedMessage = RentItemMessage(receivedMessage, repliedMessage, int.Parse(anyId));

                break;
            default:
                break;
        }
        return repliedMessage;
    }

    public static RepliedMessage PayExpierenceCash(ReceivedMessage receivedMessage, RepliedMessage repliedMessage, int id)
    {
        Expierence expierence = new Expierence(id);
        int orderId = expierence.PlaceOrder(receivedMessage.from);
        repliedMessage.type = "text";
        repliedMessage.content = "您试滑 " + expierence.name.Trim() + " ，请在" + expierence.endTime.Month.ToString() + "月" 
            + expierence.endTime.Date.ToString() + "日" + expierence.endTime.Hour.ToString() + "点" + expierence.endTime.Minute.ToString() + "分前归还。"
            + "<a href=\"http://" + Util.domainName.Trim() + "/pages/confirm_expierence_admit.aspx?id=" + expierence._fields["id"].ToString() 
            +  "\" >点击这里支付" + expierence._fields["guarantee_cash"].ToString().Trim() + "元押金</a>。";
        repliedMessage.content = "您试滑 " + expierence.name.Trim() + " ，请在" + expierence.endTime.Month.ToString() + "月"
            + expierence.endTime.Date.ToString() + "日" + expierence.endTime.Hour.ToString() + "点" + expierence.endTime.Minute.ToString() + "分前归还。"
            + "<a data-miniprogram-appid=\"wxd1310896f2aa68bb\" data-miniprogram-path=\"pages/payment/confirm_payment?controller=Experience&action=PlaceOrder&id=" + id.ToString() 
            + "\" href =\"http://" + Util.domainName.Trim() + "/pages/confirm_expierence_admit.aspx?id=" + expierence._fields["id"].ToString()
            + "\" >点击这里支付" + expierence._fields["guarantee_cash"].ToString().Trim() + "元押金</a>。";
        return repliedMessage;
    }

    public static RepliedMessage RentItemMessage(ReceivedMessage receivedMessage, RepliedMessage repliedMessage, int id)
    {
        WeixinUser borrower = new WeixinUser(receivedMessage.from.Trim());
        RentItem item = new RentItem(id);
        if (RentItem.CanRent(receivedMessage.from.Trim()))
        {
            
            
            item.Rent(receivedMessage.from.Trim());
            DateTime returnDate = DateTime.Parse(item._fields["schedule_return_date_time"].ToString());
            repliedMessage.type = "text";
            string msgTxt = "已确认租借：" + item._fields["item"].ToString().Trim() + "，归还时间：" + returnDate.Year.ToString()
                + "年" + returnDate.Month.ToString().ToString() + "月" + returnDate.Day.ToString() + "日" + returnDate.Hour.ToString() + "时";
            repliedMessage.content = "您" + msgTxt.Trim();
            ServiceMessage msg = new ServiceMessage();
            msg.from = "";
            msg.to = item._fields["lend_open_id"].ToString();
            msg.type = "text";
            msg.content = borrower.Nick.Trim() + " " + msgTxt.Trim();
            ServiceMessage.SendServiceMessage(msg);
            return repliedMessage;
        }
        else
        {
            string msgTxt = "在上次租借后，取关了公众号，并且到现在才开始关注，所以您没有权限再行租借物品。";
            repliedMessage.type = "text";
            repliedMessage.content = "您" + msgTxt;
            ServiceMessage msg = new ServiceMessage();
            msg.from = "";
            msg.to = item._fields["lend_open_id"].ToString();
            msg.type = "text";
            msg.content = borrower.Nick.Trim() + " " + msgTxt.Trim();
            ServiceMessage.SendServiceMessage(msg);
            return repliedMessage;
        }
    }

    public static RepliedMessage UseServiceCard(ReceivedMessage receivedMessage, RepliedMessage repliedMessage, string code)
    {
        WeixinUser user = new WeixinUser(receivedMessage.from.Trim());
        if (user.IsAdmin)
        {
            string[,] updateParam = new string[,] {
                {"used", "int", "1" }, {"use_date", "datetime", DateTime.Now.ToString() }, {"use_memo", "varchar", user.Nick + " 核销。" }
            };
            string name = "";
            bool success = false;
            if (code.Length == 9)
            {
                Card card = new Card(code);
                Product p = new Product(int.Parse(card._fields["product_id"].ToString()));
                if (!card.Used)
                {
                    success = true;
                }
                card.Use(DateTime.Now, user.Nick + " 核销。");
                name = p._fields["name"].ToString().Trim();
            }
            else if (code.Length == 12)
            {
                string[,] keyParam = new string[,] { { "card_no", "varchar", code.Substring(0,9) }, {"detail_no", "varchar", code.Substring(9, 3).Trim() } };
                
                Card.CardDetail detail = new Card.CardDetail(code);
                if (!detail.Used)
                {
                    success = true;
                }
                name = detail.Name.Trim();
                DBHelper.UpdateData("card_detail", updateParam, keyParam, Util.conStr);
            }
            repliedMessage.type = "text";
            repliedMessage.content = name + " 卡号：" + code.Trim() + (success?" 核销成功。":" 已经使用，不能再次核销。");
        }

        return repliedMessage;
    }

    public static RepliedMessage ScanToPayMaintask(ReceivedMessage receivedMessage, RepliedMessage repliedMessage, int taskId)
    {
        string messageText = "您将";
        SkiMaintainTask task = new SkiMaintainTask(taskId);
        if (task.TotalAmount > 0)
        {
            messageText = messageText + "支付" + task.TotalAmount.ToString() + "元 ";
        }
        if (task._fields["associate_card_no"].ToString().Length >= 9)
        { 
            Card card = new Card(task._fields["associate_card_no"].ToString().Substring(0, 9).Trim());
            string cardName = "";
            if (card.IsTicket)
            {
                cardName = card.associateTicket.Name.Trim();
            }
            else
            {
                if (!card._fields["product_id"].ToString().Trim().Equals("0"))
                {
                    Product p = new Product(int.Parse(card._fields["product_id"].ToString().Trim()));
                    cardName = p._fields["name"].ToString().Trim();
                }
                else
                {
                    cardName = card._fields["type"].ToString();
                }
            }
            messageText = messageText + " 将核销 " + cardName + "一张，编号：" + task._fields["associate_card_no"].ToString();
        }
        repliedMessage.type = "text";
        repliedMessage.content = messageText + "，<a href=\"http://" + Util.domainName.Trim() 
            + "/pages/confirm_maintain_task.aspx?id=" + taskId.ToString() + "\" >请点击确认</a>。";
        return repliedMessage;
    }
    public static RepliedMessage ScanToPayProduct(ReceivedMessage receivedMessage, RepliedMessage repliedMessage, int productId) 
    {
        Product p = new Product(productId);
        repliedMessage.type = "text";
        repliedMessage.content = "您即将购买：" + p._fields["name"].ToString().Trim() + ", 价格：" + p.SalePrice.ToString() 
            + "。<a href=\"http://" + Util.domainName.Trim() +  "/pages/ski_pass_today.aspx?id=" + productId.ToString() + "\" >点击此处支付</a>";
        return repliedMessage;
    }

    public static RepliedMessage ScanToPayChanneledProduct(ReceivedMessage receivedMessage, RepliedMessage repliedMessage, int productId, string channelId)
    {
        Product p = new Product(productId);
        repliedMessage.type = "text";
        repliedMessage.content = "您即将购买：" + p._fields["name"].ToString().Trim() + ", 价格：" + p.SalePrice.ToString()
            + "。<a href=\"http://" + Util.domainName.Trim() + "/pages/ski_pass_today.aspx?id=" + productId.ToString() + "&source=" + channelId.Trim() + "\" >点击此处支付</a>";
        return repliedMessage;
    }

    public static RepliedMessage ScanToPayTempOrder(ReceivedMessage receivedMessage, RepliedMessage repliedMessage, int tempOrderId)
    {
        //Product p = new Product(productId);
        OrderTemp orderTemp = new OrderTemp(tempOrderId);
        repliedMessage.type = "text";
       
        /*
        repliedMessage.content = "您即将支付：" + orderTemp._fields["sale_price"].ToString() + "元。"
            + "<a href=\"http://" + Util.domainName.Trim() + "/pages/pay_temp_order.aspx?temporderid=" + tempOrderId.ToString() + "\" >点击此处支付</a>";
        */
        
        repliedMessage.content = "您即将支付：" + orderTemp._fields["sale_price"].ToString() + "元。"
            + "<a  data-miniprogram-appid=\"wxd1310896f2aa68bb\" data-miniprogram-path=\"pages/payment/pay_temp_order?id=" + tempOrderId.ToString() + "\" >点击此处支付</a>"; // + tempOrderId.ToString().Trim（）;// + "\"  >点击此处支付</a>";
        
        return repliedMessage;
    }

    public static RepliedMessage ScanToPayOrder(ReceivedMessage receivedMessage, RepliedMessage repliedMessage, int orderId)
    {
        //Product p = new Product(productId);
        OnlineOrder order = new OnlineOrder(orderId);
        repliedMessage.type = "text";
        /*
        repliedMessage.content = "您即将支付：" + order._fields["order_real_pay_price"].ToString()
            + "元。<a href=\"http://" + Util.domainName.Trim() + "/payment/payment.aspx?product_id=" + orderId.ToString() + "\" >点击此处支付</a>";
        */
        
        
        repliedMessage.content = "您即将支付：" + order._fields["order_real_pay_price"].ToString()
            + "元。<a  data-miniprogram-appid=\"wxd1310896f2aa68bb\" data-miniprogram-path=\"pages/payment/payment?orderid=" 
            + orderId.ToString() + "\" href=\"http://" + Util.domainName.Trim() + "/payment/payment.aspx?product_id=" + orderId.ToString() + "\" >点击此处支付</a>";
        
        
        return repliedMessage;
    }

    public static RepliedMessage ScanToPayInShopMaintainId(ReceivedMessage receivedMessage, RepliedMessage repliedMessage, int id)
    {
        DataTable dtMaintain = DBHelper.GetDataTable(" select * from maintain_in_shop_request where [id] = " + id.ToString());
        if (dtMaintain.Rows.Count == 0)
        {
            repliedMessage.type = "text";
            repliedMessage.content = "系统出错。";
            return repliedMessage;
        }
        DBHelper.UpdateData("maintain_in_shop_request", new string[,] { { "open_id", "varchar", receivedMessage.from.Trim() } },
            new string[,] { { "id", "int", id.ToString() } }, Util.conStr);
        int productId = int.Parse(dtMaintain.Rows[0]["confirmed_product_id"].ToString());
        Product product = new Product();
        double productPrice = 0;
        if (productId > 0)
        {
            product = new Product(productId);
            productPrice = product.SalePrice;
        }
        string brand = dtMaintain.Rows[0]["confirmed_brand"].ToString();
        string type = dtMaintain.Rows[0]["confirmed_equip_type"].ToString();
        double addFee = double.Parse(dtMaintain.Rows[0]["confirmed_additional_fee"].ToString().Trim());
        string more = dtMaintain.Rows[0]["confirmed_more"].ToString().Trim();

        string messageText = "您的 " + brand.Trim() + " " + type + " " + type 
            + ((productId > 0)?" 的保养项目：" + product._fields["name"].ToString().Trim():"")
            + " " + (!more.Trim().Equals("") ? "附加项目：" + more : "")
            + (addFee != 0 ? ((addFee > 0 ? "附加费用：" : "优惠金额：") + Math.Round(Math.Abs(addFee), 2).ToString())+"元" : " ")
            + " 需要支付： " + Math.Round(productPrice + addFee, 2).ToString() + "元。 <a href=\"http://" 
            + Util.domainName.Trim() +  "/pages/confirm_in_shop_maintain_task.aspx?id=" + id.ToString() + "\" >" +
            "点击支付</a>";

        /*
        messageText = "您的 " + brand.Trim() + " " + type + " " + type
            + ((productId > 0) ? " 的保养项目：" + product._fields["name"].ToString().Trim() : "")
            + " " + (!more.Trim().Equals("") ? "附加项目：" + more : "")
            + (addFee != 0 ? ((addFee > 0 ? "附加费用：" : "优惠金额：") + Math.Round(Math.Abs(addFee), 2).ToString()) + "元" : " ")
            + " 需要支付： " + Math.Round(productPrice + addFee, 2).ToString() + "元。 <a data-miniprogram-appid=\"wxd1310896f2aa68bb\" "
            + "  data-miniprogram-path=\"pages/payment/confirm_payment?controller="   href =\"http://"
            + Util.domainName.Trim() + "/pages/confirm_in_shop_maintain_task.aspx?id=" + id.ToString() + "\" >" +
            "点击支付</a>";
        */

        repliedMessage.type = "text";
        repliedMessage.content = messageText.Trim();
        return repliedMessage;
    }

    public static RepliedMessage ScanToPayInShopMaintainBatchId(ReceivedMessage receivedMessage, RepliedMessage repliedMessage, int batchId)
    {
        DataTable dtMaintain = DBHelper.GetDataTable(" select * from maintain_in_shop_request where batch_id = " + batchId.ToString());
        if (dtMaintain.Rows.Count == 0)
        {
            repliedMessage.type = "text";
            repliedMessage.content = "系统出错。";
            return repliedMessage;
        }

        DBHelper.UpdateData("maintain_in_shop_request", new string[,] { { "open_id", "varchar", receivedMessage.from.Trim() } },
            new string[,] { { "batch_id", "int", batchId.ToString() } }, Util.conStr);


        string messageText = "";
        double totalFee = 0;
        foreach (DataRow dr in dtMaintain.Rows)
        {
            int productId = int.Parse(dr["confirmed_product_id"].ToString());
            Product product = new Product();
            double productPrice = 0;
            if (productId > 0)
            {
                product = new Product(productId);
                productPrice = product.SalePrice;
            }
            string brand = dr["confirmed_brand"].ToString();
            string type = dr["confirmed_equip_type"].ToString();
            double addFee = double.Parse(dr["confirmed_additional_fee"].ToString().Trim());
            string more = dr["confirmed_more"].ToString().Trim();
            string messageSubText =  brand.Trim() + " " + type + " " + type
            + ((productId > 0) ? " 的保养项目：" + product._fields["name"].ToString().Trim() : "")
            + " " + (!more.Trim().Equals("") ? "附加项目：" + more : "")
            + (addFee != 0 ? ((addFee > 0 ? "附加费用：" : "优惠金额：") + Math.Round(Math.Abs(addFee), 2).ToString()) + "元" : " ")
            + " 需要支付： " + Math.Round(productPrice + addFee, 2).ToString() + "元。";
            messageText = messageText + messageSubText;
            totalFee = totalFee + Math.Round(productPrice + addFee, 2);
        }
        messageText = "您的" + dtMaintain.Rows.Count.ToString() + "套雪板: " + messageText + " 总计需要支付费用：" + Math.Round(totalFee, 2).ToString()
            + "元，<a data-miniprogram-appid=\"wxd1310896f2aa68bb\"  data-miniprogram-path=\"pages/payment/confirm_payment?controller=MaintainLive&action=PlaceOrderBatch&id=" + batchId.ToString() 
            + "\" href =\"http://" + Util.domainName.Trim() + "/pages/confirm_in_shop_maintain_task.aspx?batchid=" + batchId.ToString() + "\" >"
            + "点击支付</a>";
        repliedMessage.type = "text";
        repliedMessage.content = messageText.Trim();
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
                order.SetOrderPaySuccess(DateTime.Now, "");
                orderTemp.FinishOrder();
                Point.AddNew(receivedMessage.from.Trim(), int.Parse(orderTemp._fields["generate_score"].ToString()),
                    DateTime.Now, orderTemp._fields["memo"].ToString());
                replyMessage.content = "感谢惠顾，您已经获得" + orderTemp._fields["generate_score"].ToString()
                    + "颗龙珠，您可以<a href=\"http://weixin.snowmeet.top/pages/dragon_ball_list.aspx\" >点击查看详情</a>。";
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
            replyMessage.content = "<a href=\"http://weixin.snowmeet.top/pages/confirm_order_info.aspx?id=" + orderTemp._fields["id"].ToString() + "\" >请点击确认支付</a>。";
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
                repliedMessage.content = "http://weixin.snowmeet.top/pages/register_cell_number.aspx";
                break;
            case "收款":
                repliedMessage.type = "text";
                repliedMessage.content = "http://weixin.snowmeet.top/pages/admin/wechat/admin_charge_shop_sale_new.aspx";
                break;
            case "邀请":
                repliedMessage = GetInviteMessage(receivedMessage);
                break;
            case "菜单":
                repliedMessage.type = "text";
                repliedMessage.content = "http://weixin.snowmeet.top/pages/admin/wechat/admin_menu.aspx";
                break;
            case "我的二维码":
                string qrCodePath = QrCode.GetStaticQrCode("openid_" + receivedMessage.from.Trim(), "images/qrcode");
                string mediaId = Util.UploadImageToWeixin(System.Configuration.ConfigurationSettings.AppSettings["web_site_physical_path"].Trim() + "\\" + qrCodePath.Trim().Replace("/", "\\"), Util.GetToken().Trim());
                repliedMessage.type = "image";
                repliedMessage.content = mediaId.Trim();
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
        repliedMessage.content = "<a href=\"http://weixin.snowmeet.top/show_qrcode.aspx?sceneid=" + user.QrCodeSceneId.ToString() + "\"  >点击查看二维码</a>";
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
            repliedMessage.content = "请<a href=\"http://weixin.snowmeet.top/pages/register_cell_number.aspx\" >点击这里</a>绑定手机号码后重新扫描设备的二维码。";
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
                        repliedMessage.content = repliedMessage.content + "请<a href=\"http://weixin.snowmeet.top/pages/register_cell_number.aspx\" >点击这里</a>绑定手机号码以获得签到积分。";
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
                        repliedMessage.content = repliedMessage.content + "请<a href=\"http://weixin.snowmeet.top/pages/register_cell_number.aspx\" >点击这里</a>绑定手机号码以获得签到积分。";
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
        content.picUrl = "http://weixin.snowmeet.top/images/invite_ticket.jpg";
        content.url = "http://weixin.snowmeet.top/pages/register_cell_number.aspx?fatheropenid=" + receiveMessage.from;
        content.description = "请将此消息转发给他人。";
        repliedMessage.newsContent = new RepliedMessage.news[] { content };
        return repliedMessage;
    }

    public static void SendCustomeRequestToAssistant(ReceivedMessage receivedMessage)
    {
        string content = receivedMessage.eventKey.Trim().Replace("qrscene_", "").Trim();
        if (content.StartsWith("openid"))
        {
            string assistantOpenId = content.Replace("openid_", "");
            WeixinUser assistant = new WeixinUser(assistantOpenId.Trim());
            if (assistant.IsAdmin)
            {
                ServiceMessage serviceMessage = new ServiceMessage();
                serviceMessage.from = receivedMessage.to.Trim();
                serviceMessage.to = assistantOpenId;
                WeixinUser customer = new WeixinUser(receivedMessage.from.Trim());
                serviceMessage.type = "news";
                RepliedMessage.news newsMessage = new RepliedMessage.news();
                newsMessage.picUrl = customer.HeadImage;
                newsMessage.title = customer.Nick.Trim() + " 请求结账";
                newsMessage.description = newsMessage.title.Trim();
                newsMessage.url = "http://weixin.snowmeet.top/pages/admin/wechat/admin_charge_shop_sale_simple.aspx?openid="
                    + customer.OpenId.Trim();
                serviceMessage.newsArray = new RepliedMessage.news[] { newsMessage }; 
                ServiceMessage.SendServiceMessage(serviceMessage);
            }
        }
    }

}