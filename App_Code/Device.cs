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

    public DataRow _fields;



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

        dt = DBHelper.GetDataTable(" select * from device where [id] = " + id.ToString());
        _fields = dt.Rows[0];
    }

    public static void AddNewScanRecord(int deviceId, string timeStamp, string openId)
    {
        WeixinUser user = new WeixinUser(openId.Trim());
        string[,] insertParam = { { "timestamp", "varchar", timeStamp }, { "device_id", "int", deviceId.ToString() },
            {"open_id", "varchar", openId.Trim() }, {"nick", "varchar", user.Nick }, 
            {"head_image", "varchar", user.HeadImage.Trim() }, {"qrcode_url", "varchar", "http://weixin.snowmeet.com/show_qrcode.aspx?sceneid=" + timeStamp.Trim() } };
        DBHelper.InsertData("device_scan_list", insertParam);

    }

    public static Device ScanDeviceQrCode(string timeStamp)
    {
        DataTable dt = DBHelper.GetDataTable(" select * from device_scan_list where timestamp = '" + timeStamp.Trim() + "' ");
        if (dt.Rows.Count > 0)
        {
            Device device = new Device(int.Parse(dt.Rows[0]["device_id"].ToString().Trim()));
            if (device._lastScan["timestamp"].ToString().Equals(timeStamp))
            {
                return device;
            }
            else
            {
                return null;
            }
        }
        else
        {
            return null;
        }
    }

    public static bool FirstTimeToUse(string openId, int deviceId)
    {
        DataTable dt = DBHelper.GetDataTable(" select * from device_scan_list where open_id = '" + openId.Trim() + "' ");
        if (dt.Rows.Count == 0)
        {
            Device device = new Device(deviceId);
            int needPoint = int.Parse(device._fields["need_point"].ToString());
            WeixinUser user = new WeixinUser(openId);
            if (user.Points < needPoint)
                Point.AddNew(openId, int.Parse(device._fields["need_point"].ToString()), DateTime.Now, "第一次试用" + device._fields["name"].ToString());
            return true;
        }
        else
            return false;
    }

}