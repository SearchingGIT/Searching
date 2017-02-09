using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace Searching.UI.Web
{
    public class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            routes.MapRoute(
             name: "Header",
             url: "Navigation/Header",
             defaults: new { controller = "Navigation", action = "Header" });

            routes.MapRoute(
           name: "AnnouncingList",
           url: "Search/AnnouncingList/{filter}",
           defaults: new { controller = "Search", action = "AnnouncingList", filter = UrlParameter.Optional });

            routes.MapRoute(
           name: "CategoryList",
           url: "Search/CategoryList",
           defaults: new { controller = "Search", action = "CategoryList" });

            routes.MapRoute(
           name: "Test",
           url: "Search/Test",
           defaults: new { controller = "Search", action = "Test" });

            // routes.MapRoute(
            //name: "home",
            //url: "Home/StartPage",
            //defaults: new { controller = "Home", action = "StartPage" });

            routes.MapRoute(
           name: "Profile",
           url: "Navigation/Profile",
           defaults: new { controller = "Navigation", action = "Profile" });



            routes.MapRoute(
             name: "Footer",
             url: "Navigation/Footer",
             defaults: new { controller = "Navigation", action = "Footer" });

            routes.MapRoute(
             name: "UserBlock",
             url: "Ann/UserBlock",
             defaults: new { controller = "Ann", action = "UserBlock" });

            routes.MapRoute(
             name: "AnnBlock",
             url: "Ann/AnnBlock",
             defaults: new { controller = "Ann", action = "AnnBlock" });

            routes.MapRoute(
             name: "CategoryBlock",
             url: "Ann/CategoryBlock",
             defaults: new { controller = "Ann", action = "CategoryBlock" });

            routes.MapRoute(
            name: "Login",
            url: "Profile/Login",
            defaults: new { controller = "Profile", action = "Login" });

            routes.MapRoute(
                name: "Search",
                url: "Navigation/Search",
                defaults: new { controller = "Navigation", action = "Search" });

            routes.MapRoute(
            name: "AnnFilter",
            url: "Ann/GetAnnFilter/{filter}",
            defaults: new { controller = "Ann", action = "GetAnnFilter", filter = UrlParameter.Optional });

            routes.MapRoute(
            name: "AnnFull",
            url: "Ann/GetAnnFull/{announcing_id}",
            defaults: new { controller = "Ann", action = "GetAnnFull", announcing_id = UrlParameter.Optional });

            routes.MapRoute(
            name: "Auth",
            url: "Profile/AuthUser/{user}",
            defaults: new { controller = "Profile", action = "AuthUser", user = UrlParameter.Optional });

            routes.MapRoute(
            name: "Registration",
            url: "Profile/Registration",
            defaults: new { controller = "Profile", action = "Registration" });

            routes.MapRoute(
            name: "RegUser",
            url: "Profile/RegUser/{user}",
            defaults: new { controller = "Profile", action = "RegUser", user = UrlParameter.Optional });

            routes.MapRoute(
            name: "GetMyUser",
            url: "Profile/GetMyUser/{mail}",
            defaults: new { controller = "Profile", action = "GetMyUser", mail = UrlParameter.Optional });

            routes.MapRoute(
            name: "AnnEmriss",
            url: "Ann/AnnouncingList/{categories_id}",
            defaults: new { controller = "Ann", action = "AnnouncingList", categories_id = UrlParameter.Optional });


            routes.MapRoute(
            name: "AddToFavorite",
            url: "Ann/AddtoFavorite/{ann}",
            defaults: new { controller = "Ann", action = "AddtoFavorite", ann = UrlParameter.Optional });

            routes.MapRoute(
            name: "AddtoSelected",
            url: "Ann/AddtoSelected/{ann}",
            defaults: new { controller = "Ann", action = "AddtoSelected", ann = UrlParameter.Optional });

            routes.MapRoute(
            name: "Messages",
            url: "Navigation/Messages",
            defaults: new { controller = "Navigation", action = "Messages", ann = UrlParameter.Optional });

            routes.MapRoute(
            name: "GetMyAnnouncing",
            url: "Profile/GetMyAnnouncing/{id}",
            defaults: new { controller = "Profile", action = "GetMyAnnouncing", id = UrlParameter.Optional });

            routes.MapRoute(
                 name: "Default",
                 url: "{*url}",
                 defaults: new { controller = "Home", action = "StartPage" });
        }
    }
}
