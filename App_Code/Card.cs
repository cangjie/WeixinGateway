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
    public Card()
    {
        //
        // TODO: Add constructor logic here
        //
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