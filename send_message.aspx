<%@ Page Language="C#" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //Stream s = Request.InputStream;
            //StreamReader sr = new StreamReader(s);
            //string jsonStr = sr.ReadToEnd();
            //jsonStr = "{\"fromuser\":\"gh_7c0c5cc0906a\",\"touser\":\"oqrMvt8K6cwKt5T1yAavEylbJaRs\",\"msgtype\":\"news\",\"news\":{\"articles\": [{\"title\":\"Happy Day\",\"description\":\"Is Really A Happy Day\",\"url\":\"http://www.luqinwenda.com\",\"picurl\":\"http://www.nanshanski.com/images/ppt1.jpg\"},{\"title\":\"Happy Day2\",\"description\":\"Is Really A Happy Day2\",\"url\":\"http://www.nanshanski.com\",\"picurl\":\"http://www.nanshanski.com/images/ppt2.jpg\"}]}}";
            //jsonStr = "{\"fromuser\":\"gh_7c0c5cc0906a\",\"touser\":\"oqrMvt6yRAWFu3DmhGe4Td0nKZRo\",\"msgtype\":\"text\",\"text\":{\"content\":\"亲爱的用户：你好，有人在卢勤问答平台上回答了你提出的问题“asdfasdfasdf”，快去看看吧！\"}}";
            
            //ServiceMessage serviceMessage = new ServiceMessage(jsonStr);
            //int i = ServiceMessage.SendServiceMessage(serviceMessage);
            //Response.Write("{\"status\":0,\"message_id\":" + i.ToString() + "}");

            RepliedMessage msg = new RepliedMessage();
            msg.from = System.Configuration.ConfigurationSettings.AppSettings["ori_id"].Trim();
            msg.to = "ocTHCuPdHRCPZrcJb2qWOE_EYjeI";
            msg.type = "text";
            msg.content = "测试";
            //msg.isService = true;
            //int i = RepliedMessage.AddRepliedMessage(msg);
            int j = ServiceMessage.SendServiceMessage(new ServiceMessage(msg.jsonFormatData));
            Response.End();
        }
    }
</script>