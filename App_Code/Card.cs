using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

/// <summary>
/// Summary description for Card
/// </summary>
public class Card
{

    public DataRow _fields;

    public Card()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public Card(string code)
    {
        DataTable dt = DBHelper.GetDataTable(" select * from card where card_no = '" + code + "' ");
        _fields = dt.Rows[0];
    }

    public void Use(DateTime useDateTime)
    {
        string[,] updateParam = { {"used", "int", "1" }, {"use_date", "datetime", useDateTime.ToString() } };
        string[,] keyParam = { {"code", "varchar", _fields["code"].ToString() } };
        DBHelper.UpdateData("card", updateParam, keyParam, Util.conStr);
    }

    public static string GenerateCardNo(int digit, int batchId)
    {
        
        string no = Ticket.GetRandomString(digit);
        for (; ExsitsCardNo(no);)
        {
            no = Ticket.GetRandomString(digit);
        }
        string[,] insertParam = { { "card_no", "varchar", no.Trim()}, { "batch_id", "int", batchId.ToString()} };
        int i = DBHelper.InsertData("card", insertParam);
        if (i == 1)
            return no;
        else
            return "";
    }

    public static string GenerateCardNo(int digit, int batchId, string cardType)
    {

        string no = Ticket.GetRandomString(digit);
        for (; ExsitsCardNo(no);)
        {
            no = Ticket.GetRandomString(digit);
        }
        string[,] insertParam = { { "card_no", "varchar", no.Trim() }, 
            { "batch_id", "int", batchId.ToString() }, {"type", "varchar", cardType.Trim() } };
        int i = DBHelper.InsertData("card", insertParam);
        if (i == 1)
            return no;
        else
            return "";
    }



    public static bool ExsitsCardNo(string no)
    {
        DataTable dt = DBHelper.GetDataTable(" select 'a' from card where card_no = '" + no.Trim().Replace("'", "") + "' ");
        bool ret = false;
        if (dt.Rows.Count >= 1)
            ret = true;
        dt.Dispose();
        return ret;
    }
}