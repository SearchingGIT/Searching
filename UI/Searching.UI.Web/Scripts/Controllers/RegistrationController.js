


var RegistrationController = function ($scope, ApiService, $location, $cookieStore) {
    console.log('Registration Controller is loading!');
    var regUser = new RegUser();
    var user = new User();
    //var model = this;
    //$scope.AuthUser = {
    //    Mail: "eqweqweqw",
    //    Password: "twewqewq",
    //    confirmPassword:"test"
    //};
    $scope.password = '';
    $scope.confirmPassword = '';
    $scope.email = '';
    $scope.userName = '';
    $scope.userLastName = '';

    $scope.submit = function (isValid) {
        console.log("h");
        console.log(isValid);
        if (isValid==false) {
            console.log('is valid =false');
        }
        else {
            console.log("isValid=true");
            regUser.Mail = $scope.email;
            regUser.Password = $scope.password;
            regUser.Name = $scope.userName;
            regUser.LastName = $scope.userLastName;
            console.log(regUser);
            ApiService.RegUser(regUser)
            .success(function (response) {

                user.Mail = regUser.Mail;
                user.Password = regUser.Password;
                console.log(user);
                $cookieStore.put('token', user);
                $location.path('/Profile');
            })
            .error(function (fail) {
                console.log(fail);
            });
        }
    }

};


RegistrationController.$inject = ['$scope', 'ApiService','$location','$cookieStore'];

