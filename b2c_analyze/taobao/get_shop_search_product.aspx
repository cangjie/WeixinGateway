<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data" %>
<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        Core.TaobaoSnap.taobaoCookie = "_cc_=U%2BGCWk%2F7og%3D%3D; isg=BHNzIm1sLLjhceAs0koBefZHCnedqAdq81bNiCUQwxLJJJPGrX6wut_32pZvn19i; thw=cn; uc3=vt3=F8dBzrVHvlfZ8HiHo%2Fg%3D&id2=UUjQkfQWp0U%3D&nk2=AHtzPWJHZuQ%3D&lg2=Vq8l%2BKCLz3%2F65A%3D%3D; t=aebd3876f101f4cb03a4e8cf8698442d; mt=ci=9_1&np=; x=e%3D1%26p%3D*%26s%3D0%26c%3D0%26f%3D0%26g%3D0%26t%3D0%26__ll%3D-1%26_ato%3D0; lgc=cang_jie; cna=OH/rEDrVX0UCAXt467nw59F8; tracknick=cang_jie; tg=0; hng=CN%7Czh-CN%7CCNY%7C156; cookie2=305409b95652c7cc5756c5c9455495c3; v=0; _tb_token_=e3d3e386783fb; unb=20190672; uc1=cookie16=VT5L2FSpNgq6fDudInPRgavC%2BQ%3D%3D&cookie21=VFC%2FuZ9ainBZ&cookie15=UtASsssmOIJ0bQ%3D%3D&existShop=false&pas=0&cookie14=UoTfLJZsiH7hxw%3D%3D&tag=8&lng=zh_CN; sg=e26; _l_g_=Ug%3D%3D; skt=7ebec4a6e30d5680; publishItemObj=Ng%3D%3D; cookie1=ACOw2OO77SjEiZ%2Bnmt3Qj1nG3vmE9i44AgY9dTKFXUA%3D; csg=e2497b23; existShop=MTUzNzM2Mzk1MA%3D%3D; dnk=cang_jie; _nk_=cang_jie; cookie17=UUjQkfQWp0U%3D; whl=-1%260%260%261537363997303; _uab_collina=153664080870812149011691; _umdata=E2AE90FA4E0E42DEC03C2D871D8699C6E3828FD9AABB6ABE270F0E3F28C8BC95D6427B091B97AF8DCD43AD3E795C914C661D5033D7B04A3CC5837D827B7D734E; pnm_cku822=; swfstore=215388; x5sec=7b2273686f7073797374656d3b32223a2261666435626233633734393235353238653237643863343566636630326235614350326669643046454932496e646966695a576c4e526f4b4d6a41784f5441324e7a49374d513d3d227d";

    }

    protected void BtnSearch_Click(object sender, EventArgs e)
    {
        DataTable dt = GetData();
        dg.DataSource = dt;
        dg.DataBind();

    }

    public DataTable GetData()
    {
        string productUrl = Core.TaobaoSnap.GetFormattedProductUrl(TxtUrl.Text.Trim()).Replace("&amp;", "&").Trim();
        return Core.TaobaoSnap.GetProductTable(productUrl.Trim());
    }

    protected void BtnDownload_Click(object sender, EventArgs e)
    {
        DataTable dt = GetData();
        string content = "";
        string captionContent = "";
        foreach (DataColumn c in dt.Columns)
        {
            captionContent = captionContent +
                (captionContent.Trim().Equals("") ? "" : ",") + c.Caption.Trim();
        }
        content = captionContent.Trim();
        HttpContext.Current.Response.Clear();
        System.IO.StringWriter sw = new System.IO.StringWriter();
        sw.Write(captionContent.Trim());
        foreach (DataRow dr in dt.Rows)
        {
            string lineContent = "";
            foreach (DataColumn c in dt.Columns)
            {
                lineContent = lineContent
                    + (lineContent.Trim().Equals("") ? "" : ",") + dr[c].ToString().Trim();
            }
            //content = content + "\r\n" + lineContent.Trim();
            sw.Write(sw.NewLine);
            sw.Write(lineContent);
        }
        sw.Close();
        string fileName = Util.GetTimeStamp() + ".csv";
        HttpContext.Current.Response.AddHeader("Content-Disposition", "attachment; filename=" + fileName.Trim());
        HttpContext.Current.Response.ContentType = "application/vnd.ms-excel";
        HttpContext.Current.Response.ContentEncoding = System.Text.Encoding.GetEncoding("GB2312");
        HttpContext.Current.Response.Write(sw);
        HttpContext.Current.Response.End();
        dt.Dispose();
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:TextBox ID="TxtUrl" runat="server" Width="1091px" ></asp:TextBox> <asp:Button ID="BtnSearch" Text="Search" runat="server" OnClick="BtnSearch_Click" /> &nbsp;<asp:Button runat="server" ID="BtnDownload" Text="Download CSV" OnClick="BtnDownload_Click" />
    </div>
    <div>
        <asp:DataGrid runat="server" ID="dg" width="100%" BackColor="White" BorderColor="#999999" BorderStyle="None" BorderWidth="1px" CellPadding="3" GridLines="Vertical">
            <AlternatingItemStyle BackColor="#DCDCDC" />
            <FooterStyle BackColor="#CCCCCC" ForeColor="Black" />
            <HeaderStyle BackColor="#000084" Font-Bold="True" ForeColor="White" />
            <ItemStyle BackColor="#EEEEEE" ForeColor="Black" />
            <PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" Mode="NumericPages" />
            <SelectedItemStyle BackColor="#008A8C" Font-Bold="True" ForeColor="White" />
        </asp:DataGrid>
    </div>
    </form>
</body>
</html>
