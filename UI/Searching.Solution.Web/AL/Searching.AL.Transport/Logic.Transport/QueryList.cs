using Newtonsoft.Json;
using SearchingLibrary;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Searching.AL.Transport.Logic.Transport
{
  public  class QueryList
    {
        public static async Task<List<Categories>> GetCategories()
        {
            var result = await AccessService.ServiceCalled("GET", "GetCategories","");
            List<Categories> categories=JsonConvert.DeserializeObject<List<Categories>>(result);
            return categories;
        }
        public static async Task<List<Announcing>> GetAnnouncingFilter(AnnFilter _filter)
        {
            var param = JsonConvert.SerializeObject(new { filter = _filter });
            var result= await AccessService.ServiceCalled("POST", "GetAnnouncingFilter", param);
            List<Announcing> announcingForCategory = JsonConvert.DeserializeObject<List<Announcing>>(result);
            return announcingForCategory;
        }
        public static async Task<List<Cities>> GetCityForCountry(string country_id)
        {
            var result = await AccessService.ServiceCalled("POST", "GetCityForCountry", country_id);
            List<Cities> cities = JsonConvert.DeserializeObject<List<Cities>>(result);
            return cities;
        }

        public static async Task<List<AreasOfCity>> GetAreasOfCity(string city_id)
        {
            var result = await AccessService.ServiceCalled("POST", "GetAreasOfCity", city_id);
            List<AreasOfCity> areasList = JsonConvert.DeserializeObject<List<AreasOfCity>>(result);
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
        public static async Task<ReturnValue> Registration(UserList _user)
        {
            var param = JsonConvert.SerializeObject(new { user = _user });
            var result = await AccessService.ServiceCalled("POST", "Registration", param);
            ReturnValue returnV = JsonConvert.DeserializeObject<ReturnValue>(result);
            return returnV;
        }
        public static async Task<ReturnValue> Auth(UserList _user)
        {
            var param = JsonConvert.SerializeObject(new { user = _user });
            var result = await AccessService.ServiceCalled("POST", "Auth", param);
            ReturnValue returnV = JsonConvert.DeserializeObject<ReturnValue>(result);
            return returnV;
        }

        public static async Task<UserList> GetMyUser(string mail)
        {
            var param = JsonConvert.SerializeObject(new { mail = mail });
            var result = await AccessService.ServiceCalled("POST", "GetMyUser", param);
            UserList _rUser = JsonConvert.DeserializeObject<UserList>(result);
            return _rUser;
        }
        public static async Task<List<Country>> GetCountries()
        {
            var result = await AccessService.ServiceCalled("GET", "GetCountryList", "");
            List<Country> _countries = JsonConvert.DeserializeObject<List<Country>>(result);
            return _countries;
        }

    }
}
