using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Net;
using System.Text;
using System.IO;
/// <summary>
/// Summary description for Sms
/// </summary>
public class Sms
{
    public DataRow _fields;

	public Sms()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    public Sms(int id)
    {
        DataTable dt = DBHelper.GetDataTable(" select * from sms where [id] = " + id.ToString());
        if (dt.Rows.Count == 0)
        {
            throw new Exception("Record is not exsit.");
        }
        else
        {
            _fields = dt.Rows[0];
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

    public string Send()
    {
        StringBuilder sms = new StringBuilder();
        sms.AppendFormat("accesskey={0}", "13501177897");
        sms.AppendFormat("&secret={0}", "3C770DA8172A4C374FB65068B69A");//登陆平台，管理中心--基本资料--接口密码（28位密文）；复制使用即可。
        sms.AppendFormat("&templateId={0}", _fields["template_id"].ToString().Trim());
        sms.AppendFormat("&content={0}", _fields["sms_content"].ToString().Trim());
        sms.AppendFormat("&mobile={0}", _fields["cell_number"].ToString().Trim());
        sms.AppendFormat("&sign={0}", "【易龙雪聚】");// 公司的简称或产品的简称都可以
        string resp = PushToWeb("http://api.1cloudsp.com/api/v2/single_send", sms.ToString(), Encoding.UTF8);
        string[] msg = resp.Split(',');

        string[,] updateParameters = {{"status", "int", "1"},
                                     {"send_time", "datetime", DateTime.Now.ToString()},
                                     {"return_message", "varchar", msg[1]}};
        string[,] keyParameter = { { "id", "int", _fields["id"].ToString().Trim() } };
        DBHelper.UpdateData("sms", 
            DBHelper.ConvertStringArryToKeyValuePairArray(updateParameters), 
            DBHelper.ConvertStringArryToKeyValuePairArray(keyParameter));

        if (msg[0] == "0")
        {
            return msg[1];
        }
        else
        {
            return "提交失败：错误信息=" + msg[1];
        }
        //return "";
    }

    public static int SaveSms(string cellNumber, string content, bool isVerify, string verifyCode, int templateId)
    {
        string[,] insertParameters = { { "cell_number", "varchar", cellNumber.Trim() },
                                     {"sms_content", "varchar", content.Trim()},
                                     {"is_verify", "int", (isVerify?1:0).ToString()},
                                     {"verify_code", "varchar", verifyCode.Trim()},
                                     {"status", "int", "0"},
                                     {"template_id", "int", templateId.ToString()} };
        int i = DBHelper.InsertData("sms", DBHelper.ConvertStringArryToKeyValuePairArray(insertParameters));

        if (i == 1)
        {
            DataTable dt = DBHelper.GetDataTable(" select max([id]) from sms ");
            if (dt.Rows.Count > 0)
            {
                i = int.Parse(dt.Rows[0][0].ToString());
            }
            else
            {
                i = 0;
            }
            dt.Dispose();
        }

        return i;
    }
    /*
    public static int SendSms(string cellNumber, string content)
    {
        int smsId = SaveSms(cellNumber, content, false, "");
        return smsId;
    }
    */
    public static int SendVerifiedSms(string cellNumber)
    {

        string verifyCode = CreateRandomCode(6);
        //您的验证码为@，请在规定的时间输入。【易龙雪聚】
        int smsId = SaveSms(cellNumber, verifyCode.Trim(), true, verifyCode, 144985);
        Sms sms = new Sms(smsId);
        sms.Send();
        return smsId;
    }

    public static string CreateRandomCode(int digit)
    {
        return (new Random()).Next(100000, 999999).ToString();
    }

    public static bool CheckVerifyCode(string cellNumber, string verifyCode)
    {
        DataTable dt = DBHelper.GetDataTable(" select top 1 * from sms where cell_number = '" + cellNumber.Trim()
            + "' and verify_code = '" + verifyCode.Trim() + "' and create_date >= DATEADD(MINUTE,-60,dbo.GetLocalDate(DEFAULT)) ");
        bool ret = false;
        if (dt.Rows.Count == 1)
            ret = true;
        dt.Dispose();
        return ret;
    }

}