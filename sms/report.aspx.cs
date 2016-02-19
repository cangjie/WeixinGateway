using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

/// <summary>
/// 短信状态接收
/// </summary>
public partial class report : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string name = Request.Form["name"];     //在系统中配置的接收用户名
        string pwd = Request.Form["pwd"];       //在系统中配置的接收密码
        string sendid = Request.Form["sendid"]; //提交短信时，返回的SendID，查看文档1.3
        string time = Request.Form["time"];     //报告时间
        string mobile = Request.Form["mobile"]; //手机号码，可能是多个号码，也可能是一个号。多个号码时格式为 13563366666,18655556666  英文逗号分隔
        string state = Request.Form["state"];   //手机的状态

        //同一个SendID 且 同一个状态  多个号码可能会一次推送过来。
        //同一个SendId 不同的状态，会分批推送过来

        //将以上数据更新到数据库即可
        string sql = "update db";//写完整的sql语句更新状态
    }
}