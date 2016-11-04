<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string cell = Util.GetSafeRequestValue(Request, "cellnumber", "13501177897");
        string verifyCode = Util.GetSafeRequestValue(Request, "verifycode", "653800");
        string token = Util.GetSafeRequestValue(Request, "token", "a8488dfb185d7719b88315b7bcfe5d85cbd7cbbe971d175a4e1079fe22ec5724519eed31");
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
                Point.ImportPointsByNumber(user.CellNumber.Trim());
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