using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Collections;
using System.Text.RegularExpressions;
/// <summary>
/// Summary description for TaobaoKeyword
/// </summary>
public class TaobaoKeyword
{
    public string keyword = "";

    public string brand = "";

    public DateTime lastRefreshTime = DateTime.MinValue;

    public DataTable resultTable;

    public static TaobaoKeyword[] taobaoKeywordArray = new TaobaoKeyword[0];

    public TaobaoKeyword(string brand, string keyword)
    {
        //
        // TODO: Add constructor logic here
        //
        this.keyword = keyword;
        this.brand = brand;
    }

    public void RefreshResultTable()
    {
        resultTable = GetData(brand + " " + keyword);
        lastRefreshTime = DateTime.Now;
    }

    public DataTable ResultTable
    {
        get
        {
            if (DateTime.Now - lastRefreshTime > new TimeSpan(12, 0, 0) || resultTable == null || resultTable.Rows.Count == 0)
            {
                RefreshResultTable();
            }
            return resultTable;
        }
    }

    public DataTable NewShopResultTable
    {
        get
        {
            DataTable dt = ResultTable;
            DataTable dtOld = DBHelper.GetDataTable(" select * from b2cmonitor_taobao_shop_list where keyword =  '" + brand.Trim().Replace("'", "") + "' ");
            DataTable dtNew = dt.Clone();
            foreach (DataRow dr in dt.Rows)
            {
                if (dtOld.Select(" id = '" + dr["店铺ID"].ToString() + "'").Length == 0)
                {
                    DataRow drNew = dtNew.NewRow();
                    foreach (DataColumn c in dt.Columns)
                    {
                        drNew[c.Caption.Trim()] = dr[c];
                    }
                    dtNew.Rows.Add(drNew);
                }
            }
            return dtNew;
        }
    }

    public static TaobaoKeyword GetTaobaoKeywordResult(string brand, string keyword)
    {
        bool found = false;
        TaobaoKeyword keywordTemp = new TaobaoKeyword("", "");
        for (int i = 0; i < taobaoKeywordArray.Length; i++)
        {
            keywordTemp = taobaoKeywordArray[i];
            if (keywordTemp.brand.Trim().Equals(brand.Trim()) && keywordTemp.keyword.Trim().Equals(keyword.Trim()))
            {
                found = true;
                break;
            }
        }
        if (found)
        {
            return keywordTemp;
        }
        else
        {
            TaobaoKeyword[] newArray = new TaobaoKeyword[taobaoKeywordArray.Length + 1];
            for (int i = 0; i < taobaoKeywordArray.Length; i++)
            {
                newArray[i] = taobaoKeywordArray[i];
            }
            newArray[newArray.Length - 1] = new TaobaoKeyword(brand, keyword);
            taobaoKeywordArray = newArray;
            return newArray[newArray.Length - 1];
        }
    }

    public static TaobaoKeyword[] GetAllBrandsKeyword()
    {
        ArrayList keywordsArr = new ArrayList();
        DataTable dt = DBHelper.GetDataTable(" select * from b2cmonitor_brand  ");
        foreach (DataRow dr in dt.Rows)
        {
            string brand = dr["brand_name"].ToString().Trim();
            TaobaoKeyword k = new TaobaoKeyword(brand, brand);
            keywordsArr.Add(k);
            foreach (string keyword in dr["alias"].ToString().Trim().Split(','))
            {
                TaobaoKeyword kk = new TaobaoKeyword(brand, keyword.Trim());
                keywordsArr.Add(kk);
            }
        }
        TaobaoKeyword[] taobaoKeywordArr = new TaobaoKeyword[keywordsArr.Count];
        for (int i = 0; i < taobaoKeywordArr.Length; i++)
        {
            taobaoKeywordArr[i] = (TaobaoKeyword)keywordsArr[i];
        }
        return taobaoKeywordArr;
    }

    public static DataTable GetData(string keyWord)
    {
        DataTable dt = new DataTable();
        dt.Columns.Add("店铺");
        dt.Columns.Add("店铺ID");
        dt.Columns.Add("店铺URL");
        dt.Columns.Add("商品");
        dt.Columns.Add("商品ID");
        dt.Columns.Add("商品URL");
        dt.Columns.Add("图片");
        dt.Columns.Add("价格");


        int pageSize = 0;
        int totalCount = 0;
        for (int i = 0; ((i == 0 && pageSize == 0 && totalCount == 0) || (i < totalCount)) && i < 1000; i = i + pageSize)
        {
            try
            {
                string json = GetTaobaoSearchJson(keyWord, i);
                FillDataTable(json, dt);
                try
                {
                    pageSize = GetPageSize(json);
                }
                catch
                {

                }
                try
                {
                    totalCount = GetTotalCount(json);
                }
                catch
                {

                }
            }
            catch
            {
                break;
            }
        }
        return dt;
    }

