using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

/// <summary>
/// Summary description for Device
/// </summary>
public class Device
{
    public int deviceId = 0;

    public DataRow _lastScan;

    public Device(int id)
    {
        //
        // TODO: Add constructor logic here
        //
        deviceId = id;
        DataTable dt = DBHelper.GetDataTable(" select  top 1 * from device_scan_list  where device_id = " + id.ToString() + " order by timestamp desc ");
        if (dt.Rows.Count == 0)
        {
            AddNewScanRecord(deviceId, Util.GetTimeStamp(), "oZBHkjjDXmAUjCa5m_q03d1Rj-z8");
            dt = DBHelper.GetDataTable(" select  top 1 * from device_scan_list  where device_id = " + id.ToString() + " order by timestamp desc ");
            _lastScan = dt.Rows[0];
        }
        else
        {
            _lastScan = dt.Rows[0];
        }
    }

    public static void AddNewScanRecord(int deviceId, string timeStamp, string openId)
    {
        WeixinUser user = new WeixinUser(openId.Trim());
        string[,] insertParam = { { "timestamp", "varchar", timeStamp }, { "device_id", "int", deviceId.ToString() },
            {"open_id", "varchar", openId.Trim() }, {"nick", "varchar", user.Nick }, 
            {"head_image", "varchar", user.HeadImage.Trim() }, {"qrcode_url", "varchar", "" } };

    }

}