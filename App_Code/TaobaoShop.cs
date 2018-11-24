using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text.RegularExpressions;
using System.Text;
/// <summary>
/// Summary description for TaobaoShop
/// </summary>
public class TaobaoShop
{
    public string shopUserId = "";

    public string shopName = "";

    public string shopId = "";

    public TaobaoShop(string id)
    {
        shopUserId = id.Trim();
    }

    public string Name
    {
        get
        {
            if (shopName.Trim().Equals(""))
            {
                string content = Core.Util.GetWebContent("http://store.taobao.com/view_shop.htm?user_number_id=" + shopUserId.Trim(), "GET", "", "html/text", Core.TaobaoSnap.taobaoCookie, Encoding.GetEncoding("GB2312"));
                int shopNameIndex = content.IndexOf("shop-name");
                content = content.Substring(shopNameIndex, content.Length - shopNameIndex);
                content = content.Substring(0, content.IndexOf("</a>"));
                content = content.Replace("\r", " ").Replace("\n", " ");
                Match m = Regex.Match(content, "<a.+?>");
                shopNameIndex = content.IndexOf(m.Value.Trim());
                content = content.Substring(shopNameIndex, content.Length - shopNameIndex);
                shopName = GetRidOfHTMLTag(content).Replace("进入店铺", "").Trim();
                if (shopName.IndexOf(">") >= 0)
                {
                    try
                    {
                        shopName = shopName.Split('>')[1].Trim();
                    }
                    catch
                    {
                        shopName = "";
                    }
                }
            }
            return shopName.Trim();
        }
    }

    public string ShopId
    {
        get
        {
            if (shopId.Trim().Equals(""))
            {
                string content = Core.Util.GetWebContent("http://store.taobao.com/view_shop.htm?user_number_id=" + shopUserId.Trim(), "GET", "", "", Core.TaobaoSnap.taobaoCookie, Encoding.UTF8);
                int shopIdIndex = content.IndexOf("\"shopId\":");
                if (shopIdIndex < 0)
                {
                    return "";
                }
                content = content.Substring(shopIdIndex, content.Length - shopIdIndex);
                content = content.Substring(0, content.IndexOf(","));
                System.Text.RegularExpressions.Match m = System.Text.RegularExpressions.Regex.Match(content, @"\d+");
                shopId = m.Value.Trim();
            }
            return shopId.Trim();
        }
    }

    public static string GetRidOfHTMLTag(string content)
    {
        Regex reg = new Regex("<.*?>");
        MatchCollection mc = reg.Matches(content);
        foreach (Match m in mc)
        {
            content = content.Replace(m.Value.Trim(), "");
        }
        return content;
    }
}