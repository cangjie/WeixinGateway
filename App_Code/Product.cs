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
        else
        {
            sqlStr = sqlStr + " name like '八亿%' ";
        }

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