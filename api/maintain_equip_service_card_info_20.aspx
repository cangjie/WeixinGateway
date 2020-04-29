<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.IO" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        Stream inputRawStream = Request.InputStream;
        StreamReader sr = new StreamReader(inputRawStream, Encoding.UTF8);
        string inputRawString = sr.ReadToEnd().Replace("'", "");
        sr.Close();
        inputRawStream.Close();
        string token = Util.GetSimpleJsonValueByKey(inputRawString, "token").Trim();
        string cardNo = Util.GetSimpleJsonValueByKey(inputRawString, "card_no").Trim();
        string equipType = Util.GetSimpleJsonValueByKey(inputRawString, "equip_type").Trim();
        string equipBrand = Util.GetSimpleJsonValueByKey(inputRawString, "equip_brand").Trim();
        string equipScale = Util.GetSimpleJsonValueByKey(inputRawString, "equip_scale").Trim();
        string boardBinderBrand = Util.GetSimpleJsonValueByKey(inputRawString, "board_binder_brand").Trim();
        string boardBinderColor = Util.GetSimpleJsonValueByKey(inputRawString, "board_binder_color").Trim();
        string sendItem = Util.GetSimpleJsonValueByKey(inputRawString, "send_item");
        string wanlongNo = Util.GetSimpleJsonValueByKey(inputRawString, "wanlong_no");
        string othersInWanlong = Util.GetSimpleJsonValueByKey(inputRawString, "others_in_wanlong");
        string expressCompany = Util.GetSimpleJsonValueByKey(inputRawString, "express_company");
        string waybillNo = Util.GetSimpleJsonValueByKey(inputRawString, "waybill_no");
        string ownerOpenId = WeixinUser.CheckToken(token);
        string contactName = Util.GetSimpleJsonValueByKey(inputRawString, "contact_name");
        string cell = Util.GetSimpleJsonValueByKey(inputRawString, "cell");
        string address = Util.GetSimpleJsonValueByKey(inputRawString, "address");
        Card card = new Card(cardNo);
        if (!card.Owner.OpenId.Trim().Equals(ownerOpenId.Trim()))
        {
            Response.Write("{\"status\": 1, \"error_message\": \"Token is invalid.\"}");
        }
        DataTable dt = DBHelper.GetDataTable(" select * from covid19_service where card_no = '" + cardNo.Trim() + "' ");
        int i = 0;
        if (dt.Rows.Count == 0)
        {
            i = DBHelper.InsertData("covid19_service", new string[,] {
                {"card_no", "varchar", cardNo.Trim()},
                {"equip_type", "varchar", equipType.Trim() },
                {"equip_brand", "varchar", equipBrand.Trim() },
                {"equip_scale", "varchar", equipScale.Trim() },
                {"board_binder_brand", "varchar", boardBinderBrand.Trim() },
                {"board_binder_color", "varchar", boardBinderColor.Trim() },
                {"send_item", "varchar", sendItem.Trim() },
                {"wanlong_no", "varchar", wanlongNo.Trim() },
                {"others_in_wanlong", "varchar", othersInWanlong.Trim() },
                {"waybill_no", "varchar", waybillNo.Trim() },
                {"express_company", "varchar", expressCompany.Trim() },
                {"address", "varchar", address.Trim() },
                {"cell", "varchar", cell.Trim() },
                {"contactName", "varchar", contactName.Trim() }
            });
        }
        else
        {
            i = DBHelper.UpdateData("covid19_service", new string[,] {
                {"equip_type", "varchar", equipType.Trim() },
                {"equip_brand", "varchar", equipBrand.Trim() },
                {"equip_scale", "varchar", equipScale.Trim() },
                {"board_binder_brand", "varchar", boardBinderBrand.Trim() },
                {"board_binder_color", "varchar", boardBinderColor.Trim() },
                {"send_item", "varchar", sendItem.Trim() },
                {"wanlong_no", "varchar", wanlongNo.Trim() },
                {"others_in_wanlong", "varchar", othersInWanlong.Trim() },
                {"waybill_no", "varchar", waybillNo.Trim() },
                {"express_company", "varchar", expressCompany.Trim() },
                {"address", "varchar", address.Trim() },
                {"cell", "varchar", cell.Trim() },
                {"contactName", "varchar", contactName.Trim() }
            }, new string[,] { { "card_no", "varchar", card.Code.Trim() } }, Util.conStr.Trim());
        }
        dt.Dispose();
        if (i == 0)
        {
            Response.Write("{\"status\": 1, \"error_message\": \"DB operation error.\"}");
        }
        else
        {
            Response.Write("{\"status\": 0}");

        }
        //Response.Write(inputRawString.Trim());
    }
</script>