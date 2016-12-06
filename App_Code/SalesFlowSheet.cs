using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Diagnostics;
using System.Data;

/// <summary>
/// Summary description for SalesFlowSheet
/// </summary>
public class SalesFlowSheet
{
    public static string[] fieldNameOrderType = { "订单类别" };
    public static string[] fieldNameFlowNumber = { "流水号" };
    public static string[] fieldNameCount = { "数量" };
    public static string[] fieldNameUnitPrice = { "零售价" };
    public static string[] fieldNameSalePrice = { "销售价", "零售价总价" };
    //未注明则等于零售价总价
    public static string[] fieldNameSaleSummary = { "实际成交金额", "实际成交总金额" };
    public static string[] fieldNameOrderPrice = { "总订单零售价" };
    public static string[] fieldNameOrderShouldPaidAmount = { "订单总金额" };
    public static string[] fieldNameDiscountRate = { "销售折扣", "总订单折扣" };
    public static string[] fieldNameDragonBallRate = { "易龙豆系数" };
    public static string[] fieldNameUsedDragonBallCount = { "抵扣易龙豆数量", "抵扣消费易龙豆", "使用易龙豆" };
    public static string[] fieldNameUsedTicketAmount = { "代金券总面值" };
    public static string[] fieldNameRealPaidAmount = { "抵扣完订单金额" };
    public static string[] fieldNameGenerateDragonBallCount = { "易龙豆数量", "本次生成易龙豆" };
    public static string[] fieldNameNumber = { "电话" };
    public static string[] fieldNameMemberName = { "会员名" };
    public static string[] fieldNameGoodType = { "品类" };
    public static string[] fieldNameGoodBrand = { "品牌" };
    public static string[] fieldNameGoodStyle = { "款式" };
    public static string[] fieldNameOrderDate = { "日期" };

    public int fieldPositionOrderType = -1;
    public int fieldPositionFlowNumber = -1;
    public int fieldPositionCount = -1;
    public int fieldPositionUnitPrice = -1;
    public int fieldPositionSalePrice = -1;
    public int fieldPositionSaleSummary = -1;
    public int fieldPositionOrderPrice = -1;
    public int fieldPositionDiscountRate = -1;
    public int fieldPositionDragonBallRate = -1;
    public int fieldPositionUsedDragonBallCount = -1;
    public int fieldPositionUsedTicketAmount = -1;
    public int fieldPositionRealPaidAmount = -1;
    public int fieldPositionGenerateDragonBallCount = -1;
    public int fieldPositionOrderShouldPaidAmount = -1;
    public int fieldPositionNumber = -1;
    public int fieldPositionMemberName = -1;
    public int fieldPositionGoodType = -1;
    public int fieldPositionGoodBrand = -1;
    public int fieldPositionGoodStyle = -1;
    public int fieldPositionOrderDate = -1;
    public string filePath = "";

    public Microsoft.Office.Interop.Excel.Application app;
    public Microsoft.Office.Interop.Excel.Sheets sheets;
    public Microsoft.Office.Interop.Excel.Worksheet worksheet;
    public Microsoft.Office.Interop.Excel.Workbook workbook = null;
    public object oMissiong = System.Reflection.Missing.Value;
    public int fieldsCount;
    public int rowsCount;
    private Stopwatch wath = new Stopwatch();

    public SalesFlowSheet(string excelPath)
    {
        filePath = excelPath;
        app = new Microsoft.Office.Interop.Excel.Application();
        wath.Start();
        try
        {
            if (app != null)
            {
                workbook = app.Workbooks.Open(filePath, oMissiong, oMissiong, oMissiong, oMissiong, oMissiong, oMissiong, oMissiong, oMissiong, oMissiong, oMissiong, oMissiong, oMissiong, oMissiong, oMissiong);
                //将数据读入到DataTable中——Start   
                sheets = workbook.Worksheets;
                worksheet = (Microsoft.Office.Interop.Excel.Worksheet)sheets.get_Item(1);
                fieldsCount = worksheet.UsedRange.Columns.Count;
                rowsCount = worksheet.UsedRange.Rows.Count;
                SetFieldsPosition();
            }

        }
        catch
        {

        }

    }

    ~SalesFlowSheet()
    {
        Dispose();
    }

