using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using Newtonsoft.Json;
using Newtonsoft;
using System.Diagnostics;
using Searching.DAL.Main;
using System.Data;
using System.Web.Script.Serialization;
using Searching.Shared.API.DataModel;
using System.IO;
using System.ServiceModel.Web;
using System.ServiceModel.Activation;
using System.ServiceModel.Description;
using System.Net;
using Searching.DAL.Main.Logics.BD;
using System.Threading;
using System.Web;

namespace Searching.BE.Service
{
    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
    [ServiceBehavior(
    InstanceContextMode = InstanceContextMode.PerCall,
    ConcurrencyMode = ConcurrencyMode.Multiple)]
    public class WCFRESTService:IWCFRESTService
    {
        private static List<int> testWorkflow = new List<int>();
        private static List<MessageAsyncResult> subscribers = new List<MessageAsyncResult>();
        private static List<int> subList = new List<int>();

        public List<Announcing> GetAnnouncing(AnnouncingFilter filter)
        {
            WebOperationContext ctx = WebOperationContext.Current;
           List<Announcing> annList = new List<Announcing>();
           var table = AnnouncingFiltration.GetAnnouncing(filter);
            foreach (DataRow row in table.Rows)
            {
                Announcing ann = new Announcing();
                try
                {
                    ann.Info = row["Info_Announcing"].ToString();
                    ann.JsonDate = row["DT_Announcing"].ToString();
                    ann.Id = int.Parse(row["Announcing_id"].ToString());
                    ann.UserId = int.Parse(row["User_id"].ToString());
                    ann.Name = row["Name_Announcing"].ToString();
                    ann.UserName = row["Name"].ToString();
                    ann.UserLastName = row["LastName"].ToString();
                    annList.Add(ann);
                }
                catch (Exception ex)
                {
                    Logger.CreateLog(ex);
                   // throw ex;
                }
            }
            return annList;
        }

        public List<Area> GetAreasOfCity(int cityId)
        {
            List<Area> areaList = new List<Area>();
            DataTable table = Location.GetAreasOfCity(cityId);
            foreach(DataRow row in table.Rows)
            {
                Area area = new Area();
                area.Id = int.Parse(row["Areas_id"].ToString());
                area.Name = row["Areas_name"].ToString();
                areaList.Add(area);
            }
            return areaList;
        }

        public List<Category> GetCategories()
        {
            DataTable table = AnnouncingFiltration.GetCategories();
            List<Category> categoryList = new List<Category>();
            foreach (DataRow row in table.Rows)
            {
                Category category = new Category();
                category.Name = row["Name_Category"].ToString();
                category.Id = int.Parse(row["Category_id"].ToString());
                category.Info = row["Info_Category"].ToString();
                categoryList.Add(category);
            }
            return categoryList;
        }

        public List<City> GetCityOfCountry(int countryId)
        {
            DataTable table = Location.GetCityOfCountry(countryId);
            List<City> cityList = new List<City>();
            foreach(DataRow row in table.Rows)
            {
                City city = new City();
                city.Id = int.Parse(row["city_id"].ToString());
                city.Name = row["City_name"].ToString();
                cityList.Add(city );
            }
            return cityList;
        }

        public List<Country> GetCountries()
        {
            DataTable table = Location.GetCountries();
            List<Country> countryList = new List<Country>();
            foreach(DataRow row in table.Rows)
            {
                Country country = new Country();
                country.Id = int.Parse(row["Country_id"].ToString());
                country.Name = row["Name_country"].ToString();
                countryList.Add(country);
            }
            return countryList;
            
        }
        
        public List<Announcing> GetFavoriteAnnouncing(int userId)
        {
            DataTable table = FavoriteAnnouncingFunction.Get(userId);
            List<Announcing> favAnnList = new List<Announcing>();
            foreach(DataRow row in table.Rows)
            {
                Announcing favAnn = new Announcing();
                favAnn.Id = int.Parse(row["Announcing_id"].ToString());
                favAnn.AreaId = int.Parse(row["Areas_id"].ToString());
                favAnn.Phone = int.Parse(row["Phone_Announcing"].ToString());
                favAnn.Info = row["Info_Announcing"].ToString();
                favAnn.Name = row["Name_Announcing"].ToString();
                favAnnList.Add(favAnn);
            }
            return favAnnList;
        }
        
