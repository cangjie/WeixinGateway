<%@ Page Language="C#" %>
<%@ Import Namespace="System.Security.Cryptography" %>
<%@ Import Namespace="System.Text" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>
<%@ Import Namespace="System.Net" %>
<script runat="server">

    public string token = "jihuowangluo";
    public string validResult = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (valid())
        {
            //Response.Write(Request["echostr"].Trim());
            //Response.End();
            try
            {
                Stream s = Request.InputStream;
                XmlDocument xmlD = new XmlDocument();
                xmlD.Load(s);
                //File.AppendAllText(Server.MapPath("log/errr.txt"), xmlD.InnerXml.Trim() + "\r\n\r\n");
                try
                {
                    string msgId = SaveReceiveMessage(xmlD);
                    XmlDocument xmlRet = GetReplyMessage(msgId);
                    //File.AppendAllText(Server.MapPath("log/errr.txt"), xmlRet.InnerXml.Trim() + "\r\n\r\n");
                    Response.Write(xmlRet.InnerXml);
                    
                }
                catch(Exception err)
                {
                    string errMsg = DateTime.Now.ToString() + "\r\n";
                    errMsg = errMsg + err.ToString() + "\r\n";
                    errMsg = errMsg + xmlD.InnerXml.Trim();
                    //File.AppendAllText(Server.MapPath("log/err.txt"), errMsg.Trim() + "\r\n\r\n");
                }
            }
            catch
            {
                //File.AppendAllText(Server.MapPath("log/err.txt"),  "asdfasdfsawwww\r\n\r\n");
                Response.Write(Request["echostr"].Trim());
            }
        }
        else
        {
            //File.AppendAllText(Server.MapPath("log/err.txt"), "asdfasdfsawwww\r\n\r\n");
            Response.Write(validResult);
        }
    }

    public XmlDocument GetReplyMessage2(string MsgId)
    {
        string from = "";
        string to = "";
        string evnt = "";
        string evntKey = "";
        string openId = "";
        string type = "";
        string text = "";

        SqlConnection conn = new SqlConnection(System.Configuration.ConfigurationSettings.AppSettings["constr"].Trim());
        SqlCommand cmd = new SqlCommand(" select * from wxreceivemsg where wxreceivemsg_id = @id ", conn);
        cmd.Parameters.Add("@id", MsgId.Trim());
        conn.Open();
        SqlDataReader sqlDr = cmd.ExecuteReader();
        if (sqlDr.Read())
        {
            from = sqlDr["wxreceivemsg_to"].ToString().Trim();
            to = sqlDr["wxreceivemsg_from"].ToString().Trim();
            evnt = sqlDr["wxreceivemsg_event"].ToString().Trim();
            evntKey = sqlDr["wxreceivemsg_eventkey"].ToString().Trim();
            openId = sqlDr["wxreceivemsg_from"].ToString().Trim();
            type = sqlDr["wxreceivemsg_type"].ToString().Trim();
            text = sqlDr["wxreceivemsg_content"].ToString().Trim();
        }
        sqlDr.Close();
        cmd.CommandText = " update wxreceivemsg set wxreceivemsg_deal = 1 , wxreceivemsg_upd = getdate() where wxreceivemsg_id = @id  ";
        cmd.ExecuteNonQuery();
        conn.Close();
        
        
        
        
        return new XmlDocument();
    }

    public XmlDocument GetReplyMessage(string MsgId)
    {

        string from = "";
        string to = "";
        string evnt = "";
        string evntKey = "";
        string openId = "";
        string type = "";
        string text = "";
        
        SqlConnection conn = new SqlConnection(System.Configuration.ConfigurationSettings.AppSettings["constr"].Trim());
        SqlCommand cmd = new SqlCommand(" select * from wxreceivemsg where wxreceivemsg_id = @id ", conn);
        cmd.Parameters.Add("@id", MsgId.Trim());
        conn.Open();
        SqlDataReader sqlDr = cmd.ExecuteReader();
        if (sqlDr.Read())
        {
            from = sqlDr["wxreceivemsg_to"].ToString().Trim();
            to = sqlDr["wxreceivemsg_from"].ToString().Trim();
            evnt = sqlDr["wxreceivemsg_event"].ToString().Trim();
            evntKey = sqlDr["wxreceivemsg_eventkey"].ToString().Trim();
            openId = sqlDr["wxreceivemsg_from"].ToString().Trim();
            type = sqlDr["wxreceivemsg_type"].ToString().Trim();
            text = sqlDr["wxreceivemsg_content"].ToString().Trim();
        }
        sqlDr.Close();
        cmd.CommandText = " update wxreceivemsg set wxreceivemsg_deal = 1 , wxreceivemsg_upd = getdate() where wxreceivemsg_id = @id  ";
        cmd.ExecuteNonQuery();
        conn.Close();

        
        
        
        
        
        
        SqlCommand cmdIns = new SqlCommand();
        cmdIns.Connection = conn;
        string fieldClause = " wxreplymsg_rootid , wxreplymsg_from , wxreplymsg_to   ";
        string paramClause = " @rootid , @from , @to ";
        cmdIns.Parameters.Add("@rootid", MsgId.Trim());
        cmdIns.Parameters.Add("@from", from);
        cmdIns.Parameters.Add("@to", to);

        //bool willDone = false;

        int opType = 0;
        if (evnt.ToUpper().Trim().Equals("CLICK"))
        {
            opType = 1;
        }

        if (evnt.ToUpper().Trim().Equals("VIEW"))
        {
            opType = 2;
        }


        bool popGame = false;
        
        
        if (type.Trim().ToLower().Equals("text"))
        {
            if (text.Trim().IndexOf("超级大脑") >= 0 || text.Trim().IndexOf("游戏") >= 0 || text.Trim().IndexOf("赠书") >= 0)
            {
                //File.AppendAllText(Server.MapPath("log/login1.txt"), type + "  " + text + "\r\n");
                popGame = true;
            }
        }

        //switch
        switch (opType)
        { 
            case 1:
                
                string[] questionArr = GetHotQuestion();
                string subUrl = "";
                bool isWenDaMenuPostBack = false;
                if (evnt.Trim().ToUpper().Equals("CLICK"))
                {
                    switch((evntKey.Trim().ToUpper()))
                    {
                        case "VIDEO":
                            fieldClause = fieldClause + " , wxreplymsg_msgcount , wxreplymsg_msgtype , wxreplymsg_content  ";
                            paramClause = paramClause + ", @msgcount , @msgtype , @content ";
                            cmdIns.Parameters.Add("@msgcount", 5);
                            cmdIns.Parameters.Add("@msgtype", "news");
                            cmdIns.Parameters.Add("@content", Util.Get2014SummerCampVideoForWexinNews());
                            break;
                        case "IMAGE":
                            fieldClause = fieldClause + " , wxreplymsg_msgcount , wxreplymsg_msgtype , wxreplymsg_content  ";
                            paramClause = paramClause + ", @msgcount , @msgtype , @content ";
                            cmdIns.Parameters.Add("@msgcount", 4);
                            cmdIns.Parameters.Add("@msgtype", "news");
                            cmdIns.Parameters.Add("@content", Util.Get2014SummerCampImageForWexinNews());
                            break;
                        case "SUPPER_BRAIN":
                            isWenDaMenuPostBack = false;
                            fieldClause = fieldClause + " , wxreplymsg_msgcount , wxreplymsg_msgtype , wxreplymsg_content  ";
                            paramClause = paramClause + ", @msgcount , @msgtype , @content ";
                            cmdIns.Parameters.Add("@msgcount", 1);
                            cmdIns.Parameters.Add("@msgtype", "news");

                            string msgContent = "<item>"
                                + "<Title><![CDATA[点击进入开始游戏。]]></Title>"
                                + "<Description><![CDATA[玩《超级大脑》，赢取卢勤老师最新力作！只要你的分数达到150分以上，就有机会赢得一本《男孩梦》&《女孩梦》，还在等什么，快来参与吧！]]></Description>"
                                + "<PicUrl><![CDATA[http://gameapi.luqinwenda.com/image/start_all_2.jpg]]></PicUrl>"
                                + "<Url><![CDATA[http://gameapi.luqinwenda.com/seasonall/?openid=" + openId.Trim() + "]]></Url>"
                                + "</item>";
                            cmdIns.Parameters.Add("@content", msgContent);
                            break;
                        case "PINGTAI":
                            fieldClause = fieldClause + " , wxreplymsg_msgcount , wxreplymsg_msgtype , wxreplymsg_content  ";
                            paramClause = paramClause + ", @msgcount , @msgtype , @content ";
                            cmdIns.Parameters.Add("@msgcount", 1);
                            cmdIns.Parameters.Add("@msgtype", "news");
                            cmdIns.Parameters.Add("@content", Util.GetMenuWodeHit(openId, "http://weixin.luqinwenda.com/dingyue/images/1.jpg"
                                , 1, "卢勤问答平台", "这里是卢勤问答平台，你可以在这里浏览和评论他人的提问。"));
                            
                            break;
                        case "WENDA":
                            fieldClause = fieldClause + " , wxreplymsg_msgcount , wxreplymsg_msgtype , wxreplymsg_content  ";
                            paramClause = paramClause + ", @msgcount , @msgtype , @content ";
                            cmdIns.Parameters.Add("@msgcount", 1);
                            cmdIns.Parameters.Add("@msgtype", "news");
                            cmdIns.Parameters.Add("@content", Util.GetMenuWodeHit(openId, "http://weixin.luqinwenda.com/dingyue/images/2.jpg"
                                , 2, "卢老师的回答", "卢勤老师的回答都在这里，点击即可浏览。"));
                            
                            break;
                        case "TIWEN":
                            fieldClause = fieldClause + " , wxreplymsg_msgcount , wxreplymsg_msgtype , wxreplymsg_content  ";
                            paramClause = paramClause + ", @msgcount , @msgtype , @content ";
                            cmdIns.Parameters.Add("@msgcount", 1);
                            cmdIns.Parameters.Add("@msgtype", "news");
                            cmdIns.Parameters.Add("@content", Util.GetMenuWodeHit(openId, "http://weixin.luqinwenda.com/dingyue/images/3.jpg"
                                , 3, "快速提问", "点击进入快速提问，把你的问题提出来，卢勤老师帮你排忧解难。"));
                            
                            break;
                        case "WODE":
                            fieldClause = fieldClause + " , wxreplymsg_msgcount , wxreplymsg_msgtype , wxreplymsg_content  ";
                            paramClause = paramClause + ", @msgcount , @msgtype , @content ";
                            cmdIns.Parameters.Add("@msgcount", 1);
                            cmdIns.Parameters.Add("@msgtype", "news");
                            cmdIns.Parameters.Add("@content", Util.GetMenuWodeHit(openId, "http://weixin.luqinwenda.com/dingyue/images/4.jpg"
                                , 4, "还记得自己提过的问题吗？点击进入，即可查看提问历史。", "还记得自己提过的问题吗？点击进入，即可查看提问历史。"));
                            break;
                        case "BAOMING":
                            fieldClause = fieldClause + " , wxreplymsg_msgcount , wxreplymsg_msgtype , wxreplymsg_content  ";
                            paramClause = paramClause + ", @msgcount , @msgtype , @content ";
                            cmdIns.Parameters.Add("@msgcount", 2);
                            cmdIns.Parameters.Add("@msgtype", "news");
                            cmdIns.Parameters.Add("@content", Util.GetMenuBaomingHit());
                            
                            break;
                        default:
                            isWenDaMenuPostBack = true;
                            break;
                    }
                    
                    /*
                    if (evntKey.Trim().ToUpper().Equals("ASK"))
                    {
                        questionArr = GetNewQuestion();
                        subUrl = "http://www.luqinwenda.com/index.php?app=public&mod=Mobile&act=ask";
                    }
                    if (evntKey.Trim().ToUpper().Equals("ANSWER"))
                    {
                        subUrl = "http://www.luqinwenda.com/index.php?app=public&mod=Mobile&act=answerlist&uid=1901";
                    }
                    if (evntKey.Trim().ToUpper().Equals("MYQA"))
                    {
                        subUrl = "http://www.luqinwenda.com/index.php?app=public&mod=Mobile&act=all";
                    }
                    if (evntKey.Trim().ToUpper().Equals("FRIEND"))
                    {
                        questionArr = GetNewQuestion();
                        subUrl = "http://www.luqinwenda.com/index.php?app=public&mod=Mobile&act=topiclist";
                    }
                    if (evntKey.Trim().ToLower().Equals("supper_brain"))
                    {
                        subUrl = "http://gameapi.luqinwenda.com/seasonall/";
                        isWenDaMenuPostBack = false;
                    }*/
                    
                }

                if (isWenDaMenuPostBack)
                {

                    fieldClause = fieldClause + " , wxreplymsg_msgcount , wxreplymsg_msgtype , wxreplymsg_content  ";
                    paramClause = paramClause + ", @msgcount , @msgtype , @content ";
                    cmdIns.Parameters.Add("@msgcount", questionArr.Length);
                    cmdIns.Parameters.Add("@msgtype", "news");
                    string ts = GetTimeStamp();

                    string url = "http://www.luqinwenda.com/index.php?app=public&mod=LandingPage&act=Landing&openid="
                        + to + "&time=" + ts + "&url=" + Server.UrlEncode(subUrl) + "&code="
                        + GetMd5(to + ts + System.Configuration.ConfigurationSettings.AppSettings["md5key"].Trim());
                    if (!CheckIfUserBind(openId))
                    {
                        url = "http://www.luqinwenda.com/index.php?app=public&mod=Register&act=Homemobile&openid=" + openId + "&source=3";
                    }


                    string msgContent = "<item>"
                        + "<Title><![CDATA[1" + questionArr[0] + "]]></Title>"
                        + "<Description><![CDATA[]]></Description>"
                        + "<PicUrl><![CDATA[http://img.luqinwenda.com/img.jpg]]></PicUrl>"
                        + "<Url><![CDATA[" + url + "]]></Url>"
                        + "</item>";

                    for (int k = 1; k < questionArr.Length; k++)
                    {
                        msgContent = msgContent + "<item>"
                            + "<Title><![CDATA[" + questionArr[k] + "]]></Title>"
                            + "<Description><![CDATA[]]></Description>"
                            + "<PicUrl><![CDATA[http://img.luqinwenda.com/head.jpg]]></PicUrl>"
                            + "<Url><![CDATA[" + url + "]]></Url>"
                            + "</item>";
                    }


                    //cmdIns.Parameters.Add("@content", msgContent);
                    cmdIns.Parameters.Add("@content", "");
                }
                else
                {
                    
                }
                break;
            case 2:

                if (evntKey.ToLower().StartsWith("http://www.luqinwenda.com/index.php?app=public&mod=landingpage"))
                {
                    DealLandingRequest(openId);
                }
  
                fieldClause = fieldClause + " , wxreplymsg_msgcount , wxreplymsg_msgtype , wxreplymsg_content  ";
                paramClause = paramClause + ", @msgcount , @msgtype , @content ";
                cmdIns.Parameters.Add("@msgcount", 1);
                cmdIns.Parameters.Add("@msgtype", "text");
                cmdIns.Parameters.Add("@content", "");
                break;
            default:
                if (!popGame)
                {
                    switch (text.Trim())
                    { 
                        case "视频":
                            fieldClause = fieldClause + " , wxreplymsg_msgcount , wxreplymsg_msgtype , wxreplymsg_content  ";
                            paramClause = paramClause + ", @msgcount , @msgtype , @content ";
                            cmdIns.Parameters.Add("@msgcount", 5);
                            cmdIns.Parameters.Add("@msgtype", "news");
                            cmdIns.Parameters.Add("@content", Util.Get2014SummerCampVideoForWexinNews());
                            break;
                        case "图片":
                            fieldClause = fieldClause + " , wxreplymsg_msgcount , wxreplymsg_msgtype , wxreplymsg_content  ";
                            paramClause = paramClause + ", @msgcount , @msgtype , @content ";
                            cmdIns.Parameters.Add("@msgcount", 4);
                            cmdIns.Parameters.Add("@msgtype", "news");
                            cmdIns.Parameters.Add("@content", Util.Get2014SummerCampImageForWexinNews());
                            break;    
                        default:
                            fieldClause = fieldClause + " , wxreplymsg_msgcount , wxreplymsg_msgtype , wxreplymsg_content  ";
                            paramClause = paramClause + ", @msgcount , @msgtype , @content ";
                            cmdIns.Parameters.Add("@msgcount", 1);
                            cmdIns.Parameters.Add("@msgtype", "text");
                            cmdIns.Parameters.Add("@content", "");
                            break;
                            
                    }
                    
                }
                break;    
        }


        if (popGame)
        {
            fieldClause = fieldClause + " , wxreplymsg_msgcount , wxreplymsg_msgtype , wxreplymsg_content  ";
            paramClause = paramClause + ", @msgcount , @msgtype , @content ";
            cmdIns.Parameters.Add("@msgcount", 1);
            cmdIns.Parameters.Add("@msgtype", "news");

            string msgContent = "<item>"
                + "<Title><![CDATA[点击进入开始游戏。]]></Title>"
                + "<Description><![CDATA[玩《超级大脑》，赢取卢勤老师最新力作！只要你的分数达到150分以上，就有机会赢得一本《男孩梦》&《女孩梦》，还在等什么，快来参与吧！]]></Description>"
                + "<PicUrl><![CDATA[http://gameapi.luqinwenda.com/image/start_all_2.jpg]]></PicUrl>"
                + "<Url><![CDATA[http://gameapi.luqinwenda.com/seasonall/?openid=" + openId.Trim() + "]]></Url>"
                + "</item>";
            cmdIns.Parameters.Add("@content", msgContent);
        }
        
        
        //fix sql clause
        cmdIns.CommandText = " insert into wxreplymsg (" + fieldClause + " ) values ( " + paramClause + " ) ";
        
        
        
        conn.Open();
        int i = 0;
        try
        {
            i = cmdIns.ExecuteNonQuery();
        }
        catch(Exception err)
        {
            string errMsg = DateTime.Now.ToString() + "\r\n";
            errMsg = errMsg + err.ToString() + "\r\n";
            File.AppendAllText(Server.MapPath("log/err.txt"), err.ToString().Trim() + "\r\n\r\n");
        }
        int newId = 0;
        
        if (i == 1)
        {
            cmd.CommandText = " update wxreceivemsg set wxreceivemsg_isreply = 1 , wxreceivemsg_upd = getdate() where wxreceivemsg_id = @id ";
            cmd.ExecuteNonQuery();
            cmd.CommandText = " select top 1 wxreplymsg_id from wxreplymsg where wxreplymsg_rootid = @id and wxreplymsg_isservice = 0 order by wxreplymsg_id desc ";
            sqlDr = cmd.ExecuteReader();
            if (sqlDr.Read())
            {
                newId = sqlDr.GetInt32(0);
            }
            sqlDr.Close();
        }
        conn.Close();
        conn.Dispose();

        //File.AppendAllText(Server.MapPath("log/newId.txt"), newId.ToString() + "\r\n");
        
        
        if (newId == 0)
        {
            throw new Exception("Reply message is valid.");
        }
        else
        {
            return Util.CreateReplyDocument(newId);
        }
    }

    public void DealLandingRequest(string openId)
    {
        //File.AppendAllText(Server.MapPath("log/login.txt"), DateTime.Now.ToString() + "  aaa\r\n");
        DateTime now = DateTime.Now;
        now = now.AddMinutes(-5);
        SqlDataAdapter da = new SqlDataAdapter(" select * from WxLoginRequest where WxLoginRequest_deal = 0 and wxloginrequest_crt > '" + now.ToString() + "' ",
            System.Configuration.ConfigurationSettings.AppSettings["constr"].Trim());
        DataTable dt = new DataTable();
        if (dt.Rows.Count >= 0)
        {
            ////File.AppendAllText(Server.MapPath("log/login.txt"), DateTime.Now.ToString() + "  bbb\r\n");
            SqlConnection conn = new SqlConnection(System.Configuration.ConfigurationSettings.AppSettings["constr"].Trim());
            SqlCommand cmd = new SqlCommand(" insert into WxLoginRequest (WxLoginRequest_openid ) values ('" + openId.Replace("'", "") + "' ) ", conn);
            conn.Open();
            int i = cmd.ExecuteNonQuery();
            //File.AppendAllText(Server.MapPath("log/login.txt"), DateTime.Now.ToString() + "  " + i.ToString().Trim() + "\r\n");
            conn.Close();
            cmd.Dispose();
            conn.Dispose();
        }
        dt.Dispose();
        da.Dispose();
    }
    
    public string SaveReceiveMessage(XmlDocument xmlD)
    {
        
        string to = xmlD.SelectSingleNode("//xml/ToUserName").InnerText.Trim();
        string from = xmlD.SelectSingleNode("//xml/FromUserName").InnerText.Trim();
        string createTime = xmlD.SelectSingleNode("//xml/CreateTime").InnerText.Trim();
        string msgType = xmlD.SelectSingleNode("//xml/MsgType").InnerText.Trim();
        string msgId = "";
        if (msgType == "event")
        {
            DateTime nowDate = DateTime.Now;
            msgId = "event_" + nowDate.Year.ToString() + nowDate.Month.ToString().PadLeft(2, '0') + nowDate.Day.ToString().PadLeft(2, '0')
                + nowDate.Hour.ToString().PadLeft(2, '0') + nowDate.Minute.ToString().PadLeft(2, '0') + nowDate.Second.ToString().PadLeft(2, '0')
                + nowDate.Millisecond.ToString().PadLeft(3, '0');
        }
        else
        {
            
            msgId = xmlD.SelectSingleNode("//xml/MsgId").InnerText.Trim();
            //File.AppendAllText(Server.MapPath("log/err.txt"), msgId + "\r\n\r\n");
        }
        SqlCommand cmd = new SqlCommand();
        string insertClause = " wxreceivemsg_id , wxreceivemsg_to , wxreceivemsg_from , wxreceivemsg_time , wxreceivemsg_type ";
        string valuesClause = " @id , @to , @from , @time , @type ";
        cmd.Parameters.Add("@id",SqlDbType.VarChar);
        cmd.Parameters["@id"].Value = msgId.Trim();
        cmd.Parameters.Add("@to", SqlDbType.VarChar);
        cmd.Parameters["@to"].Value = to.Trim();
        cmd.Parameters.Add("@from", SqlDbType.VarChar);
        cmd.Parameters["@from"].Value = from.Trim();
        cmd.Parameters.Add("@time", SqlDbType.VarChar);
        cmd.Parameters["@time"].Value = createTime.Trim();
        cmd.Parameters.Add("@type", SqlDbType.VarChar);
        cmd.Parameters["@type"].Value = msgType.Trim();

        switch (msgType)
        { 
            case "text":
                insertClause = insertClause + " , wxreceivemsg_content ";
                valuesClause = valuesClause + " , @content ";
                cmd.Parameters.Add("@content", SqlDbType.VarChar);
                cmd.Parameters["@content"].Value = xmlD.SelectSingleNode("//xml/Content").InnerText.Trim();
                
                break;
            case "event":
                insertClause = insertClause + " , wxreceivemsg_event ";
                valuesClause = valuesClause + " , @event ";
                cmd.Parameters.Add("@event", SqlDbType.VarChar);
                cmd.Parameters["@event"].Value = xmlD.SelectSingleNode("//xml/Event").InnerText.Trim();

                try
                {
                    XmlNode keyNode = xmlD.SelectSingleNode("//xml/EventKey");
                    if (keyNode != null)
                    {
                        insertClause = insertClause + " , wxreceivemsg_eventkey ";
                        valuesClause = valuesClause + " , @eventkey ";
                        cmd.Parameters.Add("@eventkey", SqlDbType.VarChar);
                        cmd.Parameters["@eventkey"].Value = keyNode.InnerText.Trim();
                    }
                }
                catch
                { 
                
                }
                
                
                if (xmlD.SelectSingleNode("//xml/Event").InnerText.Trim() == "LOCATION")
                {
                    insertClause = insertClause + " , wxreceivemsg_locationx ";
                    valuesClause = valuesClause + " , @locationx ";
                    cmd.Parameters.Add("@locationx", SqlDbType.VarChar);
                    cmd.Parameters["@locationx"].Value = xmlD.SelectSingleNode("//xml/Latitude").InnerText.Trim();


                    insertClause = insertClause + " , wxreceivemsg_locationy ";
                    valuesClause = valuesClause + " , @locationy ";
                    cmd.Parameters.Add("@locationy", SqlDbType.VarChar);
                    cmd.Parameters["@locationy"].Value = xmlD.SelectSingleNode("//xml/Longitude").InnerText.Trim();

                    insertClause = insertClause + " , wxreceivemsg_scale ";
                    valuesClause = valuesClause + " , @scale ";
                    cmd.Parameters.Add("@scale", SqlDbType.VarChar);
                    cmd.Parameters["@scale"].Value = xmlD.SelectSingleNode("//xml/Precision").InnerText.Trim();
                
                    
                    
                }
                
                break;
            case "image":
                insertClause = insertClause + " , wxreceivemsg_picurl ";
                valuesClause = valuesClause + " , @picurl ";
                cmd.Parameters.Add("@picurl", SqlDbType.VarChar);
                cmd.Parameters["@picurl"].Value = xmlD.SelectSingleNode("//xml/PicUrl").InnerText.Trim();
                
                insertClause = insertClause + " , wxreceivemsg_mediaid ";
                valuesClause = valuesClause + " , @mediaid ";
                cmd.Parameters.Add("@mediaid", SqlDbType.VarChar);
                cmd.Parameters["@mediaid"].Value = xmlD.SelectSingleNode("//xml/MediaId").InnerText.Trim();
                break;
            case "voice":
                insertClause = insertClause + " , wxreceivemsg_format ";
                valuesClause = valuesClause + " , @format ";
                cmd.Parameters.Add("@format", SqlDbType.VarChar);
                cmd.Parameters["@format"].Value = xmlD.SelectSingleNode("//xml/Format").InnerText.Trim();
                
                insertClause = insertClause + " , wxreceivemsg_mediaid ";
                valuesClause = valuesClause + " , @mediaid ";
                cmd.Parameters.Add("@mediaid", SqlDbType.VarChar);
                cmd.Parameters["@mediaid"].Value = xmlD.SelectSingleNode("//xml/MediaId").InnerText.Trim();

                try
                {
                    insertClause = insertClause + " , wxreceivemsg_recognition ";
                    valuesClause = valuesClause + " , @recognition ";
                    cmd.Parameters.Add("@recognition", SqlDbType.VarChar);
                    cmd.Parameters["@recognition"].Value = xmlD.SelectSingleNode("//xml/Recognition").InnerText.Trim();

                }
                catch
                { 
                
                }
                
                
                break;
            case "video":
                insertClause = insertClause + " , wxreceivemsg_thumbmediaid ";
                valuesClause = valuesClause + " , @thumbmediaid ";
                cmd.Parameters.Add("@thumbmediaid", SqlDbType.VarChar);
                cmd.Parameters["@thumbmediaid"].Value = xmlD.SelectSingleNode("//xml/ThumbMediaId").InnerText.Trim();
                
                insertClause = insertClause + " , wxreceivemsg_mediaid ";
                valuesClause = valuesClause + " , @mediaid ";
                cmd.Parameters.Add("@mediaid", SqlDbType.VarChar);
                cmd.Parameters["@mediaid"].Value = xmlD.SelectSingleNode("//xml/MediaId").InnerText.Trim();
                break;
            case "location":
                insertClause = insertClause + " , wxreceivemsg_locationx ";
                valuesClause = valuesClause + " , @locationx ";
                cmd.Parameters.Add("@locationx", SqlDbType.VarChar);
                cmd.Parameters["@locationx"].Value = xmlD.SelectSingleNode("//xml/Location_X").InnerText.Trim();
                
                
                insertClause = insertClause + " , wxreceivemsg_locationy ";
                valuesClause = valuesClause + " , @locationy ";
                cmd.Parameters.Add("@locationy", SqlDbType.VarChar);
                cmd.Parameters["@locationy"].Value = xmlD.SelectSingleNode("//xml/Location_Y").InnerText.Trim();
                
                
                
                insertClause = insertClause + " , wxreceivemsg_scale ";
                valuesClause = valuesClause + " , @scale ";
                cmd.Parameters.Add("@scale", SqlDbType.VarChar);
                cmd.Parameters["@scale"].Value = xmlD.SelectSingleNode("//xml/Scale").InnerText.Trim();
                
                insertClause = insertClause + " , wxreceivemsg_label ";
                valuesClause = valuesClause + " , @label ";
                cmd.Parameters.Add("@label", SqlDbType.VarChar);
                cmd.Parameters["@label"].Value = xmlD.SelectSingleNode("//xml/Label").InnerText.Trim();
                
                break;
            case "link":

                insertClause = insertClause + " , wxreceivemsg_title ";
                valuesClause = valuesClause + " , @title ";
                cmd.Parameters.Add("@title", SqlDbType.VarChar);
                cmd.Parameters["@title"].Value = xmlD.SelectSingleNode("//xml/Title").InnerText.Trim();
                insertClause = insertClause + " , wxreceivemsg_description ";
                valuesClause = valuesClause + " , @description ";
                cmd.Parameters.Add("@description", SqlDbType.VarChar);
                cmd.Parameters["@description"].Value = xmlD.SelectSingleNode("//xml/Description").InnerText.Trim();
                insertClause = insertClause + " , wxreceivemsg_url ";
                valuesClause = valuesClause + " , @url ";
                cmd.Parameters.Add("@url", SqlDbType.VarChar);
                cmd.Parameters["@url"].Value = xmlD.SelectSingleNode("//xml/Url").InnerText.Trim();
                break;
            default:
                break;
        }

        SqlConnection conn = new SqlConnection(System.Configuration.ConfigurationSettings.AppSettings["constr"].Trim());
        cmd.Connection = conn;
        cmd.CommandText = " insert into wxreceivemsg ( " + insertClause + " )  values ( " + valuesClause + " )  " ;
        conn.Open();
        int i = cmd.ExecuteNonQuery();
        //File.AppendAllText(Server.MapPath("log/err.txt"),xmlD.InnerXml.Trim() + "\r\n\r\n");
        if (i == 0)
        {
            throw new Exception("Insert failed, the SQL clause is: " + cmd.CommandText.Trim());
        }
        conn.Close();
        cmd.Parameters.Clear();
        cmd.Dispose();
        conn.Dispose();
        return msgId;
    }
    
    public bool valid()
    {
        string sign = Request["signature"].Trim();
        string time = Request["timestamp"].Trim();
        string nonce = Request["nonce"].Trim();
        string[] strArr = new string[3];
        strArr[0] = token;
        strArr[1] = time;
        strArr[2] = nonce;
        Array.Sort(strArr);
        string arrStr = String.Join("", strArr);
        SHA1 sha = SHA1.Create();
        ASCIIEncoding enc = new ASCIIEncoding();
        byte[] bArr = enc.GetBytes(arrStr);
        bArr = sha.ComputeHash(bArr);
        validResult = "";
        for (int i = 0; i < bArr.Length; i++)
        {
            validResult = validResult + bArr[i].ToString("x").PadLeft(2,'0');
        }
        if (validResult == sign)
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    public static string GetTimeStamp()
    {
        TimeSpan ts = DateTime.UtcNow - new DateTime(1970, 1, 1, 0, 0, 0, 0);
        return Convert.ToInt64(ts.TotalSeconds).ToString();
    }

    public static string GetMd5(string str)
    {
        System.Security.Cryptography.MD5 md5 = System.Security.Cryptography.MD5.Create();
        byte[] bArr = md5.ComputeHash(Encoding.UTF8.GetBytes(str));
        string ret = "";
        foreach (byte b in bArr)
        {
            ret = ret + b.ToString("x").PadLeft(2, '0');
        }
        return ret;
    }


    public static bool CheckIfUserBind(string openId)
    {
        HttpWebRequest req = (HttpWebRequest)WebRequest.Create("http://www.luqinwenda.com/index.php?app=public&mod=Api&act=getUserOpenID&openID=" + openId);
        HttpWebResponse res = (HttpWebResponse)req.GetResponse();
        string str = (new StreamReader(res.GetResponseStream())).ReadToEnd();
        res.Close();
        req.Abort();
      //if (str.Trim().Equals("false"))
        if (str.Trim().Equals("﻿false"))
            return false;
        else
            return true;
    }


    public string[] GetHotQuestion()
    {
        string jsonStr = GetJsonFromUrl("http://www.luqinwenda.com/index.php?app=public&mod=api&act=getHotQuestion");
        return GetQuestions(jsonStr);
    }


    public string[] GetNewQuestion()
    {
        string jsonStr = GetJsonFromUrl("http://www.luqinwenda.com/index.php?app=public&mod=api&act=getNewQuestion");
        return GetQuestions(jsonStr);
    }

    public string[] GetQuestions(string jsonStr)
    {
        //File.AppendAllText(Server.MapPath("log/json.txt"), jsonStr + "\r\n");
        JavaScriptSerializer serializer = new JavaScriptSerializer();
        Dictionary<string, object> json = (Dictionary<string, object>)serializer.DeserializeObject(jsonStr);
        object v;
        json.TryGetValue("data", out v);
        object[] vArr = (object[])v;
        string[] qArr = new string[vArr.Length];
        for (int i = 0; i < qArr.Length; i++)
        {
            object o = vArr[i];
            Dictionary<string, object> d = (Dictionary<string, object>)o;
            qArr[i] = d["body"].ToString().Trim();
        }
        return qArr;
    }



    public string GetJsonFromUrl(string url)
    {
        string s = GetContentFromUrl(url);
        /*
        byte[] bArr = Encoding.UTF8.GetBytes(s);
        byte[] bArrNew = new byte[bArr.Length - 3];
        for (int i = 0; i < bArrNew.Length; i++)
        {
            bArrNew[i] = bArr[i + 3];
        }
        s = Encoding.UTF8.GetString(bArrNew);
         */ 
        return s;

    }

    public string GetContentFromUrl(string url)
    {
        HttpWebRequest req = (HttpWebRequest)WebRequest.Create(url);
        HttpWebResponse res = (HttpWebResponse)req.GetResponse();
        string s = (new StreamReader(res.GetResponseStream())).ReadToEnd();
        res.Close();
        req.Abort();
        return s;
    }
    
</script>