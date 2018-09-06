using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

/// <summary>
/// Summary description for SearchResultCache
/// </summary>
public class SearchResultCache
{
    public static SearchResultCache[] cacheArr = new SearchResultCache[0];

    public SearchResultCache(string keyword, DataTable dt)
    {
        //
        // TODO: Add constructor logic here
        //
        this.keyword = keyword;
        resultTable = dt;
        searchTime = DateTime.Now;
    }

    public SearchResultCache()
    {

    }

    public string keyword = "";

    public DataTable resultTable;

    public DateTime searchTime;

    public static SearchResultCache GetResultByKeyword(string keyword)
    {
        SearchResultCache foundCache = new SearchResultCache();
        foreach (SearchResultCache cache in cacheArr)
        {
            if (cache.keyword.Trim().Equals(keyword.Trim()))
            {
                if ((DateTime.Now - cache.searchTime) < new TimeSpan(1, 0, 0))
                {
                    foundCache = cache;
                }
                else
                {
                    ArrayList newArr = new ArrayList();
                    foreach (SearchResultCache subCache in cacheArr)
                    {
                        if (!subCache.keyword.Trim().Equals(keyword.Trim()))
                        {
                            newArr.Add(subCache);
                        }
                    }
                    cacheArr = new SearchResultCache[newArr.Count];
                    for (int i = 0; i < cacheArr.Length; i++)
                    {
                        cacheArr[i] = (SearchResultCache)newArr[i];
                    }

                }
            }
        }
        return foundCache;
    }

    public static void AddCache(string keyword, DataTable dt)
    {
        SearchResultCache[] newCacheArr = new SearchResultCache[cacheArr.Length + 1];
        for (int i = 0; i < cacheArr.Length; i++)
        {
            newCacheArr[i] = cacheArr[i];
        }
        SearchResultCache tail = new SearchResultCache(keyword, dt);
        newCacheArr[newCacheArr.Length - 1] = tail;
        cacheArr = newCacheArr;
    }
}