        public List<Announcing> GetSelectedAnnouncing(int userId)
        {
            List<Announcing> selAnnList = new List<Announcing>();
            DataTable table = SelectedAnnouncingFunction.Get(userId);
            foreach(DataRow row in table.Rows)
            {
                Announcing selAnn = new Announcing();
                selAnn.Id = int.Parse(row["Announcing_id"].ToString());
                selAnn.AreaId = int.Parse(row["Areas_id"].ToString());
                selAnn.Phone = int.Parse(row["Phone_Announcing"].ToString());
                selAnn.Info = row["Info_Announcing"].ToString();
                selAnn.Name = row["Name_Announcing"].ToString();
                selAnnList.Add(selAnn);
            }
            return selAnnList;
        }
        
        public User GetForeignUser(int userId)
        {
            User user = new User();
            DataTable table = Profile.GetForeignUser(userId);
            foreach(DataRow row in table.Rows)
            {
                user.Name = row["Name"].ToString();
                user.CountryId = int.Parse(row["Country_id"].ToString());
                user.Phone = (row["Phone"].ToString());
                user.Id = int.Parse(row["User_id"].ToString());
                user.Gender = row["Gender_user"].ToString();
                user.Date_Bearthday = DateTime.Parse(row["Date_Bearthday"].ToString());
                user.Info = row["Info"].ToString();
            }
            return user;
        }

        public string TestFunction(string filter)
        {
            AddCorsHeaders();
            ResponseMessage response = new ResponseMessage();
            //response.user.Info = "Success";
            return  filter;
        }
        private void AddCorsHeaders()
        {
            HttpContext.Current.Response.AddHeader("Access-Control-Allow-Origin", "*");
            if (HttpContext.Current.Request.HttpMethod == "OPTIONS")
            {
                HttpContext.Current.Response.AddHeader("Cache-Control", "no-cache");
                HttpContext.Current.Response.AddHeader("Access-Control-Allow-Methods", "GET, POST,PUT,DELETE");
                HttpContext.Current.Response.AddHeader("Access-Control-Allow-Headers", "Content-Type, Accept, x-requested-with");
                HttpContext.Current.Response.AddHeader("Access-Control-Max-Age", "1728000");
                HttpContext.Current.Response.End();
            }
        }

        public ResponseMessage Registration(User user)
        {
            //UserList _user = new UserList();
            //_user.City_id = 1;
            //_user.Country_id = 1;
            //var data = "12-10-22";
            //_user.Date_Bearthday = DateTime.Parse(data);
            //_user.Gender_user = "м";
            //_user.Info = "Маньяк";
            //_user.LastName = "Гитлер";
            //_user.Mail = "Cp5dsa@mail1er.ru";
            //_user.Name = "Адольфик";
            //_user.Password = "Adolf123";
            //_user.Phone = "2";
            //_user.Type_login = 1;
            var response = Profile.Registration(user);
            return response;
        }

        public ResponseMessage Auth(User user)
        {
            //  UserList _user = new UserList();
            //_user.Mail = "Cp5@mail1erda.ru";
            //_user.Password = "Adolf123";
            ResponseMessage response = Profile.Auth(user);
            return response;
        }

        public User EditProfile(User user)
        {
            User usr = new User();
            var table = Profile.Edit(usr);
            foreach (DataRow row in table.Rows)
            {
                usr.Id = int.Parse(row["User_id"].ToString());
                usr.Id = int.Parse(row["City_id"].ToString());
                usr.Date_Bearthday = DateTime.Parse(row["Date_Bearthday"].ToString());
                usr.Name = row["Name"].ToString();
                usr.Gender = row["Gender_user"].ToString();
                usr.Info = row["Info"].ToString();
                usr.Mail = row["Mail"].ToString();
                usr.Password = row["Password"].ToString();
                usr.Phone = (row["Phone"].ToString());
            }
            return usr;
        }

        public ResponseMessage AddAnnouncing(Announcing announcing)
        {
            announcing.Date = DateHelper.ParseToDateTime(announcing.JsonDate);
            //var data = "12-10-22";
            //Announcing TestAnn = new Announcing();
            //TestAnn.Areas_id = 1;
            //TestAnn.Categories_id = 3;
            //TestAnn.City_id = 1;
            //TestAnn.Date_Announcing = DateTime.Parse(data);
            //TestAnn.Info_Announcing = "ClientTest";
            //TestAnn.Name_Announcing = "ClientTest11";
            //TestAnn.Name_City = "Kiev";
            //TestAnn.Phone_Announcing = 12;
            //TestAnn.User_id = 20;
            var response= AnnouncingFunction.Add(announcing);
            return response;
        }

