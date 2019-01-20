using System;
using System.Collections.Generic;
using System.IO;
//using System.Linq;
using System.Web;

/// <summary>
/// 基础配置类
/// </summary>
namespace Com.Alipay
{
    public class Config
    {
        public static string alipay_public_key = @"C:\Users\cangj\Desktop\F2FPay_Demo_DotNet\WebSites\F2F-PAY\rsa_public_key.pem";


        //这里要配置没有经过的原始私钥

        //开发者私钥
        public static string merchant_private_key = @"C:\Users\cangj\Desktop\F2FPay_Demo_DotNet\WebSites\F2F-PAY\rsa_private_key_pkcs8.pem";

        //开发者公钥
        public static string merchant_public_key = @"C:\Users\cangj\Desktop\F2FPay_Demo_DotNet\WebSites\F2F-PAY\rsa_public_key.pem";

        //应用ID
        public static string appId = "2019011010661559";

        //合作伙伴ID：partnerID
        public static string pid = "此处填写账号PID（partner id）";


        //支付宝网关
        //public static string serverUrl = "https://openapi.alipay.com/gateway.do";
        public static string serverUrl = "http://fy.mch.weixin.semoor.cn/2.0/gateway.do";
        public static string mapiUrl = "https://mapi.alipay.com/gateway.do";
        public static string monitorUrl = "http://mcloudmonitor.com/gateway.do";

        //编码，无需修改
        public static string charset = "utf-8";
        //签名类型，支持RSA2（推荐！）、RSA
        //public static string sign_type = "RSA2";
        public static string sign_type = "RSA";
        //版本号，无需修改
        public static string version = "1.0";


        /// <summary>
        /// 公钥文件类型转换成纯文本类型
        /// </summary>
        /// <returns>过滤后的字符串类型公钥</returns>
        public static string getMerchantPublicKeyStr()
        {
            StreamReader sr = new StreamReader(merchant_public_key);
            string pubkey = sr.ReadToEnd();
            sr.Close();
            if (pubkey != null)
            {
                pubkey = pubkey.Replace("-----BEGIN PUBLIC KEY-----", "");
                pubkey = pubkey.Replace("-----END PUBLIC KEY-----", "");
                pubkey = pubkey.Replace("\r", "");
                pubkey = pubkey.Replace("\n", "");
            }
            return pubkey;
        }

        /// <summary>
        /// 私钥文件类型转换成纯文本类型
        /// </summary>
        /// <returns>过滤后的字符串类型私钥</returns>
        public static string getMerchantPriveteKeyStr()
        {
            StreamReader sr = new StreamReader(merchant_private_key);
            string pubkey = sr.ReadToEnd();
            sr.Close();
            if (pubkey != null)
            {
                pubkey = pubkey.Replace("-----BEGIN PUBLIC KEY-----", "");
                pubkey = pubkey.Replace("-----END PUBLIC KEY-----", "");
                pubkey = pubkey.Replace("\r", "");
                pubkey = pubkey.Replace("\n", "");
            }
            return pubkey;
        }

    }
}