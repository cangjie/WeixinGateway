using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Threading;
using System.Data;
/// <summary>
/// Summary description for ServiceMessage
/// </summary>
public class ServiceMessage
{
    public string from = "";
    public string to = "";
    public string type = "";
    public string content = "";
    public string imageUrl = "";
    public string voiceUrl = "";
    public RepliedMessage.news[] newsArray;

    public static Thread sendThread;

    public static bool sendingReminder = true;


    public ServiceMessage(string jsonStr)
	{
        JavaScriptSerializer serializer = new JavaScriptSerializer();
        Dictionary<string, object> json = (Dictionary<string, object>)serializer.DeserializeObject(jsonStr);
            
        object v;
        json.TryGetValue("touser",out v);
        to = v.ToString();
        json.TryGetValue("fromuser", out v);
        from = v.ToString();
        json.TryGetValue("msgtype", out v);
        type = v.ToString();
        Dictionary<string, object> subJson;
        switch (type.ToLower().Trim())
        { 
            case "text":
                json.TryGetValue("text", out v);
                subJson = (Dictionary<string, object>)v;
                subJson.TryGetValue("content", out v);
                content = v.ToString().Trim();
                break;
            case "news":
                json.TryGetValue("news", out v);
                subJson = (Dictionary<string, object>)v;
                subJson.TryGetValue("articles", out v);
                object[] vArray = (object[])v;
                newsArray = new RepliedMessage.news[vArray.Length];
                for (int i = 0; i < newsArray.Length; i++)
                {
                    newsArray[i] = new RepliedMessage.news();
                    subJson = (Dictionary<string, object>)vArray[i];
                    subJson.TryGetValue("title", out v);
                    newsArray[i].title = v.ToString().Trim();
                    subJson.TryGetValue("description", out v);
                    newsArray[i].description = v.ToString().Trim();
                    subJson.TryGetValue("url", out v);
                    newsArray[i].url = v.ToString().Trim();
                    subJson.TryGetValue("picurl", out v);
                    newsArray[i].picUrl = v.ToString().Trim();
                }
                break;
            default:
                break;
        }
	}

    public static int SendServiceMessage(ServiceMessage serviceMessage)
    {
        RepliedMessage repliedMessage = new RepliedMessage();
        repliedMessage.from = serviceMessage.from;
        repliedMessage.to = serviceMessage.to;
        repliedMessage.rootId = "";
        repliedMessage.type = serviceMessage.type.Trim();
        repliedMessage.content = serviceMessage.content.Trim();
        if (serviceMessage.type.Trim().Equals("news") && serviceMessage.newsArray!=null  )
            repliedMessage.newsContent = serviceMessage.newsArray;
        repliedMessage.SendAsServiceMessage();
        repliedMessage.hasSent = true;
        return RepliedMessage.AddRepliedMessage(repliedMessage);
    }

    public static void SendScheduleMessage()
    {
        for (; sendingReminder ; )
        {
            DataTable dt = DBHelper.GetDataTable(" select * from reminder_message where scheduled_send_date < getdate() and status = 0 ");

            
            //beforeSendUpdateParameterPairArr[0].Key = "";
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                KeyValuePair<string, KeyValuePair<SqlDbType, object>>[] keyParameterPairArr
                = new KeyValuePair<string, KeyValuePair<SqlDbType, object>>[1];
                keyParameterPairArr[0] = new KeyValuePair<string, KeyValuePair<SqlDbType, object>>("id",
                    new KeyValuePair<SqlDbType, object>(SqlDbType.Int, dt.Rows[i]["id"]));

                KeyValuePair<string, KeyValuePair<SqlDbType, object>>[] beforeSendUpdateParameterPairArr
                    = new KeyValuePair<string, KeyValuePair<SqlDbType, object>>[1];
                beforeSendUpdateParameterPairArr[0] = new KeyValuePair<string, KeyValuePair<SqlDbType, object>>("status",
                    new KeyValuePair<SqlDbType, object>(SqlDbType.Int, (object)1));

                DBHelper.UpdateData("reminder_message", beforeSendUpdateParameterPairArr, keyParameterPairArr);

                RepliedMessage msg = new RepliedMessage();
                msg.from = System.Configuration.ConfigurationSettings.AppSettings["ori_id"].Trim();
                msg.to = dt.Rows[i]["open_id"].ToString().Trim();
                msg.type = "text";
                msg.content = dt.Rows[i]["content"].ToString().Trim();

                int j = 0;

                //try
                //{
                    j = ServiceMessage.SendServiceMessage(new ServiceMessage(msg.jsonFormatData));
                //}
                //catch(Exception e)
                //{ 
                
                //}

                object result;

                if (j == 0)
                    result = (object)-1;
                else
                    result = (object)2;



                KeyValuePair<string, KeyValuePair<SqlDbType, object>>[] afterSendUpdateParameterPairArr
                    = new KeyValuePair<string, KeyValuePair<SqlDbType, object>>[2];
                afterSendUpdateParameterPairArr[0] = new KeyValuePair<string, KeyValuePair<SqlDbType, object>>("status",
                    new KeyValuePair<SqlDbType, object>(SqlDbType.Int, (object)result));
                afterSendUpdateParameterPairArr[1] = new KeyValuePair<string, KeyValuePair<SqlDbType, object>>("real_send_date",
                    new KeyValuePair<SqlDbType, object>(SqlDbType.DateTime, (object)DateTime.Now));

                DBHelper.UpdateData("reminder_message", afterSendUpdateParameterPairArr, keyParameterPairArr);

            }
            System.Threading.Thread.Sleep(60000);
        }
    }

}