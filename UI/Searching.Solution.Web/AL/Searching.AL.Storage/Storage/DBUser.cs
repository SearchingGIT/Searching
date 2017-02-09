using Searching.AL.Storage.Model;
using SearchingLibrary;
using System;
using System.Collections.Generic;
using System.Data.Linq;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Searching.AL.Storage
{
    public class DBUser
    {
        public static void AddUser(UserList user)
        {
            using (UserDataContext context = new UserDataContext(UserDataContext.DBConnectionString))
            {
                LUsers _user = new LUsers();
                _user.User_id = user.User_id;
                _user.City_id = user.City_id;
                _user.Country_id = user.Country_id;
                _user.Date_Bearthday = user.Date_Bearthday;
                _user.Name = user.Name;
                _user.LastName = user.LastName;
                _user.Gender_user = user.Gender_user;
                _user.Info = user.Info;
                _user.Mail = user.Mail;
                _user.Password = user.Password;
                _user.Type_login = user.Type_login;
                try
                { 
                context.Users.InsertOnSubmit(_user);
                context.SubmitChanges();
                }
                catch(Exception ex)
                {
                    throw ex;
                }
            }
        }
        public static void UpdateUser(UserList user)
        {
            using (UserDataContext conext = new UserDataContext(UserDataContext.DBConnectionString))
            {
                IQueryable<LUsers> entityQuery = from c in conext.Users where c.Mail==user.Mail select c;
                LUsers entityUpdate = entityQuery.FirstOrDefault();
                entityUpdate.City_id = user.City_id;
                entityUpdate.Country_id = user.Country_id;
                entityUpdate.Date_Bearthday = user.Date_Bearthday;
                entityUpdate.Gender_user = user.Gender_user;
                entityUpdate.Info = user.Info;
                entityUpdate.LastName = user.LastName;
                entityUpdate.Mail = user.Mail;
                entityUpdate.Name = user.Name;
                entityUpdate.Phone = user.Phone;
                entityUpdate.Type_login = user.Type_login;
                entityUpdate.User_id = user.User_id;
                try
                { 
                conext.SubmitChanges();
                }
                catch(Exception ex)
                {
                    throw ex;
                }
            }
        }
        public static void DeleteAllUsers()
        {
            using (UserDataContext context = new UserDataContext(UserDataContext.DBConnectionString))
            {
                IQueryable<LUsers> entityQuery = from c in context.Users select c;
                IList<LUsers> entityToDelete = entityQuery.ToList();
                context.Users.DeleteAllOnSubmit(entityToDelete);
                context.SubmitChanges();
            }
        }
        public static IList<LUsers> GetAllUsers()
        {
            IList<LUsers> list = null;
            using (UserDataContext context = new UserDataContext(UserDataContext.DBConnectionString))
            {
                IQueryable<LUsers> query = from c in context.Users select c;
                list = query.ToList();
            }
            return list;
        }
    }
}