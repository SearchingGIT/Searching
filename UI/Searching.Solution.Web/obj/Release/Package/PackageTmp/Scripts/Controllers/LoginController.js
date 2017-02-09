
var LoginController = function ($scope, ApiService, $location, $cookieStore, CheckAuthService) {
    console.log('Login Controller is loading!');
    var loginUser = new LoginUser();
    //var model = this;
    $scope.password = '';
    $scope.email = '';

    $scope.submit = function (isValid) {
        loginUser.Mail = $scope.email;
        loginUser.Password = $scope.password;
        console.log(loginUser);
        ApiService.Auth(loginUser)
        .success(function (response) {
            console.log('Auth Code:',response);
            if (response.Code == true) {
                $cookieStore.put('token', loginUser);
                CheckAuthService.trueStatus();
                $location.path('/Profile');
            }
        })
        .error(function (fail) {
            console.log(fail);
        })
        if (isValid) {
            console.log("isValid=true");
        }
        else {
            console.log("isValid=false");
        }

    }

};


LoginController.$inject = ['$scope', 'ApiService', '$location', '$cookieStore', 'CheckAuthService'];

