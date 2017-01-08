<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Xml" %>
<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        //string keyValuePair = "txamt=1&txcurrcd=CNY&pay_type=800207";
        //Response.Write(Util.GetHaojinMd5Sign(keyValuePair.Trim(),"7AB7F12D1A374208BA9A9E29E337BAEE"));

        /*
        SalesFlowSheet sfs = new SalesFlowSheet(Server.MapPath("bayi.xlsx"));
        sfs.SetFieldsPosition();
        sfs.FillDragonBallBlank();
        sfs.Dispose();
        */
        /*
        for(int i = 0; i < 600; i++)
        {
            Card.GenerateCardNo(9, 1);

        }

        */

        //Order.ImportOrderDragonBall("NS2016120401");
        /*
        string jsonStr = "{\"pay_type\": \"800207\", \"sysdtm\": \"2016-12-21 18:01:58\", \"cardcd\": \"\", \"txdtm\": \"2016-12-21 18:01:01\", \"resperr\": \"\u4ea4\u6613\u6210\u529f\", \"txcurrcd\": \"CNY\", \"txamt\": \"100\", \"respmsg\": \"\", \"out_trade_no\": \"sn00001\", \"syssn\": \"20161221016100020000037001\", \"respcd\": \"0000\", \"pay_params\": {\"package\": \"prepay_id=wx20161221180159c2ea37c18e0197721796\", \"timeStamp\": \"1482314519519\", \"signType\": \"MD5\", \"paySign\": \"4310D42DCBC6A1DBB6125A40DB1C8A67\", \"appId\": \"wx290ce4878c94369d\", \"nonceStr\": \"1482314519519\"}}";
        Dictionary<string, object> payParam = Util.GetObjectFromJsonByKey(jsonStr, "pay_params");
        KeyValuePair<string, object>[] keyValuePairArray = payParam.ToArray();

        Response.Write(Util.GetSimpleJsonStringFromKeyPairArray(keyValuePairArray));
        */
        //Response.Write(DateTime.Now.GetDateTimeFormats());
    }



</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
    </div>
    </form>
</body>
</html>
