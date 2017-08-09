<%@ Page Language="C#" %>
<%@ Import Namespace="System.IO" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string md5Key = "ABCDEF7768";
        string sn = Util.GetSafeRequestValue(Request, "sn", "Q11163910128");
        string requestTime = Util.GetSafeRequestValue(Request, "requesttime", "123456");
        string sign = Util.GetSHA1(sn.Trim() + requestTime.Trim() + md5Key);
        if (!sign.Equals(Util.GetSafeRequestValue(Request, "sign", "")))
        {
            Response.End();
        }
        Stream requestBodyStream = Request.InputStream ;
        StreamReader sr = new StreamReader(requestBodyStream);
        string jsonStr = sr.ReadToEnd();
        sr.Close();
        requestBodyStream.Close();

        //jsonStr = "{ \"id\": \"07457\",\"data\": \"return\",\"return\": [{\"id\": \"1001\",\"result\": \"0\"}]}";


        DBHelper.InsertData("finger_scaner_post",
            new string[,] { {"finger_scaner_id", "varchar", sn },
            { "post_message", "varchar", jsonStr.Trim()} });

        
        string returnStr = Util.GetSimpleJsonValueByKey(jsonStr, "data");

        if (returnStr.Trim().Equals("return"))
        {
            string replyId = Util.GetSimpleJsonValueByKey(jsonStr, "id");
            Dictionary<string, object>[] returnIdArr = Util.GetObjectArrayFromJsonByKey(jsonStr, "return");
            foreach (Dictionary<string, object> dic in returnIdArr)
            {
                DBHelper.UpdateData("finger_scaner_command",
                    new string[,] { { "reply", "int", "1" }, { "reply_time", "datetime", DateTime.Now.ToString() }, { "reply_id", "varchar", replyId } },
                    new string[,] { { "id", "int", dic["id"].ToString() }, { "finger_scaner_id", "varchar", sn.Trim()} }, Util.conStr);
            }
            Response.Write("{\"status\": 1, \"info\": \"ok\", \"data\":[\"" + replyId.Trim() + "\"]}");
        }
    }
</script>