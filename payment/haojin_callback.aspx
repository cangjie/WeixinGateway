﻿<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        Response.Write(Request.Form.ToString());
    }
</script>