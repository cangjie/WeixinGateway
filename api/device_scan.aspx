<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        int deviceId = int.Parse(Util.GetSafeRequestValue(Request, "deviceid", "2"));
        Device device = new Device(deviceId);
        Response.Write("{\"device_id\": \"" + deviceId.ToString() + "\" , \"nick\": \"" + device._lastScan["nick"].ToString().Trim()
            + "\", \"head_image\":\"" + device._lastScan["head_image"].ToString()  + "\", \"scan_time\":\""
            + device._lastScan["timestamp"].ToString() + "\", \"next_qrcode\":\"" + device._lastScan["qrcode_url"].ToString().Trim() + "\", " 
            + "\"open_id\": \"" + device._lastScan["open_id"].ToString().Trim() + "\"  }");
        }
</script>