using System.Web;
using System.Web.Optimization;

namespace Searching.Solution.Web
{
    public class BundleConfig
    {
        // For more information on bundling, visit http://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.Add(new ScriptBundle("~/bundles/jquery").Include(
                        "~/Scripts/jquery-{version}.js"));

            bundles.Add(new ScriptBundle("~/bundles/logic")
                .IncludeDirectory("~/Scripts/Controllers", "*.js")
                .IncludeDirectory("~/Scripts/Factories", "*.js")
                .IncludeDirectory("~/Scripts/Services", "*.js")
                .IncludeDirectory("~/Scripts/ProjectScripts","*.js")
                .IncludeDirectory("~/Scripts/Directions","*.js")
                );
                

            bundles.Add(new ScriptBundle("~/bundles/jqueryval").Include(
                        "~/Scripts/jquery.validate*"));

            // Use the development version of Modernizr to develop with and learn from. Then, when you're
            // ready for production, use the build tool at http://modernizr.com to pick only the tests you need.
            bundles.Add(new ScriptBundle("~/bundles/modernizr").Include(
                        "~/Scripts/modernizr-*"));

            bundles.Add(new ScriptBundle("~/bundles/bootstrap").Include(
                    
                      "~/Scripts/respond.js"));

            //bundles.Add(new StyleBundle("~/Content/css").Include(
            //          "~/Content/style.css"));

            //bundles.Add(new StyleBundle("~/bundles/css")
            //    .IncludeDirectory("~/Content", "*.css",true)
            //    .IncludeDirectory("~/Content/font-awesome", "*.css", true)
            //    .IncludeDirectory("~/Content/font-awesome", "*.eot", true)
            //    .IncludeDirectory("~/Content/font-awesome", "*.svg", true)
            //    .IncludeDirectory("~/Content/font-awesome", "*.ttf", true)
            //    .IncludeDirectory("~/Content/font-awesome", "*.woff", true)
            //    .IncludeDirectory("~/Content/font-awesome", "*.woff2", true)
            //    .IncludeDirectory("~/Content/font-awesome", "*.less", true)
            //    .IncludeDirectory("~/Content/font-awesome", "*.scss", true)
            //    .IncludeDirectory("~/Content/patterns", "*.png", true)
            //    .IncludeDirectory("~/Content/patterns", "*.gif", true)
            //    .IncludeDirectory("~/Content", "*.css", true));
            BundleTable.EnableOptimizations = true;
        }
    }
}
