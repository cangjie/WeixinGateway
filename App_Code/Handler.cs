using System;

using System.Collections.Generic;

using System.Linq;

using System.Threading;

using System.Web;

namespace WebApplication2

{

    public class MyHandler : IHttpHandler

    {

        /// <summary>

        /// 消息下发请求

        /// </summary>

        /// <param name="context"></param>

        public void ProcessRequest(HttpContext context)

        {



            context.Response.Cache.SetCacheability(HttpCacheability.NoCache);

            List<MyAsyncResult> userlist = MyAsyncHandler.Queue;





            string sessionId = context.Request.QueryString["sessionId"];



            string message = context.Request.QueryString["message"] + "    " + userlist.Count.ToString();

            List<string> error = new List<string>();

            foreach (MyAsyncResult res in userlist)

            {



                if (res.SessionId != sessionId)

                {

                    res.Message = message;

                    try

                    {



                        res.SetCompleted(true);

                    }

                    catch (Exception)

                    {





                        error.Add(res.SessionId);

                    }

                }

            }

            foreach (var v in error)

            {

                userlist.RemoveAll(fun => fun.SessionId == v);

            }

        }

        public bool IsReusable

        {

            get { return true; }

        }

    }

    public class MyAsyncHandler : IHttpAsyncHandler

    {

        public static List<MyAsyncResult> Queue = new List<MyAsyncResult>();

        public void ProcessRequest(HttpContext context)

        {

        }

        public bool IsReusable

        {

            get { return true; }

        }

        public IAsyncResult BeginProcessRequest(HttpContext context, AsyncCallback cb, object extraData)

        {





            context.Response.Cache.SetCacheability(HttpCacheability.NoCache);



            string sessionId = context.Request.QueryString["sessionId"];

            if (Queue.Count(fun => fun.SessionId == sessionId) > 0)

            {

                int index = Queue.IndexOf(Queue.Find(fun => fun.SessionId == sessionId));

                Queue[index].Context = context;

                Queue[index].CallBack = cb;

                return Queue[index];

            }



            MyAsyncResult asyncResult = new MyAsyncResult(context, cb, sessionId);

            Queue.Add(asyncResult);

            return asyncResult;

        }

        public void EndProcessRequest(IAsyncResult result)

        {



            MyAsyncResult rslt = (MyAsyncResult)result;





            rslt.Context.Response.Write(rslt.Message);

            rslt.Message = string.Empty;

        }

    }

    public class MyAsyncResult : IAsyncResult

    {

        /// <summary>

        /// 是否结束请求

        /// true:完成

        /// false:阻塞

        /// </summary>

        public bool IsCompleted

        {

            get;

            private set;

        }

        public WaitHandle AsyncWaitHandle

        {

            get;

            private set;

        }

        public object AsyncState

        {

            get;

            private set;

        }

        public bool CompletedSynchronously

        {

            get { return false; }

        }

        public HttpContext Context { get; set; }

        public AsyncCallback CallBack { get; set; }

        /// <summary>

        /// 自定义标识

        /// </summary>

        public string SessionId { get; set; }

        /// <summary>

        /// 自定义消息

        /// </summary>

        public string Message { get; set; }

        public MyAsyncResult(HttpContext context, AsyncCallback cb, string sessionId)

        {

            this.SessionId = sessionId;

            this.Context = context;

            this.CallBack = cb;

            IsCompleted = true;

        }

        /// <summary>

        /// 发送消息

        /// </summary>

        /// <param name="iscompleted">确认下发信息</param>

        public void SetCompleted(bool iscompleted)

        {

            if (iscompleted && this.CallBack != null)

            {

                CallBack(this);

            }

        }

    }

}