        public ResponseMessage EditAnnouncing(Announcing announcing)
        {
            var response=  AnnouncingFunction.Edit(announcing);
            return response;
        }

        public ResponseMessage DeleteAnnouncing(int annId)
        {
            var response = AnnouncingFunction.Delete(annId);
            return response;
        }

        public ResponseMessage AddAnnouncingToSelected(SelectedAnnouncing announcing)
        {
            ResponseMessage response = new ResponseMessage();
           // var row_string = "";
            var cheker =SelectedAnnouncingFunction.CheckRecording(announcing);
            var count = cheker.Rows.Count;
            if (count != 0)
            {
                response.Code = false;
                response.Message = "Запись уже добавлена!";
            }
            else
            {
                response = SelectedAnnouncingFunction.Add(announcing);
            }
            //foreach(DataRow row in cheker.Rows)
            //{
            //    row_string = row["id"].ToString();
            //}
            //if (!String.IsNullOrEmpty(row_string))
            //{
            //    result.Code = false;
            //    result.Message = "Запись уже добавлена!";
            //}else
            //{
            //    result= SelectedAnnouncingFunction.AddToSelected(ann);
            //}
            return response;
        }

        public ResponseMessage AddAnnouncingToFavorite(FavoriteAnnouncing announcing)
        {
            ResponseMessage response = new ResponseMessage();
            var checker = FavoriteAnnouncingFunction.CheckRecording(announcing);
            var count = checker.Rows.Count;
            if(count != 0)
            {
                response.Code = false;
                response.Message = "Запись уже добавлена!";
            }
            else
            {
                 response= FavoriteAnnouncingFunction.Add(announcing);
            }
            //Если Произошла ошибка при запросе
            //foreach (DataRow row in checker.Rows)
            //{
            //    row_string = row["id"].ToString();
            //}//Есть ли запись в таблице
            //if (!String.IsNullOrEmpty(row_string))
            //{
            //    result.Code = false;
            //    result.Message = "Запись уже добавлена!";
            //}//Если нету, то добавляем 
            //else
            //{ 
            //    result= FavoriteAnnouncingFunction.AddToFavorite(ann);
            //}
            return response;
        }

        public ResponseMessage DeleteSelectedAnnouncing(SelectedAnnouncing announcing)
        {
            var response= SelectedAnnouncingFunction.Delete(announcing);
            return response;
        }

        public ResponseMessage DeleteFavoriteAnnouncing(FavoriteAnnouncing announcing)
        {
            var response= FavoriteAnnouncingFunction.Delete(announcing);
            return response;
        }

        public ResponseMessage AddUserToSelected(SelectedUser user)
        {
            var response= FollowersFunction.Add(user);
            return response;
        }

        public ResponseMessage DeleteSelectedUser(SelectedUser user)
        {
            var response=  FollowersFunction.Delete(user);
            return response;
        }

        public List<User> GetFollowers(int userId)
        {
            User user = new User();
            List<User> userList = new List<User>();
            DataTable table = FollowersFunction.Get(userId);
            return userList;
        }

        public Announcing GetAnnouncingFull(int annId)
        {
            Announcing ann = new Announcing();
            DataTable table = AnnouncingFiltration.GetAnnouncingFull(annId);
            foreach(DataRow row in table.Rows)
            {
                ann.Id = int.Parse(row["Announcing_id"].ToString());
                ann.Name = row["Name_Announcing"].ToString();
                ann.Phone = int.Parse(row["Phone_Announcing"].ToString());
                ann.JsonDate = row["DT_Announcing"].ToString();
                ann.UserName = row["Name"].ToString();
                ann.UserLastName = row["LastName"].ToString();
                ann.CityName= row["City_Name"].ToString();
                ann.Info = row["Info_Announcing"].ToString();
            }
             return ann;
        }

        public User GetMyUser(string mail)
        {
            User user = new User();
            DataTable table = Profile.GetMyUser(mail);
            foreach(DataRow row in table.Rows)
            {
                user.Id = int.Parse(row["User_id"].ToString());
                user.Name = row["Name"].ToString();
                user.LastName = row["LastName"].ToString();
                if (row["City_id"] !=DBNull.Value)
                {
                    user.CityId = int.Parse(row["City_id"].ToString());
                }
                if (row["Date_Birthday"] != DBNull.Value)
                {
                    user.Date_Bearthday = DateTime.Parse(row["Date_Birthday"].ToString());
                }
                if (row["Gender_user"] != DBNull.Value)
                {
                    user.Gender= row["Gender_user"].ToString();
                }
                if (row["Info"] != DBNull.Value)
                {
                    user.Info = row["Info"].ToString();
                }
                user.Mail = row["Mail"].ToString();
                if (row["Phone"] != DBNull.Value)
                {
                    user.Phone = (row["Phone"].ToString());
                }
            }
            return user;
        }

