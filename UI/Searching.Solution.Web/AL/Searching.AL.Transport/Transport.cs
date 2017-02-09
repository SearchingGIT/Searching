using Searching.AL.Storage;
using Searching.AL.Storage.Model;
using Searching.AL.Storage.Storage;
using Searching.AL.Transport.Logic.Transport;
using SearchingLibrary;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Searching.AL.Transport
{
    public class Transport : ITransport
    {
        public void CheckExistBD()
        {
            Searching.AL.Storage.Storage.CheckExistBD.CheckExist();
        }

        public async Task<List<Announcing>> GetAnnouncing(AnnFilter filter)
        {
            List<Announcing> _announcing = new List<Announcing>();
            _announcing = await QueryList.GetAnnouncingFilter(filter);
            return _announcing;
        }

        public Task<List<AreasOfCity>> GetAreas()
        {
            throw new NotImplementedException();
        }

        //public Transport(ITransport transport)
        // {
        //     _transport = transport;
        // }
        public async Task<List<Categories>> GetCategories()
        {
            List<Categories> _categories = new List<Categories>();
            IList<LCategories> _lcategories = Searching.AL.Storage.Storage.DBCategories.GetCategories();
            if(_lcategories.ToList().Count!=0)
            { 
            foreach(LCategories lc in _lcategories)
                    {
                Categories c = new Categories();
                c.Categories_id = lc.Categories_id;
                c.Name_Category = lc.Name_Category;
                c.Info_Category = lc.Info_Category;
                _categories.Add(c);
                    }
            }
            else { 
            _categories = await QueryList.GetCategories();
                DBCategories.AddCategories(_categories);
            }
            return _categories;
        }

        public async Task<List<Country>> GetCountries()
        {
            List<Country> _countries = new List<Country>();
            IList<LCountries> _lcountries = DBCountries.GetCountries();
            if(_lcountries.ToList().Count!=0)
            {
                foreach(LCountries lc in _lcountries)
                {
                    Country c = new Country();
                    c.Country_id = lc.Country_id;
                    c.Name_country = lc.Name_Country;
                    _countries.Add(c);
                }
            }
            else
            {
                _countries = await QueryList.GetCountries();
               
            }
            return _countries;
        }

        public Task<List<Cities>> GetCities()
        {
            throw new NotImplementedException();
        }

        public async Task<Announcing> GetAnnouncingFull(string announcing_id)
        {
            Announcing ann = new Announcing();
            ann = await QueryList.GetAnnouncingFull(announcing_id);
            return ann;
        }

        public  async Task<ReturnValue> Auth(UserList user)
        {
            ReturnValue rv = new ReturnValue();
            rv = await QueryList.Auth(user);
            if (rv.Code == true)
            {
                Storage.DBUser.AddUser(user);
            }
                return rv;
        }

        public async Task<ReturnValue> Registration(UserList user)
        {
            ReturnValue rv = new ReturnValue();
            rv = await QueryList.Registration(user);
            return rv;
        }

        public  async Task<UserList> GetMyUser(string mail)
        {
            UserList user = new UserList();
            user = await QueryList.GetMyUser(mail);
            Storage.DBUser.UpdateUser(user);
            return user;
        }
    }
}
