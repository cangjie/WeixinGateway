<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    public string name = "";
    public int id = 0;
    public OilDetail oilDetail;
    

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request["id"] != null)
        {
            id = int.Parse(Request["id"].Trim());
            oilDetail = new OilDetail(id);
        }
        else
        {
            name = Request["name"].Trim();
            oilDetail = new OilDetail(name);
        }
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <div id="head" style="font-size:50px">
            <span style="font-size:100px;display:block" ><% = oilDetail.Name.Trim() %></span> <%=oilDetail.Alias.Trim() %> <%=oilDetail.Smell %>
        </div>
        <div><hr /></div>
        <div id="use" style="font-size:40px" >
            <h2>用途：</h2>
            <div id="use_detail" >
                <img  style="width:400px;float:right" src="images/products/<%=oilDetail.PlantImage.Trim() %>" />
                <%=oilDetail.Use.Trim() %>
            </div>
        </div>
        <div><hr /></div>
        <div id="body_effect" style="font-size:40px" >
            <h2>作用于：</h2>
            <div id="body_effect_detail" >
                <%=oilDetail.BodyEffectArea.Trim() %>
            </div>
        </div>
        <div><hr /></div>
        <div id="Div1" style="font-size:40px" >
            <h2>涂抹：</h2>
            <div id="Div2" >
                <%=oilDetail.Topical.Trim() %>
            </div>
        </div>
        <div><hr /></div>
        <div id="Div3" style="font-size:40px" >
            <h2>熏香：</h2>
            <div id="Div4" >
                <%=oilDetail.Aroma.Trim() %>
            </div>
        </div>
        <div><hr /></div>
        <div id="Div5" style="font-size:40px" >
            <h2>内服：</h2>
            <div id="Div6" >
                <%=oilDetail.InnerUse.Trim() %>
            </div>
        </div>
        <div><hr /></div>
        <div id="Div7" style="font-size:40px" >
            <h2>禁忌和注意：</h2>
            <div id="Div8" >
                <%=oilDetail.InnerUse.Trim() %>
            </div>
        </div>
    </div>
    </form>
</body>
</html>
