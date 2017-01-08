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

    public static string FindInResort(string openId)
    {
        string resort = "";
        double nanShanlatNorth = 40.339170;
        double nanShanlatSourth = 40.329611;
        double nanShanlonEast = 116.860606;
        double nanShanlonWest = 116.851649;
        double baYilatNorth = 39.874130;
        double baYilatSourth = 39.866812;
        double baYilonEast = 116.150999;
        double baYilonWest = 116.141659;
        Location location = Location.GetUserLatestLocation(openId);
        if (location != null)
        {
            long currentTimeStamp = long.Parse(Util.GetTimeStamp());
            if (currentTimeStamp - location.locationTimeStamp <= 3600)
            {
                if (location.latitude <= nanShanlatNorth && location.latitude >= nanShanlatSourth
                    && location.longitude >= nanShanlonWest && location.longitude <= nanShanlonEast)
                {
                    resort = "南山";
                }
                if (location.latitude <= baYilatNorth && location.latitude >= baYilatSourth
                    && location.longitude >= baYilonWest && location.longitude <= baYilonEast)
                {
                    resort = "八易";
                }

            }
            else
            {
                resort = "定位超时";
            }
        }
        else
        {
            resort = "请打开微信公众号定位。";
        }
        return resort;
    }
}