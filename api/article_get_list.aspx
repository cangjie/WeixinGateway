<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string json = "";
        string token = Util.GetSafeRequestValue(Request, "token", "b3a3fc1bc72bef6ba645c3bb0be4d7f4abe2e2a232940e15b4c93b3e276be2d9f5ad4f9b");
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
            if (jsonArticleArray.StartsWith(","))
                jsonArticleArray = jsonArticleArray.Remove(0, 1).Trim();
            json = "{\"status\" : 0 ,  \"count\" : " + articleArray.Length.ToString() + " ,  \"article_array\" : [" + jsonArticleArray.Trim() + " ] }";
            Response.Write(json.Trim());
        }
        else
        {
            Response.Write("{\"status\" : 1 , \"error_message\" : \"invalid token\" }");
        }
    }
</script>