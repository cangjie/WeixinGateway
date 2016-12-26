<%@ Page Language="C#" %>
<%@ Import Namespace="System.IO" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        StreamReader sr = new StreamReader(Request.InputStream);
        string paymentResult = sr.ReadToEnd();
        sr.Close();
        string status = Util.GetSimpleJsonValueByKey(paymentResult, "status").Trim();
        string out_trade_no = Util.GetSimpleJsonValueByKey(paymentResult, "out_trade_no").Trim();
        string notify_type = Util.GetSimpleJsonValueByKey(paymentResult, "notify_type").Trim();
        if (notify_type.Trim().Equals("payment") && status.Trim().Equals("1"))
        {
            OnlineOrder order = new OnlineOrder(int.Parse(out_trade_no));
            order.SetOrderPaySuccess(DateTime.Now);
            if (order.Type.Trim().Equals("雪票"))
            {
                order.CreateSkiPass();
            }
        }
        //File.AppendAllText(Server.MapPath("payment_result.txt"), paymentResult + "\r\n");
    }
</script>
SUCCESS