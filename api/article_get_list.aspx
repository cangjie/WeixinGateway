<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string json = "";
        string token = Util.GetSafeRequestValue(Request, "token", "23a43a51801d9fee4881f8a73549c769f67c2ef995b26c5724cbb82756c560d58a283adf");
        string currentUserOpenId = WeixinUser.CheckToken(token);
        if (!currentUserOpenId.Trim().Equals(""))
        {
            Article[] articleArray = Article.GetList();
            string jsonArticleArray = "";
            foreach (Article article in articleArray)
            {
                article.Init();
                string jsonArticle = article.Json.Trim().Remove(article.Json.Trim().Length - 1, 1);
                bool shared = article.IfUserSharedMoment(currentUserOpenId.Trim());
                jsonArticle = jsonArticle + " , \"shared\" : "
                    + (shared ? "1" : "0") + "  , \"read_num\" : " + Article.GetActionTable(article.ID, currentUserOpenId, "read").Rows.Count.ToString()
                    + " , \"share_num\" : " + Article.GetActionTable(article.ID, currentUserOpenId, "sharemoment").Rows.Count.ToString() + "  }";


                jsonArticleArray = jsonArticleArray + "," + jsonArticle.Trim();
            }
            json = "{\"status\" : 0 ,  \"count\" : " + articleArray.Length.ToString() + " ,  \"article_array\" : [" + jsonArticleArray.Trim() + " ] }";
            Response.Write(json.Trim());
        }
        else
        {
            Response.Write("{\"status\" : 1 , \"error_message\" : \"invalid token\" }");
        }
    }
</script>