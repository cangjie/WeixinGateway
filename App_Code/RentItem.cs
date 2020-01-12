using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

/// <summary>
/// Summary description for RentItem
/// </summary>
public class RentItem
{
    public DataRow _fields;
    public RentItem(int id)
    {
        DataTable dt = DBHelper.GetDataTable(" select * from rent_item where [id] = " + id.ToString());
        if (dt.Rows.Count == 1)
        {
            _fields = dt.Rows[0];
        }
    }

    public void Rent(string openId)
    {
        if (_fields["status"].ToString().Trim().Equals("0"))
        {
            string[,] updateParam = new string[,] { { "borrow_open_id", "varchar", openId.Trim() }, {"status", "int", "1" }, 
                {"rent_date_time", "datetime", DateTime.Now.ToString() }, {"update_date", "datetime", DateTime.Now.ToString() } };
            string[,] keyParam = new string[,] { { "id", "int", _fields["id"].ToString().Trim() } };
            DBHelper.UpdateData("rent_item", updateParam, keyParam, Util.conStr.Trim());
        }
    }

    public void Return(string openId)
    {
        if (_fields["status"].ToString().Trim().Equals("1"))
        {
            string[,] updateParam = new string[,] { { "return_open_id", "varchar", openId.Trim() }, { "status", "int", "2" }, 
                { "return_date_time", "datetime", DateTime.Now.ToString() }, {"update_date", "datetime", DateTime.Now.ToString() } };
            string[,] keyParam = new string[,] { { "id", "int", _fields["id"].ToString().Trim() } };
            DBHelper.UpdateData("rent_item", updateParam, keyParam, Util.conStr.Trim());
        }
    }

    public static int NewRent(string itemName, string itemMemo, string securityType, string securityContent, 
        string lendOpenId, DateTime scheduleReturnDateTime)
    {
        string[,] insertParam = new string[,] { {"item", "varchar", itemName.Trim()}, {"memo", "varchar", itemMemo.Trim() }, {"security_type", "varchar", securityType.Trim() },
            {"security_content", "varchar", securityContent.Trim() }, {"lend_open_id", "varchar", lendOpenId.Trim() }, {"schedule_return_date_time", "datetime", scheduleReturnDateTime.ToString() } };
        int i = DBHelper.InsertData("rent_item", insertParam);
        if (i == 1)
        {
            DataTable dt = DBHelper.GetDataTable(" select max([id]) from rent_item ");
            int newId = int.Parse(dt.Rows[0][0].ToString());
            dt.Dispose();
            return newId;
        }
        else
        {
            return 0;
        }
    }


}