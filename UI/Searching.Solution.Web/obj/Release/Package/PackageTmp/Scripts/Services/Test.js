//var authTest = function ($cookies, $http, ApiService) {
//    'use strict';
//    var self = this;
//    this.status = {
//        authorized: false,
//    };

//    this.loginByCredentials = function (username, password) {

//        return Restangular.all('sessions').post({ email: username, password: password })
//        .then(function (response) {
//            console.log('loginByCredentials success!Result:', response);
//            return self.loginByToken(response);
//        });
        
//    };
//    this.loginByToken = function (token) {
//        $http.defaults.headers.common['X-Token'] = token;
//        return Restangular.all('sessions').get(token)
//        .then(function (response) {
//            console.log('loginByToken success!Result:', response);
//            $cookies.accesToken = token;
//            self.status.authorized = true;
//            return response;
//        });
//    };

//    this.logout = function () {
//        self.status.authorized = false;
//        $cookies.accesToken = '';
//        Restangular.all('sessions').remove();
//    };

//};
//authTest.$inject = ['$cookies', '$http', 'ApiService'];