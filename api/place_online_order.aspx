<%@ Page Language="C#" %>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        string token = Util.GetSafeRequestValue(Request, "token", "43d806b4f81884fcbcce63a3b9f94f47b80384ba5b1fc31165283a9a84ac3ffa88a3ece3");
        string cartJson = Util.GetSafeRequestValue(Request, "cart", "{\"cart_array\" : [{\"product_id\" : \"1\", \"count\" : \"3\" },{\"product_id\" : \"2\", \"count\" : \"1\" }], \"memo\" :{\"rent\" : \"\" , \"use_date\" : \"2017-1-5\" } }");
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