﻿using System;
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

    public Ticket()
    {

    }

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

    public bool Use(string word)
    {
        if (!Used)
        {
            string[,] updateParameters = new string[,] { { "used", "int", "1" },
                {"use_date", "datetime", DateTime.Now.ToString() },
                {"use_memo", "varchar", word } };
            string[,] keyParameter = new string[,] { { "code", "varchar", Code.Trim() } };
            int i = DBHelper.UpdateData("ticket", updateParameters, keyParameter, Util.conStr);
            if (i == 1)
                return true;
            else
                return false;
        }
        else
        {
            return false;
        }
       
    }

    public string Code
    {
        get
        {
            return _fields["code"].ToString();
        }
    }

    public WeixinUser Owner
    {
        get
        {
            return new WeixinUser(_fields["user_open_id"].ToString().Trim());
        }
    }

    public double Amount
    {
        get
        {
            return double.Parse(_fields["amount"].ToString());
        }
    }

    public DateTime ExpireDate
    {
        get
        {
            return DateTime.Parse(_fields["expire_date"].ToString());
        }
    }

    public bool Used
    {
        get
        {
            return _fields["used"].ToString().Equals("1");
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

    public static void GenerateNewTicket(string code, string openId, int templateId)
    {
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

    public static TicketTemplate[] GetAllTicketTemplate()
    {
        DataTable dt = DBHelper.GetDataTable(" select * from ticket_template where valid = 1 order by [id] ");
        TicketTemplate[] ticketTemplateArray = new TicketTemplate[dt.Rows.Count];
        for (int i = 0; i < ticketTemplateArray.Length; i++)
        {
            ticketTemplateArray[i] = new TicketTemplate();
            ticketTemplateArray[i].id = int.Parse(dt.Rows[i]["id"].ToString());
            ticketTemplateArray[i].availableDays = int.Parse(dt.Rows[i]["available_days"].ToString());
            ticketTemplateArray[i].currencyValue = int.Parse(dt.Rows[i]["currency_value"].ToString());
            ticketTemplateArray[i].memo = dt.Rows[i]["memo"].ToString().Trim();
            ticketTemplateArray[i].neetPoints = int.Parse(dt.Rows[i]["need_points"].ToString());
        }
        return ticketTemplateArray;
    }

    public static Ticket[] GetUserAllTickets(string openId)
    {
        DataTable dt = DBHelper.GetDataTable(" select * from ticket where user_open_id = '" + openId + "'  order by create_date ");
        Ticket[] ticketArray = new Ticket[dt.Rows.Count];
        for (int i = 0; i < ticketArray.Length; i++)
        {
            ticketArray[i] = new Ticket();
            ticketArray[i]._fields = dt.Rows[i];
        }
        return ticketArray;
    }

    public static Ticket[] GetUserTickets(string openId, bool isUsed)
    {
        DataTable dt = DBHelper.GetDataTable(" select * from ticket where open_id = '" + openId + "' "
            + " and " + (isUsed?" used = 1 ":" used = 0 ")
            + "  order by create_date  ");
        Ticket[] ticketArray = new Ticket[dt.Rows.Count];
        for (int i = 0; i < ticketArray.Length; i++)
        {
            ticketArray[i] = new Ticket();
            ticketArray[i]._fields = dt.Rows[i];
        }
        return ticketArray;
    }
}