        public ResponseMessage AddMessage(Notice message)
        {
            //message.SenderId = 1;
            //message.TypeId = 1;
            //message.AnnouncingId = 11;
            //message.StatusId = 1;
            //message.Message = "Сообщение в объявление";
            //message.Date = DateTime.Now;
            ResponseMessage response = new ResponseMessage();
            if(message.RecipientId !=null)
            {
                message.SessionId = Session.Get(message);
                if(message.SessionId==null)
                {
                    response.Code = false;
                    response.Message = "Не удалось создать сессию";
                    return response;
                }
            }
            else
            {
                if(message.AnnouncingId != null)
                {
                    response = Session.Check(message);
                    if (response.SessionId == null)
                    {
                        response.Code = false;
                        response.Message = "Вы не подписаны на это объявление";
                        return response;
                    }
                    else
                    {
                        message.SessionId = response.SessionId;
                    }
                }
            }
            response = DAL.Main.Logics.BD.MessagesFunction.Add(message);
            return response;
        }

        public ResponseMessage CallCallBack(List<Notice> messageList)
        {
            Notification notif = new Notification();
            var param = notif.msg;
            notif.msg = messageList;
            ResponseMessage response = new ResponseMessage();
            response.Code = true;
            response.Message = "Counts:" + messageList.Count.ToString();
            return response;
        }

        //public IAsyncResult BeginMessage(int recipient_id,AsyncCallback callback,object state)
        //{
        //    sub_list.Add(recipient_id);
        //    MessageAsyncResult asyncResult = new MessageAsyncResult(state,callback);

        //    asyncResult.Recipient_id = recipient_id;
        //    subscribers.Add(asyncResult);
        //    return asyncResult;
        //}

        //public List<Messages> EndMessage(IAsyncResult asyncResult)
        //{
        //    return (asyncResult as MessageAsyncResult).Result;
        //}

        public List<int> GetSubscribers()
        {
            return subList;
        }

       public List<Notice> GetMessages(int recipientId)
        {
            Notice msg = new Notice();
            subList.Add(recipientId);
            Notification notif = new Notification();
            var msgList = notif.Check(recipientId);
            if (msgList.Count == 0)
            {
                var end = DateTime.Now.AddMinutes(2);
                while((msgList = notif.Check(recipientId)).Count==0  && DateTime.Now<end)
                {
                    System.Threading.Thread.Sleep(1);
                }
                
            }
            subList.Remove(recipientId);
            //var wait = new EventWaitHandle(false, EventResetMode.ManualReset);
            //var timeOut = new TimeSpan(0, 0, 15);
            //EventHandler waiter = (s, e) => wait.Set();
            //res.Changed += waiter;
            //wait.WaitOne(timeOut);
            return msgList;
        }

        public List<Announcing> GetMyAnnouncing(int ID)
        {
            List<Announcing> annList = new List<Announcing>();
            Announcing ann = new Announcing();
            DataTable table = AnnouncingFunction.GetMy(ID);
            foreach (DataRow row in table.Rows)
            {
                ann = new Announcing();
                ann.Id = int.Parse(row["Announcing_id"].ToString());
                ann.Name = row["Name_Announcing"].ToString();
                ann.JsonDate = row["DT_Announcing"].ToString();
                ann.Info = row["Info_Announcing"].ToString();
                ann.CategoryId = int.Parse(row["Categories_id"].ToString());
                ann.UserId = int.Parse(row["User_id"].ToString());
                ann.CityId = int.Parse(row["City_id"].ToString());
                if (row["Areas_id"] != DBNull.Value)
                    ann.AreaId = int.Parse(row["Areas_id"].ToString());
                ann.UserName = row["Name"].ToString();
                ann.UserLastName = row["LastName"].ToString();
                annList.Add(ann);
            }
            return annList;
        }

        public ResponseMessage TestWF(int ID)
        {
            ResponseMessage response = new ResponseMessage();
            testWorkflow.Add(ID);
            response.Code = true;
            response.Message = "Count:" + testWorkflow.Count;
            return response;
        }

        public List<int> GetTestWF()
        {
            return testWorkflow;
        }

        public ResponseMessage DeleteMessage(int ID)
        {
            var response = MessagesFunction.Delete(ID);
            return response;
        }
    }
    
}
