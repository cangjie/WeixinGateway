<%@ Page Language="C#" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Net" %>
<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        CheckIfUserBind("oqrMvtySBUCd-r6-ZIivSwsmzr44");
    }

    public static string GetMd5(string str)
    {
        System.Security.Cryptography.MD5 md5 = System.Security.Cryptography.MD5.Create();
        byte[] bArr = md5.ComputeHash(Encoding.UTF8.GetBytes(str));
        string ret = "";
        foreach (byte b in bArr)
        {
            ret = ret + b.ToString("x").PadLeft(2,'0');
        }
        return ret;
    }

    public static bool CheckIfUserBind(string openId)
    {
        HttpWebRequest req = (HttpWebRequest)WebRequest.Create("http://www.luqinwenda.com/index.php?app=public&mod=Api&act=getUserOpenID&openID=" + openId);
        HttpWebResponse res = (HttpWebResponse)req.GetResponse();
        string str = (new StreamReader(res.GetResponseStream())).ReadToEnd();
        res.Close();
        req.Abort();
        if (str.Trim().Equals("﻿false"))
            return false;
        else
            return true;
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <%=GetMd5(Request["str"].Trim()) %>
    </div>
    </form>
</body>
</html>