    public static string GetTaobaoSearchJson(string keyWord, int index)
    {
        //string ret = Util.GetWebContent("https://s.taobao.com/search?q=" + keyWord.Trim()  + (index>0? "&s=" + index.ToString():"")<a href="../../C94AC000">../../C94AC000</a>, "GET", "", "text/html", new System.Net.CookieCollection(), System.Text.Encoding.GetEncoding("GB2312"));
        string ret = Core.Util.GetWebContent("https://s.taobao.com/search?q=" + keyWord.Trim() + (index > 0 ? "&s=" + index.ToString() : ""), "GET", "", "text/html",
            Core.TaobaoSnap.taobaoCookie, System.Text.Encoding.UTF8);
        int startIndex = ret.IndexOf("{\"pageName\":\"mainsrp\"");
        ret = ret.Substring(startIndex, ret.Length - startIndex);
        int endIndex = ret.IndexOf("};");
        ret = ret.Substring(0, endIndex + 1);
        return ret;
    }

    public static int GetTotalCount(string json)
    {
        int totalCount = 0;
        try
        {
            Dictionary<string, object> pagerObject = (Dictionary<string, object>)((Dictionary<string, object>)((Dictionary<string, object>)Util.GetObjectFromJsonByKey(json, "mods"))["pager"]);
            totalCount = int.Parse(((Dictionary<string, object>)(Dictionary<string, object>)pagerObject["data"])["totalCount"].ToString());
        }
        catch
        {
            try
            {
                Dictionary<string, object> modObject = (Dictionary<string, object>)((Dictionary<string, object>)((Dictionary<string, object>)Util.GetObjectFromJsonByKey(json, "mods"))["sortbar"]);
                Dictionary<string, object> dataObject = (Dictionary<string, object>)modObject["data"];
                Dictionary<string, object> pagerObject = (Dictionary<string, object>)dataObject["pager"];
                totalCount = int.Parse(pagerObject["totalCount"].ToString().Trim());
            }
            catch
            {

            }
        }
        return totalCount;
    }

    public static int GetPageSize(string json)
    {
        int pageSize = 0;
        try
        {
            Dictionary<string, object> pagerObject = (Dictionary<string, object>)((Dictionary<string, object>)((Dictionary<string, object>)Util.GetObjectFromJsonByKey(json, "mods"))["pager"]);
            pageSize = int.Parse(((Dictionary<string, object>)(Dictionary<string, object>)pagerObject["data"])["pageSize"].ToString());
        }
        catch
        {
            try
            {
                Dictionary<string, object> modObject = (Dictionary<string, object>)((Dictionary<string, object>)((Dictionary<string, object>)Util.GetObjectFromJsonByKey(json, "mods"))["sortbar"]);
                Dictionary<string, object> dataObject = (Dictionary<string, object>)modObject["data"];
                Dictionary<string, object> pagerObject = (Dictionary<string, object>)dataObject["pager"];
                pageSize = int.Parse(pagerObject["pageSize"].ToString().Trim());
            }
            catch
            {

            }
        }
        return pageSize;
    }

    public static void FillDataTable(string json, DataTable dt)
    {
        Dictionary<string, object> objMods = (Dictionary<string, object>)Util.GetObjectFromJsonByKey(json, "mods");

        Dictionary<string, object> dataObject = (Dictionary<string, object>)((Dictionary<string, object>)objMods["itemlist"])["data"];
        object[] auctionObjectArray = (object[])dataObject["auctions"];
        foreach (object auctionObject in auctionObjectArray)
        {
            Dictionary<string, object> auction = (Dictionary<string, object>)auctionObject;
            string productId = auction["nid"].ToString().Trim();
            if (dt.Select(" 商品ID = '" + productId.Trim() + "' ").Length == 0)
            {
                DataRow dr = dt.NewRow();
                dr["商品ID"] = productId.Trim();
                dr["店铺"] = auction["nick"].ToString().Trim();
                dr["店铺ID"] = auction["user_id"].ToString().Trim();
                dr["商品"] = GetRidOfHTMLTag(auction["title"].ToString().Trim());
                dr["图片"] = auction["pic_url"].ToString().Trim();
                dr["商品URL"] = auction["detail_url"].ToString().Trim();
                dr["价格"] = auction["view_price"].ToString().Trim();
                dt.Rows.Add(dr);
            }
            //DataRow dr = dt.NewRow();

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