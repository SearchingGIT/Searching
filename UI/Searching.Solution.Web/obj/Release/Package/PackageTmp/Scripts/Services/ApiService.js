//app.service("ApiService", ['$http', function ($http) {
    //this.GetCategories = function () {
//    return $http.get("http://192.168.200.100/Searching.BE.Service//WCFRESTService.svc/GetCategories");
//Category_id, Country_id, City_id, Areas_id, Gender_user, DateAnnouncing, MinDateBirthday, MaxDateBirthday, Popular, DateSort
//Category_id: Category_id, Country_id: Country_id, City_id: City_id, Areas_id: Areas_id, Gender_user: Gender_user, DateAnnouncing: DateAnnouncing, MinDateBirthday: MinDateBirthday, MaxDateBirthday: MaxDateBirthday, Popular: Popular, DateSort: DateSort


var ApiService = function ($q, $http, localStorageService, $timeout) {
    this.GetCategories = function () {
        return $http({
            url: 'http://192.168.100.101:1703//api/WCFRESTService.svc/GetCategories',
            method: 'GET'
        });
    };

    this.ClearFilter = function () {
        console.log('Filter Clearing Success!');
        SaveFilter=clearFilter;

    }
    this.GetMessage = function () {
        var deferred = $q.defer();
        $timeout(function () {
            deferred.resolve("Allo!");
        }, 2000);
        return deferred.promise
    }

    this.AnnFilter = function (filter) {
        return $http({
            url: '../Ann/GetAnnFilter',
            headers: {
                'Content-Type': 'application/json; charset=utf-8'
            },
            method: 'POST',
            data: { filter: filter }
        });
    };
    this.GetAnn = function () {
        return $http({
            url: 'http://searching.in.ua:1703//api/WCFRESTService.svc/GetAnnouncing',
            method: 'GET'
        });
    };
    this.GetAnnFull = function (ann_id) {
        return $http({
            url: '../Ann/GetAnnFull',
            headers: {
                'Content-Type': 'application/json; charset=utf-8'
            },
            method: 'POST',
            data: { announcing_id: ann_id }
        });
    };
    this.Auth = function (authUser) {
        return $http({
            url: '../Profile/AuthUser',
            headers: {
                'Content-Type': 'application/json; charset=utf-8'
            },
            method: 'POST',
            data: { user: authUser }
        });
    };
    this.RegUser = function (regUser) {
        return $http({
            url: '../Profile/RegUser',
            headers: {
                'Content-Type': 'application/json; charset=utf-8'
            },
            method: 'POST',
            data: { user: regUser }
        });
    };
    this.GetMyUser = function (mail) {
        return $http({
            url: 'http://192.168.100.101:1703/api/WCFRESTService.svc/GetMyUser?mail='+mail,
            method: 'GET'
        });
    }

    this.AddtoFavorite = function (favoriteAnn) {
        return $http({
            url: '../Ann/AddtoFavorite',
            headers: {
                'Content-Type': 'application/json; charset=utf-8'
            },
            method: 'POST',
            data: { ann: favoriteAnn }
        });
    }

    this.AddtoSelected = function (selectedAnn) {
        return $http({
            url: '../Ann/AddtoSelected',
            headers: {
                'Content-Type': 'application/json; charset=utf-8'
            },
            method: 'POST',
            data: { ann: selectedAnn }
        });
    }
    this.GetMyAnnouncing = function (id) {
        return $http({
            url: '../Profile/GetMyAnnouncing',
            headers: {
                'Content-Type': 'application/json; charset=utf-8'
            },
            method: 'POST',
            data: { id: id }
        });
    }
};
ApiService.$inject = ['$q','$http','localStorageService','$timeout'];