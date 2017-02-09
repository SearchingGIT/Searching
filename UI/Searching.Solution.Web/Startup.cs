using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(Searching.Solution.Web.Startup))]
namespace Searching.Solution.Web
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
