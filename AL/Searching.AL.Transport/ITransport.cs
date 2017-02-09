using SearchingLibrary;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Searching.AL.Transport
{
   public interface ITransport
    {
        void CheckExistBD();
        Task<List<Categories>> GetCategories();
        Task<List<Cities>>GetCities();
        Task<List<AreasOfCity>> GetAreas();
        Task<List<Country>> GetCountries();
        Task<List<Announcing>>GetAnnouncing(AnnFilter filter);
        Task<Announcing> GetAnnouncingFull(string announcing_id);
        Task<ReturnValue> Auth(UserList user);
        Task<ReturnValue> Registration(UserList user);
        Task<UserList> GetMyUser(string mail);
    }
}
