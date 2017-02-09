
var LoginService = function ($q, $location, ApiService, $cookieStore, $http, CheckAuthService) {
    console.log('login Service');
    //var loginUser = new LoginUser();
    //var deferred = $q.defer();
    //if ($cookieStore.get('token')) {
    //    console.log('cookies store has value');
    //    loginUser = $cookieStore.get('token');
    //    console.log('loginUser getting value', loginUser);
    //    ApiService.Auth(loginUser)
    //    .success(function (response) {
    //        //result = response;
    //        //deferred.resolve(response);
    //        console.log('apiservice.auth success! Response code:', response['Code']);
    //        if (response['Code'] == false) {
    //            CheckAuthService.status.authorized = false;
    //            //deferred.reject();
    //            $location.path("/Login");

    //        } else { deferred.resolve(response); CheckAuthService.status.authorized = true; $location.path("/search/"); }

    //    })
    //    .error(function (fail) {
    //        CheckAuthService.status.authorized = false;
    //        console.log('ApiService.Auth have fail!');
    //        deferred.reject(fail);
    //    });
    //} else {
    //    CheckAuthService.status.authorized = false;
    //    console.log('cookies store dont have value');
    //    $location.path("/Login");
    //}

    //return deferred.promise;
    var deferred = $q.defer();
    var status = CheckAuthService.status.authorized;
    console.log('status:', status);
    if (status == true) {
        console.log('CheckAuthService.status.authorized == true');
        $location.path("/search/");
    } else 
        if (status == false) {
            console.log('CheckAuthService.status.authorized:', CheckAuthService.status.authorized);
            deferred.resolve();
        } else {
            deferred.resolve();
        }
        //else
            //if (status == null) {
            //    setTimeout(function () {
            //        if (status == true) {
            //            console.log('CheckAuthService.status.authorized == true');
            //            $location.path("/search/");
            //        }
            //    });
            //}
    return deferred.promise;
};
LoginService.$inject = ['$q', '$location', 'ApiService', '$cookieStore', '$http', 'CheckAuthService'];