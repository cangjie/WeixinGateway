<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string token = "29_77xb8UOcL_Ykveao_36pewanvKPmOmmtGKyRFmtRccCnYGN78yV2qiR68gsC6R3oURsDgjfqKUfY2smTeeJiM6YjIwEY8rW0c8AK-2ovMYJNquo9NOZlmN58plsXXEeJ2tYe5LaV4qZckNXuIMMjABALPP";
        token = Util.GetToken();
        string apiUrl = "http://api.weixin.qq.com/cgi-bin/material/batchget_material?access_token=" + token.Trim();
        string ret = Util.GetWebContent(apiUrl, "POST", "{\"type\":\"news\", \"offset\":0, \"count\":50}", "html/text");
        Response.Write(ret);
    }
</script>