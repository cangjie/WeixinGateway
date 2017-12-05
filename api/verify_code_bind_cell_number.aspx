<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string cell = Util.GetSafeRequestValue(Request, "cellnumber", "18601197897");
        string verifyCode = Util.GetSafeRequestValue(Request, "verifycode", "675733");
        string token = Util.GetSafeRequestValue(Request, "token", "45f71e433d329bb085fb99bb32bdaec81de76b16252c3fa47bf219980fa37cb2173cc06a");
        string fatherCellNumber = Util.GetSafeRequestValue(Request, "father_cell_number", "");
        if (Sms.CheckVerifyCode(cell, verifyCode))
        {
            WeixinUser user = new WeixinUser(WeixinUser.CheckToken(token));
            if (WeixinUser.CheckCellNumberHasNotBeenBinded(cell))
            {
                user.CellNumber = cell.Trim();
                user.VipLevel = 1;
                string fatherOpenId = WeixinUser.GetVipUserOpenIdByNumber(fatherCellNumber);
                if (!fatherOpenId.Trim().Equals(""))
                {
                    user.FatherOpenId = fatherOpenId;
                }
                //user.FatherOpenId = 
                //PointFile.ImportPointsFromUploadFiles(user.CellNumber.Trim());
                //Point.ImportPointsByNumber(user.CellNumber.Trim());
                Response.Write("{\"status\" : 0 , \"result\" : 1  }");
            }
            else
            {
                Response.Write("{\"status\" : 0 , \"result\" : 0 , \"error_message\" : \"cell number has been binded by another user.\"  }");
            }
        }
        else
        {
            Response.Write("{\"status\" : 0 , \"result\" : 0 , \"error_message\" : \"verify code is invalid.\"  }");
        }

    }
</script>