﻿<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        Response.Write("{ \"timestamp\": " + Util.GetTimeStamp().ToString() + ", \"local_time\": \"" + DateTime.Now.ToString() + "\", \"utc_time\" :\"" + DateTime.UtcNow.ToString() + "\" }");
    }
</script>