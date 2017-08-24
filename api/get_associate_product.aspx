<%@ Page Language="C#" %>


<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        int productId = int.Parse(Util.GetSafeRequestValue(Request, "productid", "2"));
        Product product = new Product(productId);

        int weekendProductId = 0;
        int holidayProductId = 0;
        int workdayProductId = 0;

        if (product._fields["name"].ToString().StartsWith("南山"))
        {
            workdayProductId = 2;
            weekendProductId = 4;
            holidayProductId = 4;
        }
        if (product._fields["name"].ToString().StartsWith("八易"))
        {
            if (product._fields["name"].ToString().IndexOf("夜场")>=0)
            {
                workdayProductId = 8;
                weekendProductId = 8;
                holidayProductId = 13;
            }
            else
            {
                if (product._fields["name"].ToString().IndexOf("全天") >= 0)
                {
                    workdayProductId = 7;
                    weekendProductId = 10;
                    holidayProductId = 12;
                }
                else
                {
                    workdayProductId = 5;
                    weekendProductId = 9;
                    holidayProductId = 11;
                }
            }
        }
        if (product._fields["name"].ToString().StartsWith("乔波"))
        {
            if (product._fields["name"].ToString().IndexOf("夜场") >= 0)
            {
                workdayProductId = 7;
                weekendProductId = 7;
                holidayProductId = 7;
            }
            else
            {
                workdayProductId = 5;
                weekendProductId = 6;
                holidayProductId = 6;
            }
        }
        Product workdayProduct = new Product(workdayProductId);
        Product weekendProduct = new Product(weekendProductId);
        Product holidayProduct = new Product(holidayProductId);
        Response.Write("{\"status\":0, \"workday_product\":{\"id\":\"" + workdayProductId.ToString() + "\", \"title\": \"" + workdayProduct._fields["name"] + "\", \"price\": \"" + workdayProduct._fields["sale_price"].ToString() + "\"}, "
            + "\"weekend_product\":{\"id\": \"" + weekendProductId.ToString() + "\", \"title\": \"" + weekendProduct._fields["name"].ToString().Trim() + "\", \"price\": \"" + weekendProduct._fields["sale_price"].ToString() + "\"}, "
            + "\"holiday_product\": {\"id\": \"" + holidayProductId.ToString() + "\", \"title\": \"" +  holidayProduct._fields["name"].ToString() + "\", \"price\": \"" + holidayProduct._fields["sale_price"] +  "\"}}");
    }

</script>
