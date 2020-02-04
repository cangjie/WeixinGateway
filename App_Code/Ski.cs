using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

/// <summary>
/// Summary description for Ski
/// </summary>
public class Ski
{
    public DataRow _filds;

    public Ski()
    {

    }

    public Ski(int id)
    {
        DataTable dt = DBHelper.GetDataTable("select * from skis where [id] = " + id.ToString());
        if (dt.Rows.Count == 1)
        {
            _filds = dt.Rows[0];
        }
        else
        {
            throw new Exception("The record is not found.");
        }
    }

    public Ski(string riId)
    {
        DataTable dt = DBHelper.GetDataTable("select * from skis where rfid = '" + riId.Trim() + "' ");
        if (dt.Rows.Count == 1)
        {
            _filds = dt.Rows[0];
        }
        else
        {
            throw new Exception("The record is not found.");
        }
    }

    public static int CreateNewSki(string rfId, string rfidType, string type, string brand, string serialName, string madeOfYear, string length)
    {
        int numericId = 0;
        bool exists = false;
        DataTable dt = DBHelper.GetDataTable(" select 'a' from skis where rfid = '" + rfId.Trim() + "' ");
        if (dt.Rows.Count > 0)
        {
            exists = true;
        }
        dt.Dispose();
        if (!exists)
        {
            int i = DBHelper.InsertData("skis", new string[,] { {"rfid", "varchar", rfId.Trim() }, { "rfid_type", "varchar", rfidType.Trim() }, 
                {"ski_type", "varchar", type.Trim() }, {"brand", "varchar", brand.Trim() }, {"serial_name", "varchar", serialName.Trim() }, 
                {"year_of_made", "varchar", madeOfYear.Trim() }, {"length", "varchar", length.Trim() } });
            if (i == 1)
            {
                dt = DBHelper.GetDataTable(" select max(id) from skis ");
                if (dt.Rows.Count > 0)
                {
                    numericId = int.Parse(dt.Rows[0][0].ToString());
                }
                dt.Dispose();
            }
        }
        return numericId;
    }
    
}