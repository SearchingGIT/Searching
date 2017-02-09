using Searching.Shared.API.DataModel;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;

namespace Searching.BE.Service
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the interface name "IWCFRESTService" in both code and config file together.
    [ServiceContract(Namespace = "Searching.BE.Service")]
    public interface IWCFRESTService
    {
        [OperationContract]
        [WebGet( RequestFormat = WebMessageFormat.Json, ResponseFormat = WebMessageFormat.Json,UriTemplate = "GetCityOfCountry?countryId={countryId}", BodyStyle =WebMessageBodyStyle.WrappedRequest)]
        //Возвращает список городов по заданной стране
        List<City> GetCityOfCountry(int countryId);

        [OperationContract]
        [WebGet(RequestFormat = WebMessageFormat.Json, ResponseFormat = WebMessageFormat.Json,UriTemplate = "GetCountries")]
        //Возвращает список Стран
        List<Country> GetCountries();

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json,UriTemplate ="GetCategories")]
        //Возвращает список категорий для объявлений
        List<Category> GetCategories();

        [OperationContract]
        [WebInvoke(Method="POST",UriTemplate = "GetAnnouncing", ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.WrappedRequest, RequestFormat = WebMessageFormat.Json)]
        //Возвращает список объявлений по заданным фильтрам
        List<Announcing> GetAnnouncing(AnnouncingFilter filter);

        [OperationContract]
        [WebGet(RequestFormat = WebMessageFormat.Json,BodyStyle =WebMessageBodyStyle.WrappedRequest, ResponseFormat = WebMessageFormat.Json,UriTemplate = "GetAreasOfCity?cityId={cityId}")]
        //Возвращает список районов по заданому городу 
        List<Area> GetAreasOfCity(int cityId);

        [OperationContract]
        [WebGet(RequestFormat = WebMessageFormat.Json, ResponseFormat = WebMessageFormat.Json,UriTemplate = "GetFavoriteAnnuncing?userId={userId}", BodyStyle =WebMessageBodyStyle.WrappedRequest)]
        //Возвращает список подписанных объявлений пользователя
        List<Announcing> GetFavoriteAnnouncing(int userId);

        [OperationContract]
        [WebGet(RequestFormat = WebMessageFormat.Json, ResponseFormat = WebMessageFormat.Json,BodyStyle =WebMessageBodyStyle.WrappedRequest,UriTemplate = "GetSelectedAnnouncing?userId={userId}")]
        //Возвращает список выбранных объявлений пользователя
        List<Announcing> GetSelectedAnnouncing(int userId);

        [OperationContract]
        [WebGet(RequestFormat = WebMessageFormat.Json, ResponseFormat = WebMessageFormat.Json,UriTemplate = "GetForeignUser?userId={userId}", BodyStyle =WebMessageBodyStyle.WrappedRequest)]
        //Возвращает иформацию по выбранному пользователю
        User GetForeignUser(int userId);

        [OperationContract]
        [WebGet( RequestFormat = WebMessageFormat.Json, ResponseFormat = WebMessageFormat.Json, UriTemplate = "GetMyUser?mail={mail}",BodyStyle =WebMessageBodyStyle.WrappedRequest)]
        //Возвращает информацию о собственном аккаунте
        User GetMyUser(string mail);

        [OperationContract]
        [WebInvoke(UriTemplate ="TestFunction", Method = "POST",ResponseFormat =WebMessageFormat.Json,RequestFormat =WebMessageFormat.Json,BodyStyle =WebMessageBodyStyle.WrappedRequest)]
        string TestFunction(string filter);

        [OperationContract]
        [WebInvoke(Method = "POST", RequestFormat = WebMessageFormat.Json, ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.WrappedRequest, UriTemplate = "Registration")]
        //Регистрирует пользователя (возвращает true or false)
        ResponseMessage Registration(User user);

        [OperationContract]
        [WebInvoke(Method = "POST", RequestFormat = WebMessageFormat.Json, ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.WrappedRequest, UriTemplate = "Auth")]
        //Аутентификация пользователя (возвращает true or false)
        ResponseMessage Auth(User user);

        [OperationContract]
        [WebInvoke(Method = "POST", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.WrappedRequest, UriTemplate = "EditProfile")]
        //Изменяет профиль выбранного пользователя 
        User EditProfile(User user);

        [OperationContract]
        [WebInvoke(Method = "POST", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.WrappedRequest, UriTemplate = "AddAnnouncing")]
        //Добавляет объявление 
        ResponseMessage AddAnnouncing(Announcing announcing);

        [OperationContract]
        [WebInvoke(Method = "POST", RequestFormat = WebMessageFormat.Json, ResponseFormat = WebMessageFormat.Json, UriTemplate = "EditAnnouncing", BodyStyle = WebMessageBodyStyle.WrappedRequest)]
        //изменение объявления
        ResponseMessage EditAnnouncing(Announcing announcing);

        [OperationContract]
        [WebInvoke(Method = "POST", RequestFormat = WebMessageFormat.Json, ResponseFormat = WebMessageFormat.Json, UriTemplate = "DeleteAnnouncing", BodyStyle = WebMessageBodyStyle.WrappedRequest)]
        //Удаляеет объявления
        ResponseMessage DeleteAnnouncing(int annId);

        [OperationContract]
        [WebInvoke(Method = "POST", RequestFormat = WebMessageFormat.Json, ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.WrappedRequest, UriTemplate = "AddAnnouncingToSelected")]
        ResponseMessage AddAnnouncingToSelected(SelectedAnnouncing announcing);

        [OperationContract]
        [WebInvoke(Method = "POST", RequestFormat = WebMessageFormat.Json, ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.WrappedRequest, UriTemplate = "AddAnnouncingToFavorite")]
        ResponseMessage AddAnnouncingToFavorite(FavoriteAnnouncing announcing);

        [OperationContract]
        [WebInvoke(Method = "POST", RequestFormat = WebMessageFormat.Json, ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.WrappedRequest, UriTemplate = "DeleteSelectedAnnouncing")]
        ResponseMessage DeleteSelectedAnnouncing(SelectedAnnouncing announcing);

        [OperationContract]
        [WebInvoke(Method = "POST", RequestFormat = WebMessageFormat.Json, ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.WrappedRequest, UriTemplate = "DeleteFavoriteAnnouncing")]
        ResponseMessage DeleteFavoriteAnnouncing(FavoriteAnnouncing announcing);

        [OperationContract]
        [WebInvoke(Method = "POST", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.WrappedRequest, UriTemplate = "AddUserToSelected")]
        ResponseMessage AddUserToSelected(SelectedUser user);

        [OperationContract]
        [WebInvoke(Method = "POST", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.WrappedRequest, UriTemplate = "DeleteSelectedUser")]
        ResponseMessage DeleteSelectedUser(SelectedUser user);

        [OperationContract]
        [WebInvoke(Method = "POST", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json, UriTemplate = "GetFollowers", BodyStyle = WebMessageBodyStyle.WrappedRequest)]
        List<User> GetFollowers(int userId);

        [OperationContract]
        [WebInvoke(Method = "POST", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json, UriTemplate = "GetAnnouncingFull",BodyStyle =WebMessageBodyStyle.WrappedRequest)]
        Announcing GetAnnouncingFull(int annId);

        [OperationContract]
        [WebInvoke(Method = "POST", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.WrappedRequest,UriTemplate = "AddMessage")]
        ResponseMessage AddMessage(Notice message);

        [OperationContract]
        [WebInvoke(Method = "POST", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.WrappedRequest, UriTemplate = "GetMyAnnouncing")]
        List<Announcing> GetMyAnnouncing(int ID);

        [OperationContract]
        [WebInvoke(Method = "POST", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.WrappedRequest, UriTemplate = "DeleteMessage")]
        ResponseMessage DeleteMessage(int ID);

        [OperationContract]
        [WebInvoke(Method = "POST", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.WrappedRequest)]
        ResponseMessage CallCallBack(List<Notice> messageList);

        //[OperationContract(AsyncPattern = true)]
        //[WebInvoke(Method = "POST", RequestFormat = WebMessageFormat.Json, ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.WrappedRequest)]
        //IAsyncResult BeginMessage(int recipient_id, AsyncCallback callback, object state);

        //List<Messages> EndMessage(IAsyncResult asyncResult);

        [OperationContract]
        [WebGet(RequestFormat = WebMessageFormat.Json, ResponseFormat = WebMessageFormat.Json, UriTemplate = "GetSubscribers")]
        List<int> GetSubscribers();

        [OperationContract]
        [WebInvoke(Method = "POST", RequestFormat = WebMessageFormat.Json, ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.WrappedRequest,UriTemplate = "GetMessages")]
        List <Notice> GetMessages(int recipientId);

        [OperationContract]
        [WebInvoke(Method = "POST", RequestFormat = WebMessageFormat.Json, ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.WrappedRequest, UriTemplate = "TestWF")]
        ResponseMessage TestWF(int ID);


        [OperationContract]
        [WebInvoke(Method = "GET", RequestFormat = WebMessageFormat.Json, ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.WrappedRequest, UriTemplate = "GetTestWF")]
        List<int> GetTestWF();
    }

}