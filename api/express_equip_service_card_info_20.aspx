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
        string fromResort = Util.GetSimpleJsonValueByKey(inputRawString, "from_resort");
        string equipType = Util.GetSimpleJsonValueByKey(inputRawString, "equip_type").Trim();
        string equipBrand = Util.GetSimpleJsonValueByKey(inputRawString, "equip_brand").Trim();
        string equipScale = Util.GetSimpleJsonValueByKey(inputRawString, "equip_scale").Trim();
        string associates = Util.GetSimpleJsonValueByKey(inputRawString, "associates");
        string vouucherNo = Util.GetSimpleJsonValueByKey(inputRawString, "voucher_no");
        string address = Util.GetSimpleJsonValueByKey(inputRawString, "address");
        string receiverName = Util.GetSimpleJsonValueByKey(inputRawString, "receiver_name");
        string receiverCell = Util.GetSimpleJsonValueByKey(inputRawString, "receiver_cell");
        string expressCompany = Util.GetSimpleJsonValueByKey(inputRawString, "express_company");
        string waybillNo = Util.GetSimpleJsonValueByKey(inputRawString, "waybill_no");



        string ownerOpenId = WeixinUser.CheckToken(token);
        Card card = new Card(cardNo);
        if (!card.Owner.OpenId.Trim().Equals(ownerOpenId.Trim()))
        {
            Response.Write("{\"status\": 1, \"error_message\": \"Token is invalid.\"}");
        }
        DataTable dt = DBHelper.GetDataTable(" select * from covid19_service where card_no = '" + cardNo.Trim() + "' ");
        int i = 0;
        if (dt.Rows.Count == 0)
        {
            i = DBHelper.InsertData("covid19_express_trans", new string[,] {
                {"card_no", "varchar", cardNo.Trim()},
                {"from_resort", "varchar", fromResort.Trim()},
                {"equip_type", "varchar", equipType.Trim() },
                {"equip_brand", "varchar", equipBrand.Trim() },
                {"equip_scale", "varchar", equipScale.Trim() },
                {"voucher_no", "varchar", vouucherNo.Trim() },
                {"associates", "varchar", associates.Trim() },
                {"address", "varchar", address.Trim() },
                {"receiver_name", "varchar", receiverName.Trim() },
                {"receiver_cell", "varchar", receiverCell.Trim() },
                {"waybill_no", "varchar", waybillNo.Trim() },
                {"express_company", "varchar", expressCompany.Trim() }
            });
        }
        else
        {
            i = DBHelper.UpdateData("covid19_express_trans", new string[,] {
                {"from_resort", "varchar", fromResort.Trim()},
                {"equip_type", "varchar", equipType.Trim() },
                {"equip_brand", "varchar", equipBrand.Trim() },
                {"equip_scale", "varchar", equipScale.Trim() },
                {"voucher_no", "varchar", vouucherNo.Trim() },
                {"associates", "varchar", associates.Trim() },
                {"address", "varchar", address.Trim() },
                {"receiver_name", "varchar", receiverName.Trim() },
                {"receiver_cell", "varchar", receiverCell.Trim() },
                {"waybill_no", "varchar", waybillNo.Trim() },
                {"express_company", "varchar", expressCompany.Trim() }
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