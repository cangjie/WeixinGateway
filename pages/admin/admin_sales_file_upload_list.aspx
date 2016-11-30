<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<!DOCTYPE html>

<script runat="server">

    public static string fileUploadPath = "sale_lists/uploaded";
    public static string fileDownloadPath = "sale_lists/downloads";

    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void btnUpload_Click(object sender, EventArgs e)
    {
        string fileName = SaveUploadedFile();
        if (!fileName.Trim().Equals(""))
        {
            DealFile(fileName);
        }
        else
        {

        }
        
    }

    public string SaveUploadedFile()
    {
        string fileName = Util.GetTimeStamp()+".xlsx";
        fileUpload.SaveAs(Server.MapPath(fileUploadPath + "/" + fileName.Trim()));
        if (!IsFileExists(fileName))
        {
            fileUpload.SaveAs(Server.MapPath(fileUploadPath + "/" + fileName));
        }
        else
        {
            fileName = "";
        }
        return fileName.Trim();
    }

    public bool IsFileExists(string fileName)
    {
        string fileMd5 = getFileMd5(fileName);
        DataTable dt = DBHelper.GetDataTable(" select * from point_uploaded_file where md5 = '" + fileMd5 + "'" );
        bool exsits = true;
        if (dt.Rows.Count == 0)
            exsits = false;
        else
            exsits = true;
        dt.Dispose();
        if (!exsits)
        {
            string[,] insertParam = { {"path_name", "varchar", fileUploadPath + "/" + fileName.Trim() },
                {"md5", "varchar", fileMd5.Trim() }, {"memo", "varchar", "" } };
            int i = DBHelper.InsertData("point_uploaded_file", insertParam);
            if (i <= 0)
                exsits = true;
        }
        return exsits;
    }

    public string getFileMd5(string fileName)
    {
        byte[] fileContent = Util.GetBinaryFileContent(Server.MapPath(fileUploadPath + "/" + fileName));

        char[] charContent = new char[fileContent.Length];
        for (long i = 0; i < charContent.Length; i++)
        {
            charContent[i] = (char)fileContent[i];
        }
        String fileContentString = new string(charContent);
        return Util.GetMd5((string)fileContentString);
    }



    public void DealFile(string fileName)
    {
        SalesFlowSheet sfs = new SalesFlowSheet(Server.MapPath(fileDownloadPath + "/" + fileName.Trim()));
        sfs.SetFieldsPosition();
        sfs.FillDragonBallBlank();
    }



</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <table style="width:100%" >
            <tr>
                <td><asp:Label ID="labelInfo" Width="100%" runat="server" Font-Bold="True" ForeColor="Red" ></asp:Label></td>
            </tr>
            <tr>
                <td><asp:FileUpload ID="fileUpload" runat="server" />&nbsp;&nbsp;&nbsp; <asp:Button ID="btnUpload" runat="server" Text="上传" OnClick="btnUpload_Click" /></td>
            </tr>
            <tr>
                <td>
                    <asp:DataGrid runat="server" ID="dg" Width="100%" BackColor="White" BorderColor="#999999" BorderStyle="None" BorderWidth="1px" CellPadding="3" GridLines="Vertical" >
                        <AlternatingItemStyle BackColor="#DCDCDC" />
                        <FooterStyle BackColor="#CCCCCC" ForeColor="Black" />
                        <HeaderStyle BackColor="#000084" Font-Bold="True" ForeColor="White" />
                        <ItemStyle BackColor="#EEEEEE" ForeColor="Black" />
                        <PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" Mode="NumericPages" />
                        <SelectedItemStyle BackColor="#008A8C" Font-Bold="True" ForeColor="White" />
                    </asp:DataGrid>
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
