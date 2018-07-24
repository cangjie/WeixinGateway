<%@ Page Language="C#" %>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string ret = Util.GetWebContent("https://s.taobao.com/search?q=桨板&commend=all&ssid=s5-e&search_type=item&sourceId=tb.index&spm=a21bo.2017.201856-taobao-item.1&ie=utf8&initiative_id=tbindexz_20170306");
        System.IO.File.AppendAllText(Server.MapPath("result.txt"), ret);
    }
</script>