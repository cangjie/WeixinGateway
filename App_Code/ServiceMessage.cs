using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Threading;
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
        for (; true; )
        {
            System.Threading.Thread.Sleep(60000);
        }
    }

}