﻿<%@ Page Language="C#" %>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        string token = Util.GetSafeRequestValue(Request, "token", "c4fb9144da5fb1ebbbcf928242b0fa4565f4769866a5d1fd44a1294a2ad7fe333afb8f3a");
        string cartJson = Util.GetSafeRequestValue(Request, "cart", "{\"cart_array\" : [{ \"product_id\": \"5\", \"count\": \"1\" }, { \"product_id\": \"8\", \"count\": \"1\" }], \"memo\" : {\"rent\" : \"1\", \"use_date\" : \"2017/10/17\"   }}");
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
                newOrder.shop = p._fields["shop"].ToString();
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