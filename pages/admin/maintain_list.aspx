<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {

    }

    public DataTable GetData()
    {
        DateTime start = DateTime.Parse(Util.GetSafeRequestValue(Request, "start", "2021-3-1"));
        DateTime end = DateTime.Parse(Util.GetSafeRequestValue(Request, "start", "2021-3-31"));
        DataTable dt = new DataTable();
        dt.Columns.Add("ID");
        dt.Columns.Add("店铺");
        dt.Columns.Add("手机");
        dt.Columns.Add("姓名");
        dt.Columns.Add("昵称");
        dt.Columns.Add("日期");
        dt.Columns.Add("时间");
        dt.Columns.Add("项目");
        dt.Columns.Add("金额");
        dt.Columns.Add("类型");
        dt.Columns.Add("品牌");
        dt.Columns.Add("系列");
        dt.Columns.Add("尺寸");
        dt.Columns.Add("年款");
        dt.Columns.Add("提取");
        dt.Columns.Add("收板");
        dt.Columns.Add("备注");
        dt.Columns.Add("渠道");
        DataTable dtOrder = DBHelper.GetDataTable(" select * from order_online where type = '服务' and pay_state = 1 "
            + " and create_date >= '" + start.ToShortDateString() + "' and create_date <= '" + end.ToShortDateString() + "' order by [id] desc ");
        foreach (DataRow drOrder in dtOrder.Rows)
        {
            DataRow dr = dt.NewRow();
            dr["ID"] = drOrder["id"].ToString().Trim();
            dr["店铺"] = drOrder["shop"].ToString().Trim();
            string cell = drOrder["cell_number"].ToString().Trim();

            if (cell.Equals(""))
            { 
            
            }

        }

        return dt;
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
