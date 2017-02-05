<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        SalesFlowSheet sfs = new SalesFlowSheet(Server.MapPath("auto_score_sheet.xlsx"));
        for(int i = 1; i <= 30; i++ )
        {
            Microsoft.Office.Interop.Excel.Range range = (Microsoft.Office.Interop.Excel.Range)sfs.worksheet.Cells[30, i];
            //range.Interior.ColorIndex = i-1;
            range.Interior.Color = 0xD6DCE4;
            range.Borders.get_Item( Microsoft.Office.Interop.Excel.XlBordersIndex.xlEdgeLeft).Weight = Microsoft.Office.Interop.Excel.XlBorderWeight.xlHairline;

        }
        sfs.workbook.Save();
        sfs.Dispose();
    }
</script>