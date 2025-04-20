using Microsoft.Owin;
using Owin;

[assembly: OwinStartup(typeof(_152120211048_Asrınalp_Şahin_HW4.Startup))]

namespace _152120211048_Asrınalp_Şahin_HW4
{
    public class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            app.MapSignalR(); // SignalR hub rotalarını aktif eder
        }
    }
}
