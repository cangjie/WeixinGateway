<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string ret = Util.GetWebContent("https://s.taobao.com/search?q=桨板");
        //System.IO.File.AppendAllText(Server.MapPath("result.txt"), ret);
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
</script>