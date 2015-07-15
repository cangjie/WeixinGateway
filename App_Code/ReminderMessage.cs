using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;

/// <summary>
/// Summary description for ReminderMessage
/// </summary>
public class ReminderMessage
{
	public ReminderMessage()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    public static void SendRedminderMessage(string openId, string content, DateTime scheduledTime)
    {
        KeyValuePair<string, KeyValuePair<SqlDbType, object>>[] messageParameterArr
            = new KeyValuePair<string, KeyValuePair<SqlDbType, object>>[3];
        messageParameterArr[0] = new KeyValuePair<string, KeyValuePair<SqlDbType, object>>("open_id",
            new KeyValuePair<SqlDbType, object>(SqlDbType.VarChar, (object)openId));
        messageParameterArr[1] = new KeyValuePair<string, KeyValuePair<SqlDbType, object>>("content",
            new KeyValuePair<SqlDbType, object>(SqlDbType.VarChar, (object)content));
        messageParameterArr[2] = new KeyValuePair<string, KeyValuePair<SqlDbType, object>>("scheduled_send_date",
            new KeyValuePair<SqlDbType, object>(SqlDbType.VarChar, (object)scheduledTime));
        DBHelper.InsertData("reminder_message", messageParameterArr);
        
    }
}