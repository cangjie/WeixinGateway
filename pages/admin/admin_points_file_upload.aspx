<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["is-log-in"] == null || !Session["is-log-in"].ToString().Equals("1"))
        {
            Response.Redirect("admin_login.aspx", true);
        }
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        string fileName = "upload/point_file/2016-2017/" + Util.GetTimeStamp() + ".csv";
        string fullFilePathName = Server.MapPath("../"+fileName);
        FileUpload1.SaveAs(fullFilePathName);
        int[] validResult = PointFile.ValidateUploadedPointTable(PointFile.ConvertUploadedPointFileToDataTable(fullFilePathName));
        if (validResult[0] == -1 && validResult[1] == -1)
        {
            int pointFileId = PointFile.AddNewFile(fileName, TextBox1.Text.Trim());
            if (pointFileId > 0)
            {
                labelUploadInfo.Text = "文件正确，点击确认，导入数据库。";
                Button2.Enabled = true;
                ViewState["id"] = pointFileId.ToString();
                
            }
            else
            {
                labelUploadInfo.Text = "文件重复";
                Button2.Enabled = false;
            }
            
        }
        else
        {
            labelUploadInfo.Text = "第" + (validResult[0]+1).ToString() + "行，第" + (validResult[1]+1).ToString() + "列错误。";
            Button2.Enabled = false;
            
        }
        dataConfirmGrid.DataSource = PointFile.ConvertUploadedPointFileToDataTable(fullFilePathName);
        dataConfirmGrid.DataBind();
    }

    protected void Button2_Click(object sender, EventArgs e)
    {
        PointFile pointFile = new PointFile(int.Parse(ViewState["id"].ToString().Trim()));
        pointFile.ImportUploadedPointFileToDB();
        Response.Redirect("admin_points_file_list.aspx", true);
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <div id="file-upload">
            <div>上传文件：<asp:FileUpload ID="FileUpload1" runat="server" />
&nbsp;(csv文件，用逗号分隔)</div>
            <div>备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注：<asp:TextBox ID="TextBox1" runat="server" Width="449px"></asp:TextBox>
            </div>
            <div>
                <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="上  传" />
            </div>

        </div>
        <hr />

        <div id="file-upload-data" >
            <div>

                <asp:Label ID="labelUploadInfo" runat="server" Font-Bold="True" Font-Size="Small" ForeColor="Red"></asp:Label>

            </div>
            <div>
                <asp:DataGrid runat="server" ID="dataConfirmGrid" BackColor="White" BorderColor="#999999" BorderStyle="None" BorderWidth="1px" CellPadding="3" GridLines="Vertical" Width="100%" >
                    <AlternatingItemStyle BackColor="#DCDCDC" />
                    <FooterStyle BackColor="#CCCCCC" ForeColor="Black" />
                    <HeaderStyle BackColor="#000084" Font-Bold="True" ForeColor="White" />
                    <ItemStyle BackColor="#EEEEEE" ForeColor="Black" />
                    <PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" Mode="NumericPages" />
                    <SelectedItemStyle BackColor="#008A8C" Font-Bold="True" ForeColor="White" />
                </asp:DataGrid>
            </div>
            <div>

                <asp:Button ID="Button2" runat="server" Text="确  认" OnClick="Button2_Click" />

            </div>
        </div>
    </div>
    </form>
</body>
</html>
