<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<!DOCTYPE html>

<script runat="server">

    public DataTable dt = new DataTable();

    protected void Page_Load(object sender, EventArgs e)
    {
        SqlDataAdapter da = new SqlDataAdapter(" select * from oildetail where oildetail_type = '单方' order by oildetail_name ", Util.conStr);
        da.Fill(dt);
        da.Dispose();
        
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style>
        /*
        img.essential_oil_product_image:first-child {
            float:right;
            margin-right:10px;
            width:450px
        }
        essential_oil_product_list img:last-child {
            float:left;
            margin-right:10px;
            width:450px
        }
            */

        a {
            text-decoration:none;
            color:GrayText
        }

        .essential_oil_product_list {
            list-style:none outside none;
    
        }

        ul.essential_oil_product_list>li:nth-of-type(odd) img{
            float:right;
            margin-right:10px;
            width:450px;
            height:360px
        }

        ul.essential_oil_product_list>li:nth-of-type(even) img{
            float:left;
            margin-right:10px;
            width:450px;
            height:360px
        }
           
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <ul class="essential_oil_product_list" >
                <%
                    foreach(DataRow dr in dt.Rows)
                    {
                        OilDetail oilDetail = new OilDetail();
                        oilDetail._fields = dr;
                     %>
                <li style="height:380px">
                    <a href="show_essential.aspx?id=<%=oilDetail.ID.ToString() %>" ><img border="0" class="essential_oil_product_image" src="http://weixin2.999uuu.cn/images/products/<%=oilDetail.PlantImage.Trim() %>" /></a>
                    <p style="font-size:40pt;margin-top:4px;margin-bottom:4px"><b><a href="show_essential.aspx?id=<%=oilDetail.ID.ToString() %>" ><%=oilDetail.Name.Trim() %></a></b></p>
                    <p style="font-size:30pt;margin-top:2px;margin-bottom:2px" ><a href="show_essential.aspx?id=<%=oilDetail.ID.ToString() %>" ><%=oilDetail.Alias.Trim() %></a></p>
                    <p style="font-size:30pt;margin-top:2px;margin-bottom:2px" ><a href="show_essential.aspx?id=<%=oilDetail.ID.ToString() %>" ><%=oilDetail.Smell.Trim() %></a></p>
                    <p style="font-size:30pt;margin-top:2px;margin-bottom:2px" ><a href="show_essential.aspx?id=<%=oilDetail.ID.ToString() %>" ><%=oilDetail.BodyEffectArea.Trim() %></a></p>
                </li>
                <%
                }
                     %>
                <!--li>
                    <img class="essential_oil_product_image" src="http://weixin2.999uuu.cn/images/products/bohe.jpg" />
                    <p style="font-size:40pt"><b>薄荷</b></p>
                    <p style="font-size:25pt" >薄荷、Peppermint</p>
                    <p style="font-size:25pt" >薄荷味，较尖锐的味道</p>
                    <p style="font-size:25pt" >消化系统、肌肉和骨骼、神经系统、呼吸系统、皮肤</p>
                </li>
                <li>
                    <img class="essential_oil_product_image" src="http://weixin2.999uuu.cn/images/products/bohe.jpg" />
                    <p style="font-size:40pt"><b>薄荷</b></p>
                    <p style="font-size:25pt" >薄荷、Peppermint</p>
                    <p style="font-size:25pt" >薄荷味，较尖锐的味道</p>
                    <p style="font-size:25pt" >消化系统、肌肉和骨骼、神经系统、呼吸系统、皮肤</p>
                </li-->
            </ul>
        </div>
        <!--
    <div class="essential_oil_product_list" >
        <div>
            <img class="essential_oil_product_image" src="http://weixin2.999uuu.cn/images/products/bohe.jpg" />
            <div style="font-size:40pt"><b>薄荷</b></div>
            <br />
            <div style="font-size:25pt" >薄荷、Peppermint</div>
            <br />
            <div style="font-size:25pt" >薄荷味，较尖锐的味道</div>
            <br />
            <div style="font-size:25pt" >消化系统、肌肉和骨骼、神经系统、呼吸系统、皮肤</div>
        </div>
        <br /><hr /><br />
        <div>
            <img class="essential_oil_product_image" src="http://weixin2.999uuu.cn/images/products/bohe.jpg"  />
            <div style="font-size:40pt"><b>薄荷</b></div>
            <br />
            <div style="font-size:25pt" >薄荷、Peppermint</div>
            <br />
            <div style="font-size:25pt" >薄荷味，较尖锐的味道</div>
            <br />
            <div style="font-size:25pt" >消化系统、肌肉和骨骼、神经系统、呼吸系统、皮肤</div>
        </div>
        <br /><hr /><br />
        <div>
            <img class="essential_oil_product_image" src="http://weixin2.999uuu.cn/images/products/bohe.jpg"  />
            <div style="font-size:40pt"><b>薄荷</b></div>
            <br />
            <div style="font-size:25pt" >薄荷、Peppermint</div>
            <br />
            <div style="font-size:25pt" >薄荷味，较尖锐的味道</div>
            <br />
            <div style="font-size:25pt" >消化系统、肌肉和骨骼、神经系统、呼吸系统、皮肤</div>
        </div>
    </div>
        -->
    </form>
</body>
</html>
