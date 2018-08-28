<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Text.RegularExpressions" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        GetProductTable(GetRealProdctListUrl("35022423"));
        //string domain = GetShopDomain("35022423");
        Response.End();

        string ret = Util.GetWebContent("http://shop108820453.taobao.com/search.htm");
        System.IO.File.AppendAllText(Server.MapPath("result3.txt"), ret);

        Response.End();

        int startIndex = ret.IndexOf("{\"pageName\":\"mainsrp\"");
        ret = ret.Substring(startIndex, ret.Length - startIndex);
        int endIndex = ret.IndexOf("};");
        ret = ret.Substring(0, endIndex+1);
        //System.IO.File.AppendAllText(Server.MapPath("result.txt"), ret);
        Dictionary<string, object> dataObject = (Dictionary<string, object>)((Dictionary<string, object>)((Dictionary<string, object>)Util.GetObjectFromJsonByKey(ret, "mods"))["itemlist"])["data"];
        Dictionary<string, object> pagerObject = (Dictionary<string, object>)((Dictionary<string, object>)((Dictionary<string, object>)Util.GetObjectFromJsonByKey(ret, "mods"))["pager"]);
        int totalCount = int.Parse(((Dictionary<string, object>)(Dictionary<string, object>)pagerObject["data"])["totalCount"].ToString());
        object[] auctionObjectArray = (object[])dataObject["auctions"];

        DataTable dt = new DataTable();
        dt.Columns.Add("店铺");
        dt.Columns.Add("店铺ID");
        dt.Columns.Add("店铺URL");
        dt.Columns.Add("商品");
        dt.Columns.Add("商品ID");
        dt.Columns.Add("商品URL");
        dt.Columns.Add("图片");
        dt.Columns.Add("价格");

        foreach (object o in auctionObjectArray)
        {
            DataRow dr = dt.NewRow();
            Dictionary<string, object> t = (Dictionary<string, object>)o;
            dr["商品"] = t["title"].ToString();
        }

    }



    public static string GetShopId(string userNumberId)
    {
        string content = Util.GetWebContent("http://store.taobao.com/view_shop.htm?user_number_id=" + userNumberId.Trim());
        int shopIdIndex = content.IndexOf("\"shopId\":");
        if (shopIdIndex < 0)
        {
            return "";
        }
        content = content.Substring(shopIdIndex, content.Length - shopIdIndex);
        content = content.Substring(0, content.IndexOf(","));
        System.Text.RegularExpressions.Match m = System.Text.RegularExpressions.Regex.Match(content, @"\d+");
        return m.Value;
    }

    public static string GetRealProdctListUrl(string shopId)
    {
        System.Net.CookieCollection cookieCollection = new System.Net.CookieCollection();
        cookieCollection.Add(new System.Net.Cookie("enc", "s4%2Ffi0IKXvGV9dFSRwlxImLOvjSxECcfBNVmt3buw60wMECiJvbCPihU4Lcpkjf8%2B2ijT6wI3mD8pFhPqhHuSQ%3D%3D"));
        string content = Util.GetWebContent("http://shop" + shopId.Trim() + ".taobao.com/search.htm", "GET", "", "", cookieCollection, Encoding.GetEncoding("GB2312"));
        int startIndex = content.IndexOf("id=\"J_ShopAsynSearchURL\"");
        if (startIndex < 0)
        {
            return "";
        }
        content = content.Substring(startIndex, content.Length - startIndex);
        startIndex = content.IndexOf("value");
        content = content.Substring(startIndex, content.Length - startIndex);
        startIndex = content.IndexOf("=");
        content = content.Substring(startIndex, content.Length - startIndex);
        startIndex = content.IndexOf("\"");
        content = content.Substring(startIndex, content.Length - startIndex);
        content = content.Remove(0, 1);

        int endIndex = content.IndexOf("\"");
        content = content.Substring(0, endIndex);

        string domain = GetShopDomain(shopId);
        if (domain.Trim().Equals(""))
        {
            domain = "shop" + shopId.Trim() + ".taobao.com";
        }

        return "http://" + domain.Trim() + content.Trim();
    }

    public static string GetShopDomain(string shopId)
    {
        string content = Util.GetWebContent("http://shop" + shopId + ".taobao.com");
        int startIndex = content.IndexOf("<a class=\"shop-name\"");
        content = content.Substring(startIndex, content.Length - startIndex);
        content = content.Substring(0, content.IndexOf(">"));
        startIndex = content.IndexOf("//");
        content = content.Substring(startIndex, content.Length - startIndex).Replace("\"", "").Replace("//", "");
        return content;
    }

    public static DataTable GetProductTable(string url)
    {
        DataTable dt = new DataTable();
        dt.Columns.Add("product_id");
        dt.Columns.Add("product_name");
        dt.Columns.Add("price");
        dt.Columns.Add("sale_num");
        dt.Columns.Add("image_url");
        dt.Columns.Add("reviews_num");
        bool duplicateProduct = false;
        Regex regex = new Regex("<dl class=\"item \" data-id=\"\\d+\"");
        System.Net.CookieCollection cookieCollection = new System.Net.CookieCollection();
        cookieCollection.Add(new System.Net.Cookie("enc", "s4%2Ffi0IKXvGV9dFSRwlxImLOvjSxECcfBNVmt3buw60wMECiJvbCPihU4Lcpkjf8%2B2ijT6wI3mD8pFhPqhHuSQ%3D%3D"));
        int totalPage = 1;
        for (int i = 1; i <= totalPage && i < 500; i++)
        {
            string content = Util.GetWebContent(url + "&pageNo=" + i.ToString(), "GET", "", "", cookieCollection, Encoding.GetEncoding("GB2312")).Replace("\\\"", "\"");
            int startIndex = content.IndexOf("page-info");
            string pageContent = content.Substring(startIndex, content.Length - startIndex);
            pageContent = pageContent.Substring(0, content.IndexOf("</span>"));
            Match matchPage = Regex.Match(pageContent, @"\d+/\d+");
            totalPage = int.Parse(matchPage.Value.Split('/')[1]);
            //content = Encoding.UTF8.GetString(Encoding.GetEncoding("GB2312").GetBytes(content));
            System.IO.File.AppendAllText(@"C:\Users\cangj\Source\Repos\weixingateway\b2c_analyze\taobao\search.txt", content);
            MatchCollection mc = regex.Matches(content.Trim());
            foreach (Match m in mc)
            {
                startIndex = content.IndexOf(m.Value.Trim());
                string subContent = content.Substring(startIndex, content.Length - startIndex);
                subContent = subContent.Substring(0, subContent.IndexOf("</dl>"));
                string productId = Regex.Match(subContent, "data-id=\"\\d+\"").Value.Trim().Replace("\"", "").Replace("data-id=", "");
                startIndex = content.IndexOf("<a class=\"item-name J_TGoldData\"");
                subContent = content.Substring(startIndex, content.Length - startIndex);
                subContent = subContent.Substring(0, subContent.IndexOf("</a>"));
                startIndex = subContent.IndexOf(">");
                subContent = subContent.Substring(startIndex, subContent.Length - startIndex);
                subContent = subContent.Replace(">", "").Trim();
                string productName = subContent;
                startIndex = content.IndexOf("c-price");
                subContent = content.Substring(startIndex, content.Length - startIndex);
                subContent = subContent.Substring(0, subContent.IndexOf("</span>"));
                string price = Regex.Match(subContent, @"\d+\.*\d*").Value.Trim();
                startIndex = content.IndexOf("sale-num");
                subContent = content.Substring(startIndex, content.Length - startIndex);
                subContent = subContent.Substring(0, subContent.IndexOf("</span>"));
                string saleNum = Regex.Match(subContent, @"\d+").Value.Trim();

                startIndex = content.IndexOf("<h4>");
                subContent = content.Substring(startIndex, content.Length - startIndex);
                subContent = subContent.Substring(0, subContent.IndexOf("</h4>"));
                startIndex = subContent.IndexOf("<span>");
                subContent = subContent.Substring(startIndex, subContent.Length - startIndex);
                subContent = subContent.Substring(0, subContent.IndexOf("</span>"));
                //subContent = subContent.Replace("</span>", "").Trim();
                string reviewsNum = subContent.Replace("<span>", "");
                //productName = Encoding.GetEncoding("GB2312").GetString(Encoding.UTF8.GetBytes(productName));
                
            }
            System.Threading.Thread.Sleep(20000);
        }
        return dt;
    }

</script>