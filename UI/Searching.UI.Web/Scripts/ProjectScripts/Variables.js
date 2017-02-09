//var loginUser = {
//    Mail: null,
//    Password: null,
//};

var LoginUser = function(){
    this.Mail= null,
    this.Password = null
};

//var user = {
//    User_id: null,
//    Mail: null,
//    Name: null,
//    LastName: null,
//    Phone: null,
//    Gender_user: null,
//    Date_Bearthday: null,
//    Password: null,
//    Info: null,
//    Country_id: null,
//    Type_login: null,
//    City_id: null
//};

var User = function(){
    this.User_id= null,
    this.Mail = null,
    this.Name = null,
    this.LastName = null,
    this.Phone = null,
    this.Gender_user = null,
    this.Date_Bearthday = null,
    this.Password = null,
    this.Info = null,
    this.Country_id = null,
    this.Type_login = null,
    this.City_id = null
};

//var regUser = {
//    User_id: null,
//    Mail: null,
//    Name: null,
//    LastName: null,
//    Phone: null,
//    Gender_user: null,
//    Date_Bearthday: null,
//    Password: null,
//    Info: null,
//    Country_id: null,
//    Type_login: null,
//    City_id: null
//};

var RegUser =function() {
    this.User_id= null,
    this.Mail= null,
    this.Name= null,
    this.LastName= null,
    this.Phone= null,
    this.Gender_user= null,
    this.Date_Bearthday= null,
    this.Password= null,
    this.Info= null,
    this.Country_id= null,
    this.Type_login= null,
    this.City_id= null
};
//var Filter = {
//    Category_id: null,
//    Country_id: null,
//    City_id: null,
//    Areas_id: null,
//    Gender_user: null,
//    DateAnnouncing: null,
//    MinDateBirthday: null,
//    MaxDateBirthday: null,
//    Popular: null,
//    DateSort: null,
//    nPage: 1,
//    sizePage:3
//};

//var selectedAnn = {
//    id: null,
//    Announcing_id: null,
//    User_id: null
//};

var SelectedAnn = function(){
    this.id= null,
    this.Announcing_id= null,
    this.User_id= null
};

var FavoriteAnn = function () {
    this.id = null,
    this.Announcing_id = null,
    this.User_id = null
};

var Filter = function(){
    this.CategoryId = null,
    this.CountryId = null,
    this.CityId = null,
    this.AreaId = null,
    this.UserGender = null,
    this.AnnouncingDate = null,
    this.JsonAnnouncingDate = null,
    this.MinDateBirthday = null,
    this.JsonMinDateBirthday = null,
    this.MaxDateBirthday = null,
    this.JsonMaxDateBirthday = null,
    this.Popular = null,
    this.DateSort = null,
    this.NPage = 1,
    this.sizePage = 7
};

var clearFilter =function() {
    this.CategoryId = null,
    this.CountryId = null,
    this.CityId = null,
    this.AreaId = null,
    this.UserGender = null,
    this.AnnouncingDate = null,
    this.JsonAnnouncingDate = null,
    this.MinDateBirthday = null,
    this.JsonMinDateBirthday = null,
    this.MaxDateBirthday = null,
    this.JsonMaxDateBirthday = null,
    this.Popular = null,
    this.DateSort = null,
    this.NPage = 1,
    this.sizePage = 7
};