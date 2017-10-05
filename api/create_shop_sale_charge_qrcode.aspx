<%@ Page Language="C#" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string token = Util.GetSafeRequestValue(Request, "token", "01127366f2f219f3578b75fbd32a3bb2f200ac7fcf3051fa5bf5515f0321f86e43592f6e");
        double marketPrice = double.Parse(Util.GetSafeRequestValue(Request, "marketprice", "2"));
        double salePrice = double.Parse(Util.GetSafeRequestValue(Request, "saleprice", "1.9"));
        double ticketAmount = double.Parse(Util.GetSafeRequestValue(Request, "ticketamount", "0"));
        string memo = Util.GetSafeRequestValue(Request, "memo", "测试店销产品");
        string payMethod = Util.GetSafeRequestValue(Request, "paymethod", "哆啦宝");
        string shop = Util.GetSafeRequestValue(Request, "shop", "南山");
        string openId = WeixinUser.CheckToken(token);
        string memberType = Util.GetSafeRequestValue(Request, "membertype", "");
        string recommenderNumber = Util.GetSafeRequestValue(Request, "recommendernumber", "");
        string recommenderType = Util.GetSafeRequestValue(Request, "recommendertype", "");
        string name = Util.GetSafeRequestValue(Request, "name", "");
        string orderDetailJson = Util.GetSafeRequestValue(Request, "reforderdetail", "");
        WeixinUser currentUser = new WeixinUser(openId);

        if (!currentUser.IsAdmin)
        {
            Response.Write("{\"status\":1, \"err_msg\":\"Is not admin.\" }");
            Response.End();
        }

        int chargeId = OrderTemp.AddNewOrderTemp(marketPrice, salePrice, ticketAmount, memo, openId, payMethod, shop,
            memberType, recommenderNumber, recommenderType, name, orderDetailJson);
        //if (payMethod.Trim().Equals("现金") || payMethod.Trim().Equals("刷卡"))
        Response.Write("{\"status\":0, \"charge_id\":\"4294" + chargeId.ToString().PadLeft(6, '0') + "\" }");
        /*
        else
        {
            string mchid = "eA8qkhmq2M";
            switch (shop)
            {
                case "南山":
                    mchid = "DdAjZF6rrY";
                    break;
                case "八易":
                    mchid = "wQ2V3sMj71";
                    break;
                case "乔波":
                    mchid = "eA8qkhmq2M";
                    break;
                case "万龙":
                    mchid = "g6VB7srLmY";
                    break;
                default:
                    break;
            }
            string pay_type = payMethod.Trim().Equals("微信") ? "800201" : "800101";

            string paymentDomain = System.Configuration.ConfigurationSettings.AppSettings["payment_haojin_domain_name"];
            string md5Key = System.Configuration.ConfigurationSettings.AppSettings["haojin_key"];
            string appCode = System.Configuration.ConfigurationSettings.AppSettings["haojin_code"];

            string txamt = "1";
            string txcurrcd = "CNY";
            string out_trade_no = "shop_sale_charge_" + chargeId.ToString();
            string txdtm = DateTime.Now.Year.ToString() + "-" + DateTime.Now.Month.ToString().PadLeft(2,'0') + "-"
                + DateTime.Now.Day.ToString().PadLeft(2,'0') + " " + DateTime.Now.Hour.ToString().PadLeft(2, '0') + ":"
                + DateTime.Now.Minute.ToString().PadLeft(2, '0') + ":" + DateTime.Now.Minute.ToString().PadLeft(2, '0');
            string goods_name = "snowmeet test";

            string postData = "txamt=" + txamt + "&txcurrcd=" + txcurrcd + "&pay_type=" + pay_type + "&out_trade_no=" + out_trade_no
                + "&txdtm=" + txdtm +  "&goods_name=" + goods_name+"&mchid=" + mchid.Trim();

            string jumpUrl = "https://" + paymentDomain + "/trade/v1/payment";
            HttpWebRequest req = (HttpWebRequest)WebRequest.Create(jumpUrl);
            req.Method = "POST";
            req.ContentType = "application/x-www-form-urlencoded";
            req.Headers.Add("X-QF-APPCODE", appCode);
            req.Headers.Add("X-QF-SIGN", Util.GetHaojinMd5Sign(postData, md5Key));
            Stream requestStream = req.GetRequestStream();
            StreamWriter sw = new StreamWriter(requestStream);
            sw.Write(postData);
            sw.Close();
            HttpWebResponse res = (HttpWebResponse)req.GetResponse();
            StreamReader sr = new StreamReader(res.GetResponseStream());
            string str = sr.ReadToEnd();
            sr.Close();
            res.Close();
            req.Abort();
            string qrCodeUrl = Util.GetSimpleJsonValueByKey(str, "qrcode");
            Response.Write("{\"status\":0, \"qr_code_url\":\"" + Server.UrlEncode(qrCodeUrl.Trim()) + "\" }");
            //Response.Write("");
            
        }*/
    }
</script>