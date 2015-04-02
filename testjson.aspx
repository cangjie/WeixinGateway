<%@ Page Language="C#" %>
<%@ Import Namespace="System.Runtime.Serialization" %>
<%@ Import Namespace="System.Runtime.Serialization.Json" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>
<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {


            Response.Write(Server.UrlEncode("http://www.luqinwenda.com/index.php?app=public&mod=Mobile&act=ask"));
            Response.Write(Server.UrlEncode("http://www.luqinwenda.com/index.php?app=public&mod=Mobile&act=answerlist&uid=1901"));
            Response.Write(Server.UrlEncode("http://www.luqinwenda.com/index.php?app=public&mod=Mobile&act=all"));
            Response.End();
            GetHotQuestion();
            
            HttpWebRequest req = (HttpWebRequest)WebRequest.Create("http://www.luqinwenda.com/index.php?app=public&mod=api&act=getHotQuestion");
            
            HttpWebResponse res = (HttpWebResponse)req.GetResponse();
            Stream stream = res.GetResponseStream();

            byte[] bArr = new byte[1024 * 1024 * 100];
            int count = 0;
            for (int i = 0; i < bArr.Length; i++)
            {
                try
                {
                    int j = stream.ReadByte();
                    if (j == -1)
                    {
                        count = i;
                        break;
                    }
                    else
                    {
                        bArr[i] = (byte)j;
                    }
                }
                catch
                {
                    break;
                }
            }
            byte[] bArrNew = new byte[count];
            for (int i = 0; i < count; i++)
            {
                bArrNew[i] = bArr[i];
            }
            stream.Close();
            res.Close();
            
            req.Abort();

            req = (HttpWebRequest)WebRequest.Create("http://www.luqinwenda.com/index.php?app=public&mod=api&act=getHotQuestion");
            res = (HttpWebResponse)req.GetResponse();
            StreamReader sr = new StreamReader(res.GetResponseStream());
            string s = sr.ReadToEnd().Trim();
            sr.Close();
            res.Close();
            req.Abort();

            string t = "{\"data\":[{\"feed_id\":\"442\",\"body\":\"“不要让孩子输在起跑线上!”这句话到底对不对？\",\"description\":\"竞争日益激烈，整个社会都弥漫着一种怕孩子输在起跑线上的焦虑，上各种培训班的孩子，已经从中小学生，蔓延到学龄前儿童。可是，到底什么才是起跑线？小区里别人家的小孩，6岁就能流利的用英语讲故事，7岁就能钢琴就过了10级。我的孩子也7岁了，从小我就没给他上什么早教、兴趣班，大部分时间都是玩了，到现在基本上也就是跟上学习的课程，其他的一点过人之处都没有。看着别的孩子英文讲的比中文都好，我也羡慕呀。我孩子上的是离我家最近的一所小学，恰巧是本地数一数二的学校，根据户口，孩子进了这所学校。我同事的孩子跟女儿同班，上学前人家就认识2000多个字，学英语光学费书费就已经花了7000多元。一年级放假前老师叫我到学校，让我多管管孩子，说女儿连上课的意识都没有，上着课能玩到桌子底下去，别的同学拼音早就掌握了，女儿还一片茫然，数学也是懵懵懂懂的。老师最后一句话是“你看看别人的孩子，你女儿怎么这样呢，你可得好好管管”。我这是不是就叫输在起跑线上了？\"},{\"feed_id\":\"429\",\"body\":\"怎么对付淘气的孩子呀？\",\"description\":\"咋办呀！家里来亲戚了，带了一个熊孩子！怎么办怎么办！他老是要玩我的电脑，iPad……总之就是什么都要玩！！！而且把我家里搞得一团糟！上一次把我家的电插头也戳烂了！！现在他还在乱搞！求大神支招！把熊孩子赶跑！\"},{\"feed_id\":\"2458\",\"body\":\"我家孩子用筷子用笔一会左手一会右手，不知道需不需要纠正？\",\"description\":\"我家孩子用筷子用笔一会左手一会右手，不知道需不需要纠正？\"},{\"feed_id\":\"2988\",\"body\":\"孩子不同意我再婚，我怎么办？\",\"description\":\"我今年35岁,孩子是个女孩,10岁了.我跟他爸爸离婚了4年,当时孩子的爷爷奶奶舍不得孩子,所以,抚养方式是,一星期里1-4在他家,星期5到星期天跟我.孩子也习惯了.我们双方到现在都没有再婚.孩子一直都粘我,很亲密. 但我觉得,要给她一个完整的家,有幸福感的家,这样才利于她成长,她爸爸是不可能再婚的了,因为现在她爸爸还没有反省过来,还在做糊涂人.但我问孩子,我好不好再婚时,她总是说不好,这让我不知怎么处理？\"},{\"feed_id\":\"945\",\"body\":\"喜怒无常会对孩子造成什么影响？\",\"description\":\"我跟我老婆在这儿背井离乡的地方打拼了五年了，都是我老婆自己看孩子，但是她脾气不好，经常无法控制自己似的对我和孩子发火，但是过一会就平静了。这种喜怒无常会对孩子造成什么影响啊？\"}]}";
            string n = Encoding.UTF8.GetString(bArrNew);
            
            byte[] bArrS = Encoding.UTF8.GetBytes(s);
            byte[] bArrT = Encoding.UTF8.GetBytes(t);

            byte[] bArrSNew = new byte[bArrS.Length - 3];
            for (int i = 0; i < bArrSNew.Length; i++)
            {
                bArrSNew[i] = bArrS[i + 3];
            }

            string sNew = Encoding.UTF8.GetString(bArrSNew);
            
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            Dictionary<string, object> json = (Dictionary<string, object>)serializer.DeserializeObject(sNew);
            object v;
            json.TryGetValue("data", out v);
            
        }
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

    public class Data
    {
        public Feed data { get; set; }
    }
        
    
    
    public class Feed
    {

        public int feed_id { get; set; }

        public string body { get; set; }
    }
    
    
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
    </div>
    </form>
</body>
</html>
