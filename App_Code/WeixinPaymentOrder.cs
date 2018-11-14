using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Xml;

/// <summary>
/// Summary description for Order
/// </summary>
public class WeixinPaymentOrder
{

    public DataRow _fields;

    public WeixinPaymentOrder(string outTradeNo)
    {
        SqlDataAdapter da = new SqlDataAdapter(" select * from weixin_payment_orders where order_out_trade_no = "
            + Int64.Parse(outTradeNo).ToString(), Util.conStr.Trim());
        DataTable dt = new DataTable();
        da.Fill(dt);
        da.Dispose();
        if (dt.Rows.Count > 0)
        {
            _fields = dt.Rows[0];
        }
    }

    public string PrepayId
    {
        set
        {
            string sql = " update weixin_payment_orders set order_prepay_id = '" + value.Trim().Replace("'", "")
                + "'  where order_out_trade_no = '" + _fields["order_out_trade_no"].ToString().Trim() + "'  ";
            SqlConnection conn = new SqlConnection(Util.conStr);
            SqlCommand cmd = new SqlCommand(sql, conn);
            conn.Open();
            cmd.ExecuteNonQuery();
            conn.Close();
            cmd.Dispose();
            conn.Dispose();
        }
    }

    public int Status
    {
        get
        {
            //Status = 0;
            int currentStatus = int.Parse(_fields["order_is_paid"].ToString().Trim());
            if (currentStatus == 1)
            {
                bool realPaidResult = GetPaidResultFromWeixin(_fields["order_out_trade_no"].ToString().Trim());
                if (realPaidResult)
                {
                    Status = 2;
                    return 2;
                }
                else
                {
                    return int.Parse(_fields["order_is_paid"].ToString().Trim());
                }

            }
            else
            {
                return int.Parse(_fields["order_is_paid"].ToString().Trim());
            }
        }
        set
        {
            string sql = " update weixin_payment_orders set order_is_paid = '" + value.ToString()
                + "'  where order_out_trade_no = '" + _fields["order_out_trade_no"].ToString().Trim() + "'  ";
            SqlConnection conn = new SqlConnection(Util.conStr);
            SqlCommand cmd = new SqlCommand(sql, conn);
            conn.Open();
            cmd.ExecuteNonQuery();
            conn.Close();
            cmd.Dispose();
            conn.Dispose();
        }
    }



    public static int CreateOrder(
        string outTradeNo,
        string appId,
        string mchId,
        string nonceStr,
        string openId,
        string body,
        string detail,
        string productId,
        int totalFee,
        string spBillCreateIp
        )
    {
        string sql = "insert into weixin_payment_orders ("
            + " order_out_trade_no , "
            + " order_appid , "
            + " order_mchid , "
            + " order_nonce_str , "
            + " order_openid , "
            + " order_body , "
            + " order_detail , "
            + " order_product_id , "
            + " order_total_fee , "
            + " order_spbill_create_ip ) "
            + " values ( "
            + Int64.Parse(outTradeNo).ToString() + "  , "
            + "'" + appId.Trim().Replace("'", "") + "' , "
            + "'" + mchId.Trim().Replace("'", "") + "' , "
            + "'" + nonceStr.Trim().Replace("'", "") + "' , "
            + "'" + openId.Trim().Replace("'", "") + "' , "
            + "'" + body.Trim().Replace("'", "") + "' , "
            + "'" + detail.Trim().Replace("'", "") + "' , "
            + "'" + productId.Trim().Replace("'", "") + "' , "
            + totalFee.ToString() + ","
            + "'" + spBillCreateIp.Trim().Replace("'", "") + "'  ) ";

        SqlConnection conn = new SqlConnection(Util.conStr);
        SqlCommand cmd = new SqlCommand(sql, conn);
        conn.Open();
        int i = cmd.ExecuteNonQuery();
        conn.Close();
        cmd.Dispose();
        conn.Dispose();
        return i;
    }

    public static Order GetOrderByOriginInfo(string body, int productId, int amount)
    {
        DataTable dt = DBHelper.GetDataTable(" select * from weixin_payment_orders where order_body = '" + body.Trim().Replace("'", "") + "'  and "
            + "  order_product_id = " + productId.ToString() + "  and order_total_fee = " + amount.ToString() + "  ", Util.conStr.Trim());
        if (dt.Rows.Count > 0)
        {
            return new Order(dt.Rows[0][0].ToString());
        }
        else
        {
            return null;
        }

    }


    public static bool GetPaidResultFromWeixin(string outTradeNo)
    {
        string appId = System.Configuration.ConfigurationSettings.AppSettings["wxappid"].Trim();
        string mchId = System.Configuration.ConfigurationSettings.AppSettings["mch_id"].Trim();
        string queryXmlString = "<xml><appid>" + appId.Trim() + "</appid><mch_id>" + mchId.Trim() + "</mch_id><nonce_str>"
            + Util.GetNonceString(10) + "</nonce_str><out_trade_no>" + outTradeNo.Trim() + "</out_trade_no></xml>";
        XmlDocument xmlD = new XmlDocument();
        xmlD.LoadXml(queryXmlString);
        string stringWillBeEcrypt = "";
        foreach (XmlNode n in xmlD.SelectSingleNode("//xml").ChildNodes)
        {
            stringWillBeEcrypt = stringWillBeEcrypt + "&"
                + n.Name.Trim() + "=" + n.InnerText.Trim();
        }
        if (stringWillBeEcrypt.StartsWith("&"))
            stringWillBeEcrypt = stringWillBeEcrypt.Remove(0, 1);
        string sign = Util.GetMd5Sign(stringWillBeEcrypt, "jihuowangluoactivenetworkjarrodc");
        XmlNode signNode = xmlD.CreateNode(XmlNodeType.Element, "sign", "");
        signNode.InnerText = sign.ToUpper().Trim();
        xmlD.SelectSingleNode("//xml").AppendChild(signNode);
        string resultStr = Util.GetWebContent("https://api.mch.weixin.qq.com/pay/orderquery", "POST", xmlD.InnerXml, "html/xml");
        xmlD.LoadXml(resultStr);
        bool result = false;
        try
        {
            if (xmlD.SelectSingleNode("//xml/return_msg").InnerText.Trim().ToUpper().Equals("OK")
                && xmlD.SelectSingleNode("//xml/return_code").InnerText.Trim().ToUpper().Equals("SUCCESS"))
            {
                result = true;
            }
        }
        catch
        {
        }
        return result;
    }

}
