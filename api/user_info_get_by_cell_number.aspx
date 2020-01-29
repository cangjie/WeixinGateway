<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        DataTable dt = DBHelper.GetDataTable(" select * from users where ISNUMERIC(open_id) = 0 and  cell_number = '" 
            + Util.GetSafeRequestValue(Request, "cell", "13501177897") + "' and cell_number <> ''");
        if (dt.Rows.Count == 0)
        {
            Response.Write("{\"status\": 1, \"message\": \"The user is not exists.\"}");
        }
        else
        {
            
            string userInfoJson = "";
            foreach (DataColumn c in dt.Columns)
            {
                userInfoJson = userInfoJson + ((!userInfoJson.Trim().Equals(""))? ", " : "  ") + "\"" + c.Caption.Trim() + "\": \"" + dt.Rows[0][c].ToString() + "\" "; 
            }
            Response.Write("{\"status\": 0, \"user_info\": {" + userInfoJson.Trim() + " } }");

        }
    }
</script>