using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

/// <summary>
/// Summary description for Ticket
/// </summary>
public class Ticket
{

    public struct TicketTemplate
    {
        public int id;
        public double currencyValue;
        public int availableDays;
        public string memo;
        public int neetPoints;
    }

    public DataRow _fields;

    public Ticket(string code)
    {
        //
        // TODO: Add constructor logic here
        //
        DataTable dt = DBHelper.GetDataTable(" select * from ticket where code = '" + code.Trim() + "'  ");
        if (dt.Rows.Count == 0)
            throw new Exception("Ticket is not exists.");
        else
        {
            _fields = dt.Rows[0];
        }
    }

    public static TicketTemplate GetTicketTemplate(int templateId)
    {
        TicketTemplate tt = new TicketTemplate();
        DataTable dt = DBHelper.GetDataTable(" select * from ticket_template where [id] = " + templateId.ToString());
        if (dt.Rows.Count == 0)
            throw new Exception("Ticket template is not exsits.");
        else
        {
            tt.id = int.Parse(dt.Rows[0]["id"].ToString().Trim());
            tt.currencyValue = double.Parse(dt.Rows[0]["currency_value"].ToString());
            tt.availableDays = int.Parse(dt.Rows[0]["available_days"].ToString());
            tt.memo = dt.Rows[0]["memo"].ToString().Trim();
            tt.neetPoints = int.Parse(dt.Rows[0]["need_points"].ToString());
        }
        return tt;
    }

    public static string GenerateNewTicket(string openId, int templateId)
    {
        string code = GenerateNewTicketCode();
        DataTable dtTemplate = DBHelper.GetDataTable(" select * from ticket_template where [id] = " + templateId.ToString());
        int i = 0;
        if (dtTemplate.Rows.Count == 1)
        {
            double amount = double.Parse(dtTemplate.Rows[0]["currency_value"].ToString().Trim());
            DateTime expireDate = DateTime.Now.AddDays(int.Parse(dtTemplate.Rows[0]["available_days"].ToString().Trim()));
            string memo = dtTemplate.Rows[0]["memo"].ToString().Trim();
            string[,] insertParameters = { {"code", "varchar", code },
                {"user_open_id", "varchar", openId.Trim() },
                {"template_id", "int", templateId.ToString() },
                {"amount", "float", Math.Round(amount,2).ToString() },
                {"expire_date", "datetime", expireDate.ToString() },
                {"memo", "varchar", memo.Trim() } };
            i = DBHelper.InsertData("ticket", insertParameters);
        }
        dtTemplate.Dispose();
        if (i == 1)
            return code.Trim();
        else
            return "";
    }

    public static string GenerateNewTicketCode()
    {
        string code = "";
        for (; code.Trim().Equals("");)
        {
            string codeTemp = GetRandomString(9);
            DataTable dt = DBHelper.GetDataTable(" select * from ticket where code = '" + codeTemp.Trim() + "'  ");
            if (dt.Rows.Count == 0)
            {
                code = codeTemp.Trim();
            }
            dt.Dispose();
        }
        return code;
    }

    public static string GetRandomString(int digit)
    {
        Dictionary<int, char> charHash = new Dictionary<int, char>();

        charHash.Add(0, '1');
        charHash.Add(1, '2');
        charHash.Add(2, '3');
        charHash.Add(3, '4');
        charHash.Add(4, '5');
        charHash.Add(5, '6');
        charHash.Add(6, '7');
        charHash.Add(7, '8');
        charHash.Add(8, '9');
        charHash.Add(9, '0');
        /*
        charHash.Add(9, 'A');
        charHash.Add(10, 'B');
        charHash.Add(11, 'C');
        charHash.Add(12, 'D');
        charHash.Add(13, 'E');
        charHash.Add(14, 'F');
        charHash.Add(15, 'G');
        charHash.Add(16, 'H');
        charHash.Add(17, 'I');
        charHash.Add(18, 'J');
        charHash.Add(19, 'K');
        charHash.Add(20, 'L');
        charHash.Add(21, 'M');
        charHash.Add(22, 'N');
        charHash.Add(23, 'P');
        charHash.Add(24, 'Q');
        charHash.Add(25, 'R');
        charHash.Add(26, 'R');
        charHash.Add(27, 'T');
        charHash.Add(28, 'U');
        charHash.Add(29, 'V');
        charHash.Add(30, 'W');
        charHash.Add(31, 'X');
        charHash.Add(32, 'Y');
        charHash.Add(33, 'Z');
        */
        string retCode = "";
        Random rnd = new Random();
        for (int i = 0; i < digit; i++)
        {
            retCode = retCode + charHash[rnd.Next(charHash.Count)];
        }


        return retCode;
    }
}