    public void Dispose()
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
        wath.Stop();
    }

    public void SetFieldsPosition()
    {
        Microsoft.Office.Interop.Excel.Range range;
        for (int i = 1; i <= fieldsCount; i++)
        {
            range = (Microsoft.Office.Interop.Excel.Range)worksheet.Cells[1, i];
            string currentFieldName = range.Text.ToString().Replace("\n", "").Replace("\r", "").Trim();
            foreach (string s in fieldNameFlowNumber)
            {
                if (currentFieldName.Equals(s))
                {
                    fieldPositionFlowNumber = i;
                    break;
                }
            }
            foreach (string s in fieldNameCount)
            {
                if (currentFieldName.Equals(s))
                {
                    fieldPositionCount = i;
                    break;
                }
            }
            foreach (string s in fieldNameUnitPrice)
            {
                if (currentFieldName.Equals(s))
                {
                    fieldPositionUnitPrice = i;
                    break;
                }
            }
            foreach (string s in fieldNameSalePrice)
            {
                if (currentFieldName.Equals(s))
                {
                    fieldPositionSalePrice = i;
                    break;
                }
            }
            foreach (string s in fieldNameSaleSummary)
            {
                if (currentFieldName.Equals(s))
                {
                    fieldPositionSaleSummary = i;
                    break;
                }
            }
            foreach (string s in fieldNameOrderPrice)
            {
                if (currentFieldName.Equals(s))
                {
                    fieldPositionOrderPrice = i;
                    break;
                }
            }
            foreach (string s in fieldNameDiscountRate)
            {
                if (currentFieldName.Equals(s))
                {
                    fieldPositionDiscountRate = i;
                    break;
                }
            }
            foreach (string s in fieldNameDragonBallRate)
            {
                if (currentFieldName.Equals(s))
                {
                    fieldPositionDragonBallRate = i;
                    break;
                }
            }
            foreach (string s in fieldNameUsedDragonBallCount)
            {
                if (currentFieldName.Equals(s))
                {
                    fieldPositionUsedDragonBallCount = i;
                    break;
                }
            }
            foreach (string s in fieldNameUsedTicketAmount)
            {
                if (currentFieldName.Equals(s))
                {
                    fieldPositionUsedTicketAmount = i;
                    break;
                }
            }
            foreach (string s in fieldNameRealPaidAmount)
            {
                if (currentFieldName.Equals(s))
                {
                    fieldPositionRealPaidAmount = i;
                    break;
                }
            }
            foreach (string s in fieldNameGenerateDragonBallCount)
            {
                if (currentFieldName.Equals(s))
                {
                    fieldPositionGenerateDragonBallCount = i;
                    break;
                }
            }
            foreach (string s in fieldNameOrderShouldPaidAmount)
            {
                if (currentFieldName.Equals(s))
                {
                    fieldPositionOrderShouldPaidAmount = i;
                    break;
                }
            }
            foreach (string s in fieldNameNumber)
            {
                if (currentFieldName.Equals(s))
                {
                    fieldPositionNumber = i;
                }
            }
            foreach (string s in fieldNameMemberName)
            {
                if (currentFieldName.Equals(s))
                {
                    fieldPositionMemberName = i;
                }
            }
            foreach (string s in fieldNameGoodType)
            {
                if (currentFieldName.Equals(s))
                {
                    fieldPositionGoodType = i;
                }
            }
            foreach (string s in fieldNameGoodBrand)
            {
                if (currentFieldName.Equals(s))
                {
                    fieldPositionGoodBrand = i;
                }
            }
            foreach (string s in fieldNameGoodStyle)
            {
                if (currentFieldName.Equals(s))
                {
                    fieldPositionGoodStyle = i;
                }
            }
            foreach (string s in fieldNameOrderDate)
            {
                if (currentFieldName.Equals(s))
                {
                    fieldPositionOrderDate = i;
                }
            }
            foreach (string s in fieldNameOrderType)
            {
                if (currentFieldName.Equals(s))
                {
                    fieldPositionOrderType = i;
                }
            }
        }

    }

    public bool HaveDealed(int i)
    {
        bool dealed = true;
        try
        {
            if (fieldPositionDragonBallRate != -1)
            {
                if (GetCellText(i, fieldPositionDragonBallRate).Trim().Equals(""))
                {
                    dealed = false;
                }
            }
        }
        catch
        {

        }
        return dealed;
    }


    public void FillDragonBallBlank()
    {
        if (fieldPositionFlowNumber == -1)
            return;
        for (int i = 2; i <= rowsCount; i++)
        {
            string flowNumber = GetFlowNumber(i);
            if (flowNumber.Trim().Equals("") || flowNumber.Trim().Equals("0"))
                break;
            OrderDetail firstOrderDetail = GetOrderDetail(i);
            if ( firstOrderDetail.CanImport )
            {
                Order order = new Order();
                order.flowNumber = flowNumber;
                order.startIndex = i;
                for (int j = i ; (GetFlowNumber(j).Trim().Equals(order.flowNumber.Trim()) || GetFlowNumber(j).Trim().Equals("")) && j <= rowsCount ; j++)
                {
                    i = j;
                    OrderDetail orderDetail = GetOrderDetail(j);
                    if (orderDetail.IsValid)
                    {
                        order.AddItem(orderDetail);
                    }
                }
                if (fieldPositionOrderPrice != -1)
                {
                    WriteBackToExcel(order.startIndex, fieldPositionOrderPrice, Math.Round(order.OrderPrice, 2).ToString());
                }

                if (fieldPositionOrderShouldPaidAmount != -1)
                {
                    WriteBackToExcel(order.startIndex, fieldPositionOrderShouldPaidAmount, Math.Round(order.OrderShouldPaidAmount, 2).ToString());
                }
                if (fieldPositionDiscountRate != -1)
                {
                    WriteBackToExcel(order.startIndex, fieldPositionDiscountRate, Math.Round(order.DisCountRate, 2).ToString());
                }
                if (fieldPositionDragonBallRate != -1)
                {
                    WriteBackToExcel(order.startIndex, fieldPositionDragonBallRate, Math.Round(order.DragonBallRate, 2).ToString());
                }
                if (fieldPositionGenerateDragonBallCount != -1)
                {
                    WriteBackToExcel(order.startIndex, fieldPositionGenerateDragonBallCount, ((int)order.GenerateDraonBallCount).ToString());
                }
                workbook.Save();
                order.Save();
            }
        }
        
    }


    public static bool HasImported(string flowNumber)
    {
        bool hasImported = false;
        DataTable dt = DBHelper.GetDataTable(" select * from orders where flow_number = '" + flowNumber.Replace("'", "") + "' ");
        if (dt.Rows.Count > 0)
            hasImported = true;
        dt.Dispose();
        return hasImported;
    }

    public void WriteBackToExcel(int i, int j, string content)
    {
        worksheet.Cells[i, j] = (object)content.Trim();
        Microsoft.Office.Interop.Excel.Range range = (Microsoft.Office.Interop.Excel.Range)worksheet.Cells[i, j];
        range.Font.Color = 0x0000FF;
        range.Font.Bold = true;

    }

    public string GetFlowNumber(int i)
    {
        return GetCellText(i, fieldPositionFlowNumber).Trim();
    }

    public string GetCellText(int i, int j)
    {
        return ((Microsoft.Office.Interop.Excel.Range)worksheet.Cells[i, j]).Text.ToString().Trim();
    }

    public OrderDetail GetOrderDetail(int i)
    {
        OrderDetail orderDetail = new OrderDetail();

        if (fieldPositionUnitPrice != -1)
        {
            try
            {
                orderDetail.unitPrice = float.Parse(GetCellText(i, fieldPositionUnitPrice));
            }
            catch
            {
                orderDetail.unitPrice = 0;
            }
        }

        if (fieldPositionCount != -1)
        {
            try
            {
                orderDetail.count = int.Parse(GetCellText(i, fieldPositionCount));
                if (orderDetail.count == 0)
                    throw new Exception();
            }
            catch
            {
                orderDetail.count = 1;
            }
        }

        if (fieldPositionSalePrice != -1)
        {
            try
            {
                orderDetail.salePrice = float.Parse(GetCellText(i, fieldPositionSalePrice));
                if (orderDetail.salePrice == 0)
                    throw new Exception();
            }
            catch
            {
                orderDetail.salePrice = orderDetail.unitPrice * orderDetail.count;
            }
        }
        if (fieldPositionSaleSummary != -1)
        {
            try
            {
                orderDetail.saleSummary = float.Parse(GetCellText(i, fieldPositionSaleSummary));
            }
            catch
            {
                orderDetail.saleSummary = orderDetail.salePrice;
            }
        }
        else
        {
            orderDetail.saleSummary = orderDetail.salePrice;
        }
        if (fieldPositionUsedDragonBallCount != -1)
        {
            try
            {
                orderDetail.usedDragonBallCount = int.Parse(GetCellText(i, fieldPositionUsedDragonBallCount));
            }
            catch
            {

            }
        }
        if (fieldPositionUsedTicketAmount != -1)
        {
            try
            {
                orderDetail.usedTicketAmount = double.Parse(GetCellText(i, fieldPositionUsedTicketAmount));
            }
            catch
            {

            }
        }
        if (fieldPositionNumber != -1)
        {
            orderDetail.cellNumber = GetCellText(i, fieldPositionNumber);
        }
        if (fieldPositionMemberName != -1)
        {
            orderDetail.memberName = GetCellText(i, fieldPositionMemberName);
        }
        if (fieldPositionGoodType != -1)
        {
            orderDetail.goodName = GetCellText(i, fieldPositionGoodType);
        }
        if (fieldPositionGoodBrand != -1)
        {
            orderDetail.goodName = orderDetail.goodName + " " + GetCellText(i, fieldPositionGoodBrand);
        }
        if (fieldPositionGoodStyle != -1)
        {
            orderDetail.goodName = orderDetail.goodName + " " + GetCellText(i, fieldPositionGoodStyle);
        }
        try
        {
            if (fieldPositionOrderDate != -1)
            {
                orderDetail.orderDate = DateTime.Parse(GetCellText(i, fieldPositionOrderDate));
            }
        }
        catch
        {

        }
        if (fieldPositionOrderType != -1)
        {
            orderDetail.orderType = GetCellText(i, fieldPositionOrderType);
        }
        return orderDetail;
    }
}