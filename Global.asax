<%@ Application Language="C#" %>

<script runat="server">

    void Application_Start(object sender, EventArgs e) 
    {
        // Code that runs on application startup
        Util.conStr = System.Configuration.ConfigurationSettings.AppSettings["constr"].Trim();
        System.Threading.ThreadStart threadStart = new System.Threading.ThreadStart(ServiceMessage.SendScheduleMessage);
        ServiceMessage.sendThread = new System.Threading.Thread(threadStart);
        ServiceMessage.sendThread.Start();
        
        
    }
    
    void Application_End(object sender, EventArgs e) 
    {
        //  Code that runs on application shutdown

    }
        
    void Application_Error(object sender, EventArgs e) 
    { 
        // Code that runs when an unhandled error occurs

    }

    void Session_Start(object sender, EventArgs e) 
    {
        // Code that runs when a new session is started

    }

    void Session_End(object sender, EventArgs e) 
    {
        // Code that runs when a session ends. 
        // Note: The Session_End event is raised only when the sessionstate mode
        // is set to InProc in the Web.config file. If session mode is set to StateServer 
        // or SQLServer, the event is not raised.

    }
       
</script>
