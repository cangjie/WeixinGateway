<%@ Page Language="C#" %>
<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        //Authorize();
        
    }

    public void Authorize()
    {
        string token = Session["token"] == null ? "" : Session["token"].ToString();
        if (token.Trim().Equals(""))
        {
            Response.Redirect("../authorize.aspx?callback="
                + Server.UrlEncode(Request.Url.ToString().Trim()), true);
        }
        string openId = WeixinUser.CheckToken(token);
        if (openId.Trim().Equals(""))
        {
            Response.Redirect("../authorize.aspx?callback="
                + Server.UrlEncode(Request.Url.ToString().Trim()), true);
        } 
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="docs/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="docs/css/highlight.css" rel="stylesheet"/>
    <link href="dist/css/bootstrap3/bootstrap-switch.css" rel="stylesheet"/>
    <link href="http://getbootstrap.com/assets/css/docs.min.css" rel="stylesheet"/>
    <link href="docs/css/main.css" rel="stylesheet">
</head>
<body>


    <div id="root" style="padding:20px 20px 20px 20px" >

        <div style="border:1px solid #BEBEBE;padding:2px" >test</div>
        <br />
        <div style="border:1px solid #BEBEBE;padding:3px" >test</div>
        <br />
        <div style="border:1px solid #BEBEBE;padding: 5px" >test</div>
        <br />
        <div style="border:1px solid #BEBEBE;" >test</div>
        <br />
        <div style="border:1px solid #BEBEBE;" >test</div>
        <br />
        <div style="border:1px solid #BEBEBE;" >test</div>
        <br />
        <div style="border:1px solid #BEBEBE;" >test</div>


    </div>
    
    
    <button data-toggle="modal" data-target="#modal-switch" class="btn btn-default">Open Modal</button>
          <div id="modal-switch" tabindex="-1" role="dialog" aria-labelledby="modal-switch-label" class="modal fade">
            <div class="modal-dialog">
              <div class="modal-content">
                <div class="modal-header">
                  <button type="button" data-dismiss="modal" class="close"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                  <div id="modal-switch-label" class="modal-title">Title</div>
                </div>
                <div class="modal-body">
                  <input id="switch-modal" type="checkbox" checked>
                </div>
              </div>
            </div>
          </div>
     
    <script src="docs/js/jquery.min.js"></script>
    <script src="docs/js/bootstrap.min.js"></script>
    <script src="docs/js/highlight.js"></script>
    <script src="dist/js/bootstrap-switch.js"></script>
    <script src="docs/js/main.js"></script>
</body>

</html>
