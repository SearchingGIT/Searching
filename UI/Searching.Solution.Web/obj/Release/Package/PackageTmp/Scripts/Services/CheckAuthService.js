
var CheckAuthService = function ($cookieStore,$q,ApiService,$rootScope) {
    this.status = {
        authorized: null,
    };
    var self=this;
    var loginUser = {};
    var user = new User();
    this.GetUser=function()
    {
        var result = {};
        result = $cookieStore.get('token');
             ApiService.GetMyUser(result.Mail)
             .success(function (response) {
                 console.log('GetUser response:', response);
                 user = response;
             }).error(function (fail) {
                 console.log('fail');
             }); 
             return user;
    }


    this.check = function () {
        if ($cookieStore.get('token')) {
            console.log('cookies store has value');
            loginUser = $cookieStore.get('token');
            console.log('cookiesStore get value in loginUser:',loginUser);
            ApiService.Auth(loginUser)
            .success(function (response) {
                //result = response;
                //deferred.resolve(response);
                console.log('apiservice.auth success!');
                console.log('Response Code:',response['Code']);
                if (response['Code'] == false) {
                    //deferred.reject();
                    self.status.authorized = false;

                } else { self.status.authorized = true; }

            })
            .error(function (fail) {
                console.log('ApiService.Auth have fail!');
                self.status.authorized = false;
            });
        } else {
            console.log('cookies store dont have value');
            self.status.authorized = false;
        }
        
        return self.status.authorized;
    }
    this.trueStatus = function () {
       
            self.status.authorized = true;
       
    };
    this.falseStatus = function () {

        self.status.authorized = false;

    };
}

CheckAuthService.$inject = ['$cookieStore','$q','ApiService','$rootScope'];