using System;
using System.IO;
using System.Web;

namespace _152120211048_Asrınalp_Şahin_HW4
{
    public class Global : HttpApplication
    {
        protected void Application_Start(object sender, EventArgs e)
        {
            Log("🟢 Application started.");
        }

        protected void Session_Start(object sender, EventArgs e)
        {
            Log("👤 Session started: " + Session.SessionID);
        }

        protected void Application_Error(object sender, EventArgs e)
        {
            Exception ex = Server.GetLastError();
            Log("❌ Error: " + ex.Message + " | Source: " + ex.Source);
        }

        protected void Session_End(object sender, EventArgs e)
        {
            Log("🔴 Session ended: " + Session.SessionID);
        }

        public static void Log(string message)
        {
            try
            {
                string path = HttpContext.Current?.Server.MapPath("~/App_Data/log.txt");
                if (!string.IsNullOrEmpty(path))
                {
                    File.AppendAllText(path, $"{DateTime.Now:yyyy-MM-dd HH:mm:ss} - {message}{Environment.NewLine}");
                }
            }
            catch
            {
                // Log başarısız olsa bile uygulama çökmesin
            }
        }
    }
}