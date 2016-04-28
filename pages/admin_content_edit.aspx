<%@ Page Language="C#" ValidateRequest="false" %>

<!DOCTYPE html>

<script runat="server">


    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            int id = int.Parse(Util.GetSafeRequestValue(Request, "id", "0"));
            if (id == 0)
            {
                Button1.Text = "添  加";
            }
            else
            {
                Article article = new Article(id);
                Image1.ImageUrl = article.Image.Trim();
                TextBox1.Text = article.Title.Trim();
                content1.InnerHtml = article.Content.Trim();
                Button1.Text = "更  新";
            }
        }
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        int id = int.Parse(Util.GetSafeRequestValue(Request, "id", "0"));
        Article article;
        if (id == 0)
        {
            id = Article.AddArticle(TextBox1.Text.Trim(), Request.Form["content1"].Trim());
            article = new Article(id);
            
        }
        else
        {
            article = new Article(id);
            article.Title = TextBox1.Text.Trim();
            article.Content = Request.Form["content1"].Trim();
        }
        
        string fileName = Util.GetTimeStamp();
        string originFileName = FileUpload1.FileName.Trim();
        string[] originFileNameDotSegmentArray = originFileName.Split('.');
        string originFileNameExtesion = originFileNameDotSegmentArray[originFileNameDotSegmentArray.Length - 1];
        fileName = fileName + "." + originFileNameExtesion;
        string filePathAndName = Server.MapPath("../images/ariticle_logo") + "\\" + fileName.Trim();
        FileUpload1.SaveAs(filePathAndName);
        article.Image = "images/ariticle_logo/" + fileName.Trim();
        
        
        Response.Redirect("admin_content_list.aspx", true);
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        .auto-style1 {
            width: 100%;
        }
    </style>
        <link rel="stylesheet" href="../kind_editor/themes/default/default.css" />
	<link rel="stylesheet" href="../kind_editor/plugins/code/prettify.css" />
	<script charset="utf-8" src="../kind_editor/kindeditor-all-min.js"></script>
	<script charset="utf-8" src="../kind_editor/lang/zh-CN.js"></script>
	<script charset="utf-8" src="../kind_editor/plugins/code/prettify.js"></script>
    <script>
        KindEditor.ready(function (K) {
            var editor1 = K.create('#content1', {
                cssPath: '../kind_editor/plugins/code/prettify.css',
                uploadJson: '../kind_editor/asp.net/upload_json.ashx',
                fileManagerJson: '../kind_editor/asp.net/file_manager_json.ashx',
                allowFileManager: true,
                afterCreate: function () {
                    var self = this;
                    K.ctrl(document, 13, function () {
                        self.sync();
                        K('form[name=example]')[0].submit();
                    });
                    K.ctrl(self.edit.doc, 13, function () {
                        self.sync();
                        K('form[name=example]')[0].submit();
                    });
                    
                }
            });
            prettyPrint();
        });


	</script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        
        <table class="auto-style1">
            <tr>
                <td>
                    <asp:TextBox ID="TextBox1" runat="server" Width="450px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td>
                    <asp:FileUpload ID="FileUpload1" runat="server" />
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Image ID="Image1" runat="server" Height="100px" Width="100px" />
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td><textarea id="content1" cols="100" rows="8" style="width:1000px;height:500px;visibility:hidden;" runat="server" ></textarea></td>
            </tr>
            <tr>
                <td>
                    <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="提  交" />
                </td>
            </tr>
        </table>
        
    </div>
    </form>
    <script type="text/javascript" >
        
    </script>
</body>
</html>
