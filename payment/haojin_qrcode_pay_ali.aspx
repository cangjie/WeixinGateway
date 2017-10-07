<%@ Page Language="C#" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string paymentDomain = System.Configuration.ConfigurationSettings.AppSettings["payment_haojin_domain_name"];
        string md5Key = System.Configuration.ConfigurationSettings.AppSettings["haojin_key"];
        string appCode = System.Configuration.ConfigurationSettings.AppSettings["haojin_code"];

        int orderId = int.Parse(Util.GetSafeRequestValue(Request, "orderid", "118"));

        if (orderId > 0)
        {
            OnlineOrder order = new OnlineOrder(orderId);
            if (order.PayMethod.Trim().Equals("支付宝") && order._fields["pay_state"].ToString().Trim().Equals("0"))
            {
                string txamt = "1";
                string txcurrcd = "CNY";
                string pay_type = "800101";
                string out_trade_no = orderId.ToString();
                string txdtm = DateTime.Now.Year.ToString() + "-" + DateTime.Now.Month.ToString().PadLeft(2,'0') + "-"
                    + DateTime.Now.Day.ToString().PadLeft(2,'0') + " " + DateTime.Now.Hour.ToString().PadLeft(2, '0') + ":"
                    + DateTime.Now.Minute.ToString().PadLeft(2, '0') + ":" + DateTime.Now.Minute.ToString().PadLeft(2, '0');
                string goods_name = "易龙雪聚";
                OnlineOrderDetail[] orderDetailArr = order.OrderDetails;
                if (orderDetailArr.Length > 0)
                {
                    goods_name = orderDetailArr[0].productName.Trim();
                    if (orderDetailArr.Length > 1)
                    {
                        goods_name = goods_name + " 等" + orderDetailArr.Length.ToString() + "件商品";
                    }
                }


                string mchid = Util.GetMchId(order);

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
                //Response.Write(str.Trim());
                //Response.End();
                try
                {
                    string qrCode = Util.GetSimpleJsonValueByKey(str, "qrcode");
                    Response.Redirect("../show_qrcode.aspx?qrcodetext=" + Server.UrlEncode(qrCode.Trim()));
                }
                catch
                {

                }
            }
        }
        Response.Write("{\"status\": 1}");

    }
</script>