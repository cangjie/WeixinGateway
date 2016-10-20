using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.Office.Interop.Excel;
using System.Diagnostics;
using System.Data;

/// <summary>
/// Summary description for ExcelOptions
/// </summary>
public class ExcelOptions
{
    private Stopwatch wath = new Stopwatch();

    /// <summary>
    /// 使用COM读取Excel
    /// </summary>
    /// <param name="excelFilePath">路径</param>
    /// <returns>DataTabel</returns>
    public System.Data.DataTable GetExcelData(string excelFilePath)
    {
        Microsoft.Office.Interop.Excel.Application app = new Microsoft.Office.Interop.Excel.Application();
        Microsoft.Office.Interop.Excel.Sheets sheets;
        Microsoft.Office.Interop.Excel.Workbook workbook = null;
        object oMissiong = System.Reflection.Missing.Value;
        System.Data.DataTable dt = new System.Data.DataTable();

        wath.Start();
        try
        {

            if (app == null)
            {
                return null;
            }

            workbook = app.Workbooks.Open(excelFilePath, oMissiong, oMissiong, oMissiong, oMissiong, oMissiong, oMissiong, oMissiong, oMissiong, oMissiong, oMissiong, oMissiong, oMissiong, oMissiong, oMissiong);

            //将数据读入到DataTable中——Start   

            sheets = workbook.Worksheets;
            Microsoft.Office.Interop.Excel.Worksheet worksheet = (Microsoft.Office.Interop.Excel.Worksheet)sheets.get_Item(1);//读取第一张表
            if (worksheet == null)
                return null;

            string cellContent;
            int iRowCount = worksheet.UsedRange.Rows.Count;
            int iColCount = worksheet.UsedRange.Columns.Count;
            Microsoft.Office.Interop.Excel.Range range;

            //负责列头Start
            DataColumn dc;
            int ColumnID = 1;
            range = (Microsoft.Office.Interop.Excel.Range)worksheet.Cells[1, 1];
            while (range.Text.ToString().Trim() != "")
            {
                dc = new DataColumn();
                dc.DataType = System.Type.GetType("System.String");
                dc.ColumnName = range.Text.ToString().Trim();
                dt.Columns.Add(dc);

                range = (Microsoft.Office.Interop.Excel.Range)worksheet.Cells[1, ++ColumnID];
            }
            //End

            for (int iRow = 2; iRow <= 10; iRow++)
            {
                DataRow dr = dt.NewRow();

                for (int iCol = 1; iCol <= iColCount; iCol++)
                {
                    if (iCol == iColCount)
                        worksheet.Cells[iRow, iCol] = (object)"4444";


                    range = (Microsoft.Office.Interop.Excel.Range)worksheet.Cells[iRow, iCol];

                    
                    
                    cellContent = (range.Value2 == null) ? "" : range.Text.ToString();

                    //if (iRow == 1)
                    //{
                    //    dt.Columns.Add(cellContent);
                    //}
                    //else
                    //{
                    dr[iCol - 1] = cellContent;
                    //}
                }

                //if (iRow != 1)
                dt.Rows.Add(dr);
            }
        }
        catch
        {

        }
        finally
        {
            workbook.Save();
            workbook.Close(false, oMissiong, oMissiong);
            System.Runtime.InteropServices.Marshal.ReleaseComObject(workbook);
            workbook = null;
            app.Workbooks.Close();
            app.Quit();
            System.Runtime.InteropServices.Marshal.ReleaseComObject(app);
            app = null;
            GC.Collect();
            GC.WaitForPendingFinalizers();
        }

            wath.Stop();
            TimeSpan ts = wath.Elapsed;

            //将数据读入到DataTable中——End
            return dt;
        
    }

