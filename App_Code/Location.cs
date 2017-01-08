using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
/// <summary>
/// Summary description for Location
/// </summary>
public class Location
{
    public double latitude = 0;
    public double longitude = 0;
    public DateTime locationDateTime;
    public long locationTimeStamp;

    public Location()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public static Location GetUserLatestLocation(string openId)
    {
        DataTable dt = DBHelper.GetDataTable(" select TOP 1 * from wxreceivemsg where wxreceivemsg_from = '" + openId.Trim().Replace("'","") 
            + "' and wxreceivemsg_type = 'event'  and wxreceivemsg_event = 'LOCATION' order by wxreceivemsg_crt desc  ");
        if (dt.Rows.Count == 0)
            return null;
        Location location = new Location();
        location.latitude = double.Parse(dt.Rows[0]["wxreceivemsg_locationy"].ToString());
        location.longitude = double.Parse(dt.Rows[0]["wxreceivemsg_locationx"].ToString());
        location.locationDateTime = DateTime.Parse(dt.Rows[0]["wxreceivemsg_crt"].ToString());
        location.locationTimeStamp = long.Parse(dt.Rows[0]["wxreceivemsg_time"].ToString());
        return location;
    }
}