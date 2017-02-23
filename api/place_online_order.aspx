<%@ Page Language="C#" %>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        string token = Util.GetSafeRequestValue(Request, "token", "67c2db97eec818d98ffb03343c3131ff0e20aea1a38ce63cf8a9a4777f89f12fa717cd9e");
        string cartJson = Util.GetSafeRequestValue(Request, "cart", "{\"cart_array\" : [{\"product_id\" : \"1\", \"count\" : \"3\", \"memo\": {\"name\": \"aaa\", \"cell\": \"bbb\"} },{\"product_id\" : \"2\", \"count\" : \"1\" }], \"memo\" :{\"rent\" : \"\" , \"use_date\" : \"2017-1-5\" } }");
        string openId = WeixinUser.CheckToken(token);
        if (openId.Trim().Equals(""))
        {
            Response.Write("{\"status\" : \"1\", \"error_message\":\"token is invalid.\"}");
        }
        else
        {
            Dictionary<string, object>[] cartItemArr = Util.GetObjectArrayFromJsonByKey(cartJson, "cart_array");
            OnlineOrder newOrder = new OnlineOrder();
            foreach (Dictionary<string, object> item in cartItemArr)
            {
                OnlineOrderDetail detail = new OnlineOrderDetail();
                Product p = new Product(int.Parse(item["product_id"].ToString()));
                detail.productId = int.Parse(p._fields["id"].ToString());
                detail.productName = p._fields["name"].ToString();
                detail.price = double.Parse(p._fields["sale_price"].ToString());
                detail.count = int.Parse(item["count"].ToString());
                try
                {
                    detail.memo = Util.GetSimpleJsonStringFromKeyPairArray(((Dictionary<string, object>)item["memo"]).ToArray());
                }
                catch
                {
                    detail.memo = "";
                }
                newOrder.AddADetail(detail);
                newOrder.Type = p._fields["type"].ToString();
            }
            Dictionary<string, object> memoJsonObject = (Dictionary<string, object>)Util.GetObjectFromJsonByKey(cartJson, "memo");
            if (memoJsonObject != null)
            {
                newOrder.Memo = Util.GetSimpleJsonStringFromKeyPairArray(memoJsonObject.ToArray());
            }
            else
                newOrder.Memo = "";
            int orderId = newOrder.Place(openId);
            Response.Write("{\"status\" : \"0\", \"order_id\" : \"" + orderId.ToString() + "\" }");
        }
    }
</script>