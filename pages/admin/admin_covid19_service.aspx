<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            dg.DataSource = GetData();
            dg.DataBind();
        }
    }

    public DataTable GetData()
    {
        DataTable dt = DBHelper.GetDataTable(" select users.nick as 昵称, users.cell_number as 手机号码, order_online.code as 卡号, equip_type as 类型, equip_brand as 品牌, equip_scale as 规格, "
            + " board_binder_brand as 单板固定器品牌, board_binder_color as 单板固定器颜色, send_item as 邮寄内容, wanlong_no as 万龙存板牌号,  "
            + " others_in_wanlong as 万龙除雪板外其他物品, express_company as 快递公司, waybill_no as 快递单号, order_online.pay_time as 支付时间, " 
            + " case when exists(select 'a' from card_detail where product_detail_id = 3 and card_detail.card_no = order_online.code and used = 1) then '已完成' when equip_brand is not null  then '已填信息' when  waybill_no is not null then '已发快递'  else '未开始' end as 状态  "
            + " from order_online "
            + " left join covid19_service on code = covid19_service.card_no left join users on users.open_id = order_online.open_id "
            + " where [id] in (select order_online_id from order_online_detail where product_id = 144) and pay_state = 1 and [type] = '服务卡' "
            + " order by order_online.[id] desc");
        return dt;
    }


</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:DataGrid ID="dg" runat="server" Width="100%" BackColor="White" BorderColor="#999999" BorderStyle="None" BorderWidth="1px" CellPadding="3" GridLines="Vertical" >
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
