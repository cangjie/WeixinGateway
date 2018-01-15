<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Xml" %>
<!DOCTYPE html>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        int i = Point.AddNew("aaa", 10, DateTime.Now, "111");
        Response.Write(i.ToString());
        //Point.ImportPointsByNumber("13910071912");

        //string jsonStr = "{\"pay_type\": \"800207\", \"sysdtm\": \"2018-01-02 16:46:54\", \"cardcd\": \"\", \"txdtm\": \"2018-01-02 16:46:46\", \"resperr\": \"\u7f51\u7edc\u6709\u4e9b\u62e5\u5835\uff0c\u5ba2\u5b98\u83ab\u6025\uff0c\u5207\u52ff\u91cd\u590d\u652f\u4ed8\uff0c\u5982\u5df2\u652f\u4ed8\u8bf7\u7a0d\u540e\u786e\u8ba4\u7ed3\u679c(1298)\", \"txcurrcd\": \"CNY\", \"txamt\": \"38500\", \"respmsg\": \"\", \"out_trade_no\": \"515\", \"syssn\": \"20180102000300020047092609\", \"respcd\": \"1298\"}";
        //string errMsg = Util.GetSimpleJsonValueByKey(jsonStr, "resperr");
        

        //Response.Write(Server.MapPath("/pages/images/cuiyangpay.jpeg"));
        //Ticket t = new Ticket("345678923");
        //t.IsSharing = true;
        //t.Transfer("oZBHkjoXAYNrx5wKCWRCD5qSGrPM");

        //ReceivedMessage rec = new ReceivedMessage("event_20171221151543921");
        //DealMessage.DealEventMessage(rec);

        /*
        string no = "";
        for (int i = 0; i < 500; i++)
        {
            no = Card.GenerateCardNoWithPassword(9, 1, 6, "内购券");
            if (no.Trim().Equals(""))
                i--;
        }
        */
        //OrderTemp orderTemp = new OrderTemp(25);
        //orderTemp.PlaceOnlineOrder("oZBHkjhdFpC5ScK5FUU7HKXE3PJM");
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div></div>
    </form>
</body>
</html>
