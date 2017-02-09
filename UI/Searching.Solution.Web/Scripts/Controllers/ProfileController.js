

var ProfileController = function ( $q, $location, $timeout, ApiService, $http, $cookieStore, $scope, CheckAuthService) {
    var loginUser = new LoginUser();
    var user = new User();
    console.log('auth work');
    //console.log(factory);
    $scope.testIf = true;
    loginUser = $cookieStore.get('token');
    console.log(loginUser);
    ApiService.GetMyUser(loginUser.Mail)
    .then(function (response) {
        console.log('GetMyUser success! response:',response.data);
        user = response.data;
        console.log('/////////////////////',loginUser);
        $cookieStore.put('token',loginUser);
        
    });
    $scope.exit = function () {
        $cookieStore.remove('token');
        loginUser.Mail = null;
        loginUser.Password = null;
        $location.path('/Login');
        CheckAuthService.falseStatus(); 
    }
    $scope.GetMyAnnouncing = function () {
        ApiService.GetMyAnnouncing(1)
       .success(function (response) {
           $scope.MyAnn = response;
       });
    }

    $scope.test = function () {
        if($scope.testIf==true)
        {
            $scope.testIf = false;
        } else { $scope.testIf = true;}
    }
};

ProfileController.$inject = [ '$q', '$location', '$timeout', 'ApiService', '$http', '$cookieStore', '$scope','CheckAuthService'];