var StartController = function ($scope, $http, ApiService, CheckAuthService, $cookieStore, $location) {
    $scope.authUser = false;
    var loginUser = new LoginUser();
    var user = new User();
   
    $scope.CheckService = CheckAuthService;
    // $scope.authUser = CheckAuthService.check();
    //if ($cookieStore.get('token')) {
    //    console.log('cookies store has value');
    //    loginUser = $cookieStore.get('token');
    //    console.log('cookiesStore get value in loginUser:', loginUser);
    //    ApiService.Auth(loginUser)
    //    .success(function (response) {
    //        //result = response;
    //        //deferred.resolve(response);
    //        console.log('apiservice.auth success!');
    //        console.log('Response Code:', response['Code']);
    //        if (response['Code'] == false) {
    //            $scope.CheckService.status.authorized = false;
    //        } else {
    //            $scope.CheckService.status.authorized = true;
    //            ApiService.GetMyUser(loginUser.Mail)
    //                .success(function (response) {
    //                    $scope.user = response;
    //                    console.log('user:', $scope.user);
    //                })
    //        }

    //    })
    //    .error(function (fail) {
    //        console.log('ApiService.Auth have fail!');
    //        $scope.CheckService.status.authorized = false;
    //    });
    //} else {
    //    console.log('cookies store dont have value');
    //    $scope.CheckService.status.authorized = false;
    //}

    // if ($scope.authUser == true) {
    //     console.log('$scope.authUser:', $scope.authUser);
    //    loginUser = $cookieStore.get('token');
    //    ApiService.GetMyUser(loginUser.Mail)
    //    .success(function (response) {
    //        $scope.user = response;
    //        console.log('user:', $scope.user);
    //    })
    //    .error(function (fail) {
    //        console.log('fail',fail);
    //    }
    //    );
        
    //} else {
    //    console.log('Not Auth user');
    //}

    console.log('Start Controller!');
    $scope.Clear = function () {
        console.log('clear work!')
        console.clear();
        ApiService.ClearFilter();
    };
    $scope.TestAnn = function (Ann_id) {
        console.log('ann_id:', Ann_id);
        var result = CheckAuthService.check();
        console.log('result code:',result);
        if (result == true) {
            console.log('result=true');
            ApiService.GetAnnFull(Ann_id)
            .success(function (response) {
                console.log(response);
            })
            .error(function (fail) {
                console.log(fail);
            });
        }
    }

    $scope.exit = function () {
        $cookieStore.remove('token');
        loginUser.Mail = null;
        loginUser.Password = null;
        $location.path('/Login');
        CheckAuthService.falseStatus();

    }

    $scope.$watch('CheckService.status.authorized', function (newVal) {
        console.log('Check Service change Value:', newVal);
        $scope.authUser = newVal;
        if ($scope.authUser == true) {
            console.log('$scope.authUser:', $scope.authUser);
            loginUser = $cookieStore.get('token');
            ApiService.GetMyUser(loginUser.Mail)
            .success(function (response) {
                $scope.user = response;
                console.log('user:', $scope.user);
            })
            .error(function (fail) {
                console.log('fail', fail);
            }
            );

        } else {
            console.log('Not Auth user');
            $location.path('/Login');
        }
    })
}
StartController.$inject = ['$scope', '$http', 'ApiService', 'CheckAuthService', '$cookieStore', '$location'];