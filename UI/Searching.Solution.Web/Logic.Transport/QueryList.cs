using Newtonsoft.Json;
using Searching.Shared.API.DataModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Searching.Solution.Web.Logic.Transport
{
  public  class QueryList
    {
        public static async Task<List<Category>> GetCategories()
        {
            var result = await AccessService.ServiceCalled("GET", "GetCategories","");
            List<Category> categories=JsonConvert.DeserializeObject<List<Category>>(result);
            return categories;
        }
        public static async Task<List<Announcing>> GetAnnouncingFilter(AnnouncingFilter _filter)
        {
            var param = JsonConvert.SerializeObject(new { filter = _filter });
            var result= await AccessService.ServiceCalled("POST", "GetAnnouncing", param);
            List<Announcing> announcingForCategory = JsonConvert.DeserializeObject<List<Announcing>>(result);
            return announcingForCategory;
        }

        public static async Task<List<Announcing>> GetAnnouncing() 
        {
            var result = await AccessService.ServiceCalled("GET", "GetAnnouncing", "");
            List<Announcing> la = JsonConvert.DeserializeObject<List<Announcing>>(result);
            return la;
        }

        public static async Task<List<Announcing>> GetMyAnnouncing(int _id )
        {
            var param = JsonConvert.SerializeObject(new { id = _id });
            var result = await AccessService.ServiceCalled("POST", "GetMyAnnouncing", param);
            List<Announcing> MyAnn = JsonConvert.DeserializeObject<List<Announcing>>(result);
            return MyAnn;
        }

        public static async Task<List<City>> GetCityForCountry(string country_id)
        {
            var result = await AccessService.ServiceCalled("POST", "GetCityForCountry", country_id);
            List<City> cities = JsonConvert.DeserializeObject<List<City>>(result);
            return cities;
        }

        public static async Task<List<Area>> GetAreasOfCity(string city_id)
        {
            var result = await AccessService.ServiceCalled("POST", "GetAreasOfCity", city_id);
            List<Area> areasList = JsonConvert.DeserializeObject<List<Area>>(result);
            return areasList;
        }

        public static async Task<string> TestFunction()
        {
            var result = await AccessService.ServiceCalled("GET","TestFunction","");
            List<Announcing> announcingForCategory = JsonConvert.DeserializeObject<List<Announcing>>(result);
            return result;
        }

        public static async Task<Announcing> GetAnnouncingFull(string announcing_id)
        {
            var result = await AccessService.ServiceCalled("POST", "GetAnnouncingFull", announcing_id);
            Announcing ann = JsonConvert.DeserializeObject<Announcing>(result);
            return ann;
        }

        public static async Task<ResponseMessage> Registration(User user)
        {
            var param = JsonConvert.SerializeObject(new { user = user });
            var result = await AccessService.ServiceCalled("POST", "Registration", param);
            ResponseMessage returnV = JsonConvert.DeserializeObject<ResponseMessage>(result);
            return returnV;
        }

        public static async Task<ResponseMessage> Auth(User user)
        {
            var param = JsonConvert.SerializeObject(new { user = user });
            var result = await AccessService.ServiceCalled("POST", "Auth", param);
            ResponseMessage returnV = JsonConvert.DeserializeObject<ResponseMessage>(result);
            return returnV;

        }

        public static async Task<User> GetMyUser(string mail)
        {
            var param = JsonConvert.SerializeObject(new { mail = mail });
            var result = await AccessService.ServiceCalled("POST", "GetMyUser", param);
            User user = JsonConvert.DeserializeObject<User>(result);
            return user;
        }

        public static async Task<List<Country>> GetCountries()
        {
            var result = await AccessService.ServiceCalled("GET", "GetCountryList", "");
            List<Country> _countries = JsonConvert.DeserializeObject<List<Country>>(result);
            return _countries;
        }

        public static async Task<ResponseMessage> AddtoSelected(SelectedAnnouncing ann)
        {
            ResponseMessage returnV = new ResponseMessage();
            var param =JsonConvert.SerializeObject(new { ann = ann });
            var result = await AccessService.ServiceCalled("POST", "AddToSelected", param);
            returnV = JsonConvert.DeserializeObject<ResponseMessage>(result);
            return returnV;
        }

        public static async Task<ResponseMessage> AddtoFavorite(SelectedAnnouncing _ann)
        {
            ResponseMessage returnV = new ResponseMessage();
            var param = JsonConvert.SerializeObject(new { ann = _ann });
            var result = await AccessService.ServiceCalled("POST", "AddToFavorite", param);
             returnV = JsonConvert.DeserializeObject<ResponseMessage>(result);
            return returnV;
        }
    }
}
