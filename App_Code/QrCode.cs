﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.IO;
using System.Net;

/// <summary>
/// Summary description for QrCode
/// </summary>
public class QrCode
{
    public DataRow _fields;

	public QrCode()
	{
		
	}

    public QrCode(int sceneId)
    {
        DataTable dt = DBHelper.GetDataTable(" select * from qr_code_scene where [id] = " + sceneId.ToString(), Util.conStr.Trim());
        if (dt.Rows.Count > 0)
        {
            _fields = dt.Rows[0];
        }
    }

    public int ID
    {
        get
        {
            return int.Parse(_fields["id"].ToString().Trim());
        }
    }

    public string Path
    {
        get
        {
            return _fields["path"].ToString().Trim();
        }
        set
        {
            string[,] updateParameters = new string[,] {
                {"path", "varchar", value.Trim()},
                {"last_update_time", "DateTime", DateTime.Now.ToString()}};
            string[,] keyParameters = new string[,] { { "id", "int", ID.ToString() } };
            DBHelper.UpdateData("qr_code_scene", updateParameters, keyParameters, Util.conStr);

        }
    }

    public DateTime LastUpdateTime
    {
        get
        {
            try
            {
                return DateTime.Parse(_fields["last_update_time"].ToString().Trim());
            }
            catch
            {
                return DateTime.MinValue;
            }
        }
    }

    public static string GenerateNewQrCode(int sceneId, string qrRootPath)
    {
        string webPhysicalPath = System.Configuration.ConfigurationSettings.AppSettings["web_site_physical_path"].Trim();
        string qrCodePath = qrRootPath + "/" + DateTime.Now.Year.ToString() + DateTime.Now.Month.ToString().PadLeft(2, '0')
            + DateTime.Now.Day.ToString().PadLeft(2, '0');// + "/" + sceneId.ToString() + ".jpg";
        string qrCodePhysicalPath = webPhysicalPath + "\\" + qrCodePath.Replace("/", "\\").Trim();
        if (!Directory.Exists(qrCodePhysicalPath))
        {
            Directory.CreateDirectory(qrCodePhysicalPath.Trim());
        }
        string token = Util.GetToken();
        string ticketString = Util.GetSimpleJsonValueByKey(Util.GetWebContent("https://api.weixin.qq.com/cgi-bin/qrcode/create?access_token=" + token.Trim(), "POST",
            "{\"expire_seconds\": 604800, \"action_name\": \"QR_SCENE\", \"action_info\": {\"scene\": {\"scene_id\": "
            + sceneId.ToString() + " }}}", "text/html"), "ticket").Trim();
        HttpWebRequest req = (HttpWebRequest)WebRequest.Create("https://mp.weixin.qq.com/cgi-bin/showqrcode?ticket=" + ticketString.Trim());
        HttpWebResponse res = (HttpWebResponse)req.GetResponse();
        Stream s = res.GetResponseStream();
        int length = 0;
        byte[] buffer = new byte[1024 * 1024 * 10];
        for (int i = 0; i < buffer.Length; i++)
        {
            int currentByte = s.ReadByte();
            if (currentByte < 0)
            {
                length = i;
                break;
            }
            else
            {
                buffer[i] = (byte)currentByte;
            }
        }
        
        if (File.Exists(qrCodePhysicalPath+"\\"+sceneId.ToString()+".jpg"))
        {
            try
            {
                File.Delete(qrCodePhysicalPath+"\\"+sceneId.ToString()+".jpg");
            }
            catch
            {
            
            }
        }
        FileStream fs = File.Create(qrCodePhysicalPath + "\\" + sceneId.ToString() + ".jpg");
        for (int i = 0; i < length; i++)
        {
            fs.WriteByte(buffer[i]);
        }
        fs.Close();
        return qrCodePath + "/" + sceneId.ToString()+".jpg";
    }

    public static string GetQrCode(int sceneId, string qrRootPath)
    {
        string path = "";
        QrCode qrCode = new QrCode(sceneId);
        TimeSpan span = new TimeSpan(0, 0, 403200);
        if ((DateTime.Now - qrCode.LastUpdateTime) > span || !qrCode.Path.Trim().EndsWith(".jpg"))
        {
            path = GenerateNewQrCode(sceneId, qrRootPath);
            qrCode.Path = path;
        }
        else
        {
            path = qrCode.Path.Trim();
        }
        return path;
    }

    public static int CreateScene()
    {
        int i = DBHelper.InsertData("qr_code_scene",new string[,] {{"last_update_time", "DateTime", DateTime.Now.ToString()}});
        if (i > 0)
        {
            DataTable dt = DBHelper.GetDataTable(" select max(id) from qr_code_scene", Util.conStr);
            i = int.Parse(dt.Rows[0][0].ToString().Trim());
            dt.Dispose();
            return i;
        }
        else
        {
            return -1;
        }
    }
}