    /// <summary>
    /// 删除Excel行
    /// </summary>
    /// <param name="excelFilePath">Excel路径</param>
    /// <param name="rowStart">开始行</param>
    /// <param name="rowEnd">结束行</param>
    /// <param name="designationRow">指定行</param>
    /// <returns></returns>
    public string DeleteRows(string excelFilePath, int rowStart, int rowEnd, int designationRow)
    {
        string result = "";
        Microsoft.Office.Interop.Excel.Application app = new Microsoft.Office.Interop.Excel.Application();
        Microsoft.Office.Interop.Excel.Sheets sheets;
        Microsoft.Office.Interop.Excel.Workbook workbook = null;
        object oMissiong = System.Reflection.Missing.Value;
        try
        {
            if (app == null)
            {
                return "分段读取Excel失败";
            }

            workbook = app.Workbooks.Open(excelFilePath, oMissiong, oMissiong, oMissiong, oMissiong, oMissiong, oMissiong, oMissiong, oMissiong, oMissiong, oMissiong, oMissiong, oMissiong, oMissiong, oMissiong);
            sheets = workbook.Worksheets;
            Microsoft.Office.Interop.Excel.Worksheet worksheet = (Microsoft.Office.Interop.Excel.Worksheet)sheets.get_Item(1);//读取第一张表
            if (worksheet == null)
                return result;
            Microsoft.Office.Interop.Excel.Range range;

            //先删除指定行，一般为列描述
            if (designationRow != -1)
            {
                range = (Microsoft.Office.Interop.Excel.Range)worksheet.Rows[designationRow, oMissiong];
                range.Delete(Microsoft.Office.Interop.Excel.XlDeleteShiftDirection.xlShiftUp);
            }
            Stopwatch sw = new Stopwatch();
            sw.Start();

            int i = rowStart;
            for (int iRow = rowStart; iRow <= rowEnd; iRow++, i++)
            {
                range = (Microsoft.Office.Interop.Excel.Range)worksheet.Rows[rowStart, oMissiong];
                range.Delete(Microsoft.Office.Interop.Excel.XlDeleteShiftDirection.xlShiftUp);
            }

            sw.Stop();
            TimeSpan ts = sw.Elapsed;
            workbook.Save();

            //将数据读入到DataTable中——End
            return result;
        }
        catch
        {

            return "分段读取Excel失败";
        }
        finally
        {
            workbook.Close(false, oMissiong, oMissiong);
            System.Runtime.InteropServices.Marshal.ReleaseComObject(workbook);
            workbook = null;
            app.Workbooks.Close();
            app.Quit();
            System.Runtime.InteropServices.Marshal.ReleaseComObject(app);
            app = null;
            GC.Collect();
            GC.WaitForPendingFinalizers();
        }
    }

    public void ToExcelSheet(DataSet ds, string fileName)
    {
        Microsoft.Office.Interop.Excel.Application appExcel = new Microsoft.Office.Interop.Excel.Application();
        Microsoft.Office.Interop.Excel.Workbook workbookData = null;
        Microsoft.Office.Interop.Excel.Worksheet worksheetData;
        Microsoft.Office.Interop.Excel.Range range;
        try
        {
            workbookData = appExcel.Workbooks.Add(System.Reflection.Missing.Value);
            appExcel.DisplayAlerts = false;//不显示警告
                                           //xlApp.Visible = true;//excel是否可见
                                           //
                                           //for (int i = workbookData.Worksheets.Count; i > 0; i--)
                                           //{
                                           //    Microsoft.Office.Interop.Excel.Worksheet oWorksheet = (Microsoft.Office.Interop.Excel.Worksheet)workbookData.Worksheets.get_Item(i);
                                           //    oWorksheet.Select();
                                           //    oWorksheet.Delete();
                                           //}

            for (int k = 0; k < ds.Tables.Count; k++)
            {
                worksheetData = (Microsoft.Office.Interop.Excel.Worksheet)workbookData.Worksheets.Add(System.Reflection.Missing.Value, System.Reflection.Missing.Value, System.Reflection.Missing.Value, System.Reflection.Missing.Value);
                // testnum--;
                if (ds.Tables[k] != null)
                {
                    worksheetData.Name = ds.Tables[k].TableName;
                    //写入标题
                    for (int i = 0; i < ds.Tables[k].Columns.Count; i++)
                    {
                        worksheetData.Cells[1, i + 1] = ds.Tables[k].Columns[i].ColumnName;
                        range = (Microsoft.Office.Interop.Excel.Range)worksheetData.Cells[1, i + 1];
                        //range.Interior.ColorIndex = 15;
                        range.Font.Bold = true;
                        range.NumberFormatLocal = "@";//文本格式 
                        range.EntireColumn.AutoFit();//自动调整列宽 
                                                     // range.WrapText = true; //文本自动换行   
                        range.ColumnWidth = 15;
                    }
                    //写入数值
                    for (int r = 0; r < ds.Tables[k].Rows.Count; r++)
                    {
                        for (int i = 0; i < ds.Tables[k].Columns.Count; i++)
                        {
                            worksheetData.Cells[r + 2, i + 1] = ds.Tables[k].Rows[r][i];
                            //Range myrange = worksheetData.get_Range(worksheetData.Cells[r + 2, i + 1], worksheetData.Cells[r + 3, i + 2]);
                            //myrange.NumberFormatLocal = "@";//文本格式 
                            //// myrange.EntireColumn.AutoFit();//自动调整列宽 
                            ////   myrange.WrapText = true; //文本自动换行   
                            //myrange.ColumnWidth = 15;
                        }
                        //  rowRead++;
                        //System.Windows.Forms.Application.DoEvents();
                    }
                }
                worksheetData.Columns.EntireColumn.AutoFit();
                workbookData.Saved = true;
            }
        }
        catch (Exception ex) { }
        finally
        {
            workbookData.SaveCopyAs(fileName);
            workbookData.Close(false, System.Reflection.Missing.Value, System.Reflection.Missing.Value);
            appExcel.Quit();
            GC.Collect();
        }
    }

}