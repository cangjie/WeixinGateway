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
            if (product._fields["name"].ToString().IndexOf("半天") >= 0)
            {
                workdayProductId = 17;
                weekendProductId = 18;
                holidayProductId = 18;
            }
            else
            {
                if (product._fields["name"].ToString().IndexOf("下午") >= 0)
                {
                    workdayProductId = 26;
                    weekendProductId = 25;
                    holidayProductId = 25;
                }
                else
                {
                    if (product._fields["name"].ToString().IndexOf("夜场") >= 0)
                    {
                        workdayProductId = 24;
                        weekendProductId = 24;
                        holidayProductId = 24;
                    }
                    else
                    {
                        workdayProductId = 2;
                        weekendProductId = 4;
                        holidayProductId = 4;
                    }
                }

            }
        }

        if (product._fields["shop"].ToString().Equals("八易"))
        {

            if (product._fields["name"].ToString().IndexOf("夜场")>=0)
            {
                if (product._fields["name"].ToString().IndexOf("自助餐") >= 0)
                {
                    workdayProductId = 34;
                    weekendProductId = 38;
                    holidayProductId = 38;
                }
                else
                {
                    workdayProductId = 33;
                    weekendProductId = 37;
                    holidayProductId = 37;
                }
                
            }
            else
            {
                if (product._fields["name"].ToString().IndexOf("全天") >= 0)
                {
                    workdayProductId = 32;
                    weekendProductId = 36;
                    holidayProductId = 36;
                }
                else
                {
                    workdayProductId = 31;
                    weekendProductId = 35;
                    holidayProductId = 35;
                }
            }
        }
        if (product._fields["name"].ToString().StartsWith("乔波"))
        {
            if (product._fields["name"].ToString().IndexOf("夜场") >= 0)
            {
                if (product._fields["name"].ToString().IndexOf("租板") >= 0)
                {
                    workdayProductId = 11;
                    weekendProductId = 11;
                    holidayProductId = 11;
                }
                else
                {
                    workdayProductId = 7;
                    weekendProductId = 7;
                    holidayProductId = 7;

                }

            }
            else
            {
                if (product._fields["name"].ToString().IndexOf("租板") >= 0)
                {
                    workdayProductId = 9;
                    weekendProductId = 10;
                    holidayProductId = 10;
                }
                else
                {
                    workdayProductId = 5;
                    weekendProductId = 6;
                    holidayProductId = 6;
                }

            }
        }
        if (product._fields["name"].ToString().StartsWith("万龙"))
        {
            workdayProductId = productId;
            weekendProductId = productId;
            holidayProductId = productId;
        }
        Product workdayProduct = new Product(workdayProductId);
        Product weekendProduct = new Product(weekendProductId);
        Product holidayProduct = new Product(holidayProductId);
        Response.Write("{\"status\":0, \"workday_product\":{\"id\":\"" + workdayProductId.ToString() + "\", \"title\": \"" + workdayProduct._fields["name"] + "\", \"price\": \"" + workdayProduct._fields["sale_price"].ToString() + "\"}, "
            + "\"weekend_product\":{\"id\": \"" + weekendProductId.ToString() + "\", \"title\": \"" + weekendProduct._fields["name"].ToString().Trim() + "\", \"price\": \"" + weekendProduct._fields["sale_price"].ToString() + "\"}, "
            + "\"holiday_product\": {\"id\": \"" + holidayProductId.ToString() + "\", \"title\": \"" +  holidayProduct._fields["name"].ToString() + "\", \"price\": \"" + holidayProduct._fields["sale_price"] +  "\"}}");
    }

</script>
