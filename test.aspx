<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Xml" %>
<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        //string keyValuePair = "txamt=1&txcurrcd=CNY&pay_type=800207";
        //Response.Write(Util.GetHaojinMd5Sign(keyValuePair.Trim(),"7AB7F12D1A374208BA9A9E29E337BAEE"));

        /*
        SalesFlowSheet sfs = new SalesFlowSheet(Server.MapPath("bayi.xlsx"));
        sfs.SetFieldsPosition();
        sfs.FillDragonBallBlank();
        sfs.Dispose();
        */
        /*
        for(int i = 0; i < 600; i++)
        {
            Card.GenerateCardNo(9, 1);

        }

        */

        //Order.ImportOrderDragonBall("NS2016120401");
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
