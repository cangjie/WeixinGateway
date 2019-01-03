using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;


/// <summary>
/// Summary description for Product
/// </summary>
public class Product
{
    public DataRow _fields;

    public Product()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public Product(int id)
    {
        DataTable dt = DBHelper.GetDataTable("select * from product where [id] = " + id.ToString());
        _fields = dt.Rows[0];
    }

    public static Product[] GetSkiPassList(string resort)
    {
        string sqlStr = " select * from product where type = '雪票' and  hidden = 0 and ";
        if (resort.Trim().Equals("nanshan"))
        {
            sqlStr = sqlStr + " name like '南山%' ";
        }
        if (resort.Trim().Equals("bayi"))
        {
            sqlStr = sqlStr + " name like '万龙八易%' and shop = '八易' ";
        }
        if (resort.Trim().Equals("bayidan"))
        {
            sqlStr = sqlStr + " name like '万龙八易%' and shop = '八易租单板' ";
        }
        if (resort.Trim().Equals("bayishuang"))
        {
            sqlStr = sqlStr + " name like '万龙八易%' and shop = '八易租双板' ";
        }

        if (resort.Trim().Equals("qiaobo"))
        {
            sqlStr = sqlStr + " name like '乔波%' ";
        }
        if (resort.Trim().Equals("wanlong"))
        {
            sqlStr = sqlStr + " name like '万龙%' ";
        }
        sqlStr = sqlStr + "  order by sort desc ";
        DataTable dt = DBHelper.GetDataTable(sqlStr);
        Product[] productArr = new Product[dt.Rows.Count];
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            productArr[i] = new Product();
            productArr[i]._fields = dt.Rows[i];
        }
        return productArr;
    }
}