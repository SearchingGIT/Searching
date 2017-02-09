//app.controller('SearchController', ['$scope', '$http', 'ApiService', function ($scope, $http, ApiService) {

var SearchController = function ($scope, $http, ApiService, localStorageService)
{
    console.log('work');
//    $scope.FilterAnn = {
//    Category_id: 0,
//    Country_id: 0,
//    City_id: 0,
//    Areas_id: 0,
//    Gender_user: "",
//    DateAnnouncing: null,
//    MinDateBirthday: null,
//    MaxDateBirthday: null,
//    Popular: null,
//    DateSort: null
//};

     ApiService.GetCategories()
    
    .success(function (response) {
        $scope.Categories = response;
    })
    .error(function (fail) {
        console.log('fail load data with Service',fail);
    });
}
SearchController.$inject = ['$scope', '$http', 'ApiService','localStorageService'];