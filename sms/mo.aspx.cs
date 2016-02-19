using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

/// <summary>
/// 上行短信，接收用户的回复
/// </summary>
public partial class mo : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        string name = Request.Form["name"];  //在系统中配置的接收用户名
        string pwd = Request.Form["pwd"];   //在系统中配置的接收密码
        string args = Request.Form["args"]; //上行数据，根据文档4.1格式解析

        if (args.Contains("#@@#"))//多条上行一起推送过来的
        {
            string[] allmo = args.Split(new string[] { "#@@#" }, StringSplitOptions.RemoveEmptyEntries);//拆分成一条一条的信息，放到数组中
            for (int i = 0; i < allmo.Length; i++)
            {
                string[] mo = allmo[i].Split(new string[] { "#@#" }, StringSplitOptions.None);//这个地方要用None，空值不能移除
                //mo[0]  回复的手机号码
                //mo[1]  回复的内容
                //mo[2]  回复的时间
                //mo[3]  系统扩展码+发送时带的extno值  一般情况下账号的特服号即为系统扩展码。 如账号的特服号是 1001，发送时带的extno=888， mo[3]=1001888

                //将 上面信息插入数据库即可
                string sql = "insert into mo ";//写完整的sql语句，将数据插入到数据库
            }
        }
        else//只有一条上行信息
        {
            string[] mo = args.Split(new string[] { "#@#" }, StringSplitOptions.None);//这个地方要用None，空值不能移除
            //mo[0]  回复的手机号码
            //mo[1]  回复的内容
            //mo[2]  回复的时间
            //mo[3]  系统扩展码+发送时带的extno值  一般情况下账号的特服号即为系统扩展码。 如账号的特服号是 1001，发送时带的extno=888， mo[3]=1001888

            //将 上面信息插入数据库即可
            string sql = "insert into mo ";//写完整的sql语句，将数据插入到数据库
        }
    }
}