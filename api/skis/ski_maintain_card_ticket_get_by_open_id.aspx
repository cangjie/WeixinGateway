<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string openId = Util.GetSafeRequestValue(Request, "openid", "oZBHkjhdFpC5ScK5FUU7HKXE3PJM");
        string[,] cardArr = new string[3,3] { { "", "", "" }, { "", "", "" }, { "", "", "" } };
        Ticket[] ticketArr = Ticket.GetUserTickets(openId, false);
        bool haveEdge = false;
        bool haveEdgeAndCandle = false;
        foreach (Ticket ticket in ticketArr)
        {
            if (!haveEdge && ticket._fields["template_id"].ToString().Equals("6"))
            {
                for (int i = 0; i < cardArr.Length / 3; i = i + 3)
                {
                    if (cardArr[i / 3, 0].Trim().Equals(""))
                    {
                        cardArr[i / 3, 0] = ticket.Code;
                        cardArr[i / 3, 1] = ticket.Name.Trim();
                        cardArr[i / 3, 2] = "";
                        haveEdge = true;
                        break;
                    }
                }
            }
            if (!haveEdgeAndCandle && ticket._fields["template_id"].ToString().Equals("5"))
            {
                for (int i = 0; i < cardArr.Length / 3; i = i + 3)
                {
                    if (cardArr[i / 3, 0].Trim().Equals(""))
                    {
                        cardArr[i / 3, 0] = ticket.Code;
                        cardArr[i / 3, 1] = ticket.Name.Trim();
                        cardArr[i / 3, 2] = "";
                        haveEdgeAndCandle = true;
                        break;
                    }
                }
            }
            if (haveEdgeAndCandle && haveEdge)
            {
                break;
            }
        }
        bool haveServiceCard = false;
        Card[] cardArray = Card.GetCardList(openId.Trim());
        foreach (Card card in cardArray)
        {
            if (card._fields["product_id"].ToString().Equals("141"))
            {
                Card.CardPackageUsage[] packageArr = card.CardPackageUsageList;
                foreach (Card.CardPackageUsage item in packageArr)
                {
                    if (item.productDetailId == 1 && item.avaliableCount > 0)
                    {
                        for (int i = 0; i < cardArr.Length; i = i + 3)
                        {
                            if (cardArr[i / 3, 0].Trim().Equals(""))
                            {
                                cardArr[i / 3, 0] = item.firstAvaliableCardCode.Trim();
                                cardArr[i / 3, 1] = item.name.Trim();
                                cardArr[i / 3, 2] = "剩余" + item.avaliableCount.ToString();
                                haveServiceCard = true;
                                break;
                            }
                        }
                        break;
                    }
                }

            }
            if (haveServiceCard)
            {
                break;
            }
        }

        string json = "";
        for (int i = 0; i < cardArr.Length; i = i + 3)
        {
            if (!cardArr[i / 3, 0].Trim().Equals(""))
            {
                string subJson = "{\"card_no\": \"" + cardArr[i / 3, 0].Trim() + "\", \"name\": \"" + cardArr[i / 3, 1].Trim() + "\", \"memo\": \"" + cardArr[i / 3, 2].Trim() + "\" }";
                json = json + (json.Trim().Equals("") ? "" : ", ") + subJson.Trim();
            }
        }
        Response.Write("{\"status\": 0, \"card\":[" + json + "]}");
    }
</script>