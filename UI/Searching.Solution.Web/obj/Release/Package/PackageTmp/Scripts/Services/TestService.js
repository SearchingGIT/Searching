//var _user = {
//    User_id: null,
//    Mail: 'Cp5@mail1er.ru',
//    Name: null,
//    LastName: null,
//    Phone: null,
//    Gender_user: null,
//    Date_Bearthday: null,
//    Password: 'Adolf1231',
//    Info: null,
//    Country_id: null,
//    Type_login: null,
//    City_id: null
//};

var result = {};

var TestService = function ($q, $http, $location, $cookieStore, ApiService) {

    //var deferred = $q.defer();
    
    //$location.path("/Login");
    
    //return deferred.promise;

    




    $cookieStore.put('token', _user);
    var deferred = $q.defer();
    if ($cookieStore.get('token')) {
        console.log('cookies store has value');
        var authUser = $cookieStore.get('token');
        console.log('authUser getting value');
        ApiService.Auth(authUser)
        .success(function (response) {
            result = response;
            //deferred.resolve(response);
            console.log('apiservice.auth success!');
            console.log('response code:');
            console.log(response['Code']);
            if(response['Code']==false)
            {
                //deferred.reject();
                $location.path("/Login");
                
            } else { deferred.resolve(response);}
            
        })
        .error(function (fail) {
            console.log('ApiService.Auth have fail!');
            deferred.reject(fail);
        });
    }else{
    console.log('cookies store dont have value');
    $location.path("/Login");
    }
    
    return deferred.promise;
};
TestService.$inject = ['$q', '$http', '$location','$cookieStore','ApiService'];