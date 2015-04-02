<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string requestOpenid = ((Request["openid"] == null) ? "" : Request["openid"].Trim());
        DateTime now = DateTime.Now;
        now = now.AddMinutes(-1);

        string sql = " select count(*) , WxLoginRequest_openid  from WxLoginRequest where WxLoginRequest_deal = 0 and wxloginrequest_crt > '" + now.ToString() + "' ";
        if (!requestOpenid.Equals(""))
        {
            sql = sql + " and  WxLoginRequest_openid = '" + requestOpenid.Trim() + "'  "; 
        }
        sql = sql + " group by WxLoginRequest_openid ";

        SqlDataAdapter da = new SqlDataAdapter(sql, System.Configuration.ConfigurationSettings.AppSettings["constr"].Trim());
        DataTable dt = new DataTable();
        da.Fill(dt);
        da.Dispose();

        string openId = "";

        if (requestOpenid.Trim().Equals(""))
        {

            if (dt.Rows.Count == 1)
            {
                openId = dt.Rows[0][1].ToString().Trim();
            }
        }
        else
        {
            if (dt.Rows.Count >= 1)
            {
                openId = dt.Rows[0][1].ToString().Trim();
            }
        }
        dt.Dispose();

        if (!openId.Equals(""))
        {
            SqlConnection conn = new SqlConnection(System.Configuration.ConfigurationSettings.AppSettings["constr"].Trim());
            SqlCommand cmd = new SqlCommand(" update WxLoginRequest set WxLoginRequest_deal = 1, WxLoginRequest_upd = getdate() where WxLoginRequest_openid = '" + openId.Trim()+"'", conn);
            conn.Open();
            cmd.ExecuteNonQuery();
            conn.Close();
            cmd.Dispose();
            conn.Dispose();
        }

        Response.Write("{\"status\":0,\"openid\":\"" + openId.Trim() + "\" }");
        
    }
</script>