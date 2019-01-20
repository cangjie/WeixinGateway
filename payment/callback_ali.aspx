<%@ Page Language="C#" %>
<%@ Import Namespace="System.IO" %>
<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string str = new System.IO.StreamReader(Request.InputStream).ReadToEnd();
        //string str = "<xml><appid><![CDATA[wxf91253fd1c38d24e]]></appid><bank_type><![CDATA[BOC_CREDIT]]></bank_type><cash_fee>100</cash_fee><fee_type><![CDATA[CNY]]></fee_type><is_subscribe><![CDATA[Y]]></is_subscribe><mch_id>1517744411</mch_id><nonce_str><![CDATA[wkbatngrykdtzlyezcbjctwzcvh6eam]]></nonce_str><openid><![CDATA[oZBHkjhdFpC5ScK5FUU7HKXE3PJM]]></openid><out_trade_no>1545741911002312</out_trade_no><result_code><![CDATA[SUCCESS]]></result_code><return_code><![CDATA[SUCCESS]]></return_code><time_end>20181225204518</time_end><total_fee>100</total_fee><trade_type><![CDATA[JSAPI]]></trade_type><transaction_id>4200000242201812253307744218</transaction_id><sign><![CDATA[E5A9E5AC8F501AA12E41ED6A5C91283A]]></sign></xml>";
        try
        {
            File.AppendAllText(Server.MapPath("../log/payment_callback_ali.txt"), str + "\r\n");
        }
        catch
        {

        }
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
