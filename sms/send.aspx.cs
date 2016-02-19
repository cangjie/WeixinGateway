using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Net;
using System.IO;

/// <summary>
/// 短信发送
/// </summary>
public partial class send : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        StringBuilder sms = new StringBuilder();
        sms.AppendFormat("name={0}", "13501177897");
        sms.AppendFormat("&pwd={0}", "3C770DA8172A4C374FB65068B69A");//登陆平台，管理中心--基本资料--接口密码（28位密文）；复制使用即可。
        sms.AppendFormat("&content={0}", this.TextBox2.Text);
        sms.AppendFormat("&mobile={0}", this.TextBox1.Text);
        sms.AppendFormat("&sign={0}", "易龙雪聚");// 公司的简称或产品的简称都可以
        sms.Append("&type=pt");
        string resp = PushToWeb("http://web.cr6868.com/asmx/smsservice.aspx", sms.ToString(), Encoding.UTF8);
        string[] msg = resp.Split(',');
        if (msg[0] == "0")
        {
            this.Label1.Text = "提交成功：SendID=" + msg[1];
        }
        else
        {
            this.Label1.Text = "提交失败：错误信息=" + msg[1];
        }
    }

    private string PushToWeb(string weburl, string data, Encoding encode)
    {
        byte[] byteArray = encode.GetBytes(data);

        HttpWebRequest webRequest = (HttpWebRequest)WebRequest.Create(new Uri(weburl));
        webRequest.Method = "POST";
        webRequest.ContentType = "application/x-www-form-urlencoded";
        webRequest.ContentLength = byteArray.Length;
        Stream newStream = webRequest.GetRequestStream();
        newStream.Write(byteArray, 0, byteArray.Length);
        newStream.Close();

        //接收返回信息：
        HttpWebResponse response = (HttpWebResponse)webRequest.GetResponse();
        StreamReader aspx = new StreamReader(response.GetResponseStream(), encode);
        return aspx.ReadToEnd();
    }
}