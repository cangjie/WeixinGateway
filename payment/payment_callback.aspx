<%@ Page Language="C#" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Xml" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string str = new System.IO.StreamReader(Request.InputStream).ReadToEnd();
        File.AppendAllText(Server.MapPath("../log/payment_callback.txt"), str + "\r\n");
        XmlDocument xmlD = new XmlDocument();
        xmlD.LoadXml(str);
        Order order = new Order(xmlD.SelectSingleNode("//xml/out_trade_no").InnerText.Trim());
        if (xmlD.SelectSingleNode("//xml/result_code").InnerText.Trim().ToUpper().Equals("SUCCESS") &&
            xmlD.SelectSingleNode("//xml/return_code").InnerText.Trim().ToUpper().Equals("SUCCESS"))
        {

            order.Status = 2;
        }
        else
        {
            order.Status = -1;
        }
    }
</script>
<xml>
   <return_code><![CDATA[SUCCESS]]></return_code>
   <return_msg><![CDATA[OK]]></return_msg>
</xml>