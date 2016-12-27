<%@ WebHandler Language="C#" Class="TestHandler" %>

using System;
using System.Web;
using System.Threading;
public class TestHandler : IHttpHandler {

    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        context.Response.Write("Hello World");
        Thread.Sleep(10000);
        context.Response.Write("Hello World2");

    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}