<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data" %>
<!DOCTYPE html>

<script runat="server">

    public static string taobaoCookie = "_cc_=U%2BGCWk%2F7og%3D%3D; isg=BHNzIm1sLLjhceAs0koBefZHCnedqAdq81bNiCUQwxLJJJPGrX6wut_32pZvn19i; thw=cn; uc3=vt3=F8dBzrVHvlfZ8HiHo%2Fg%3D&id2=UUjQkfQWp0U%3D&nk2=AHtzPWJHZuQ%3D&lg2=Vq8l%2BKCLz3%2F65A%3D%3D; t=aebd3876f101f4cb03a4e8cf8698442d; mt=ci=9_1&np=; x=e%3D1%26p%3D*%26s%3D0%26c%3D0%26f%3D0%26g%3D0%26t%3D0%26__ll%3D-1%26_ato%3D0; lgc=cang_jie; cna=OH/rEDrVX0UCAXt467nw59F8; tracknick=cang_jie; tg=0; hng=CN%7Czh-CN%7CCNY%7C156; cookie2=305409b95652c7cc5756c5c9455495c3; v=0; _tb_token_=e3d3e386783fb; unb=20190672; uc1=cookie16=VT5L2FSpNgq6fDudInPRgavC%2BQ%3D%3D&cookie21=VFC%2FuZ9ainBZ&cookie15=UtASsssmOIJ0bQ%3D%3D&existShop=false&pas=0&cookie14=UoTfLJZsiH7hxw%3D%3D&tag=8&lng=zh_CN; sg=e26; _l_g_=Ug%3D%3D; skt=7ebec4a6e30d5680; publishItemObj=Ng%3D%3D; cookie1=ACOw2OO77SjEiZ%2Bnmt3Qj1nG3vmE9i44AgY9dTKFXUA%3D; csg=e2497b23; existShop=MTUzNzM2Mzk1MA%3D%3D; dnk=cang_jie; _nk_=cang_jie; cookie17=UUjQkfQWp0U%3D; whl=-1%260%260%261537363997303; _uab_collina=153664080870812149011691; _umdata=E2AE90FA4E0E42DEC03C2D871D8699C6E3828FD9AABB6ABE270F0E3F28C8BC95D6427B091B97AF8DCD43AD3E795C914C661D5033D7B04A3CC5837D827B7D734E; pnm_cku822=; swfstore=215388; x5sec=7b2273686f7073797374656d3b32223a2261666435626233633734393235353238653237643863343566636630326235614350326669643046454932496e646966695a576c4e526f4b4d6a41784f5441324e7a49374d513d3d227d";

    public static string tmallCookie = "uc3=vt3=F8dByRuSY%2FUjbB%2BuKN8%3D&id2=UUjQkfQWp0U%3D&nk2=AHtzPWJHZuQ%3D&lg2=VFC%2FuZ9ayeYq2g%3D%3D; t=aebd3876f101f4cb03a4e8cf8698442d; tracknick=cang_jie; lgc=cang_jie; _tb_token_=77e77ee3f73db; cookie2=1d0b7f3a3c48d2e4a9dd289fa5e84038; uss=; isg=BLa20zE-8aiB9oXMvZUxQmRCD-y41_oRfnGoYyCfdBk0Y1b9iGazIR9Qf_2qUPIp; otherx=e%3D1%26p%3D*%26s%3D0%26c%3D0%26f%3D0%26g%3D0%26t%3D0; cna=OH/rEDrVX0UCAXt467nw59F8; lid=cang_jie; hng=CN%7Czh-CN%7CCNY%7C156; uc1=cookie16=U%2BGCWk%2F74Mx5tgzv3dWpnhjPaQ%3D%3D&cookie21=UIHiLt3xTIkz&cookie15=W5iHLLyFOGW7aA%3D%3D&existShop=false&pas=0&cookie14=UoTfLJ1cP0KHaQ%3D%3D&tag=8&lng=zh_CN; _l_g_=Ug%3D%3D; ck1=; unb=20190672; cookie1=ACOw2OO77SjEiZ%2Bnmt3Qj1nG3vmE9i44AgY9dTKFXUA%3D; login=true; cookie17=UUjQkfQWp0U%3D; _nk_=cang_jie; csg=91261c35; skt=3a5db4f0bdb76858; whl=-1%260%260%260; x=__ll%3D-1%26_ato%3D0; swfstore=225157; _uab_collina=153786670879633428650968; cq=ccp%3D0; pnm_cku822=";

    protected void Page_Load(object sender, EventArgs e)
    {

        if (Core.TaobaoSnap.taobaoCookie.Trim().Equals(""))
            Core.TaobaoSnap.taobaoCookie = taobaoCookie;
        if (Core.TaobaoSnap.tmallCookie.Trim().Equals(""))
            Core.TaobaoSnap.tmallCookie = tmallCookie;

    }

    protected void BtnSearch_Click(object sender, EventArgs e)
    {
        DataTable dt = GetData();
        dg.DataSource = dt;
        dg.DataBind();

    }

    public DataTable GetData()
    {
        /*
        if (TxtUrl.Text.Trim().IndexOf("tmall.com/") > 0)
        {
            Core.TaobaoSnap.taobaoCookie = tmallCookie;
        }
        else
        {
            Core.TaobaoSnap.taobaoCookie = taobaoCookie;
        }
        */
        DataTable dt = new DataTable();
        string[] urlArr = TxtUrl.Text.Trim().Split('\n');
        foreach (string url in urlArr)
        {
            if (url.Trim().Equals(""))
            {
                continue;
            }
            string productUrl = Core.TaobaoSnap.GetFormattedProductUrl(url.Trim()).Replace("&amp;", "&").Trim();
            int historyId = Core.TaobaoSnap.AddUrlSearchHistory(url.Trim(), productUrl.Trim(), DateTime.Now);
            DataTable tempDt = Core.TaobaoSnap.GetProductTable(productUrl.Trim());
            if (dt.Columns.Count == 0)
            {
                dt = tempDt.Clone();
                dt.Columns.Add("domain");
            }
            string domain = productUrl.Replace("http://", "").Replace("https://", "").Trim().Split('/')[0].Trim();
            foreach (DataRow tempDr in tempDt.Rows)
            {
                DataRow dr = dt.NewRow();
                foreach (DataColumn tempDc in tempDt.Columns)
                {
                    dr[tempDc.Caption.Trim()] = tempDr[tempDc];
                }
                dr["domain"] = domain.Trim();
                dt.Rows.Add(dr);
            }
        }

        return dt;
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
        <asp:TextBox ID="TxtUrl" runat="server" Width="1091px" Height="162px" TextMode="MultiLine" ></asp:TextBox> 
        <br />
        <asp:Button ID="BtnSearch" Text="Search" runat="server" OnClick="BtnSearch_Click" /> &nbsp;<asp:Button runat="server" ID="BtnDownload" Text="Download CSV" OnClick="BtnDownload_Click" />
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
    <div>Taobao Cookie:<%=Core.TaobaoSnap.taobaoCookie.Trim() %></div>
    <div>Tmall Cookie:<%=Core.TaobaoSnap.tmallCookie.Trim()%></div>
    </form>
</body>
</html>
