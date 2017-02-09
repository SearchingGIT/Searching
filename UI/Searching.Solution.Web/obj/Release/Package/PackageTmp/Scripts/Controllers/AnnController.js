

var AnnController = function ($scope, $http, ApiService, $stateParams, Contents, CheckAuthService, $cookieStore) {
    //Filter=clearFilter;
    var filter = new Filter();
    var user = new User();
    var logUser = new LoginUser();
    var status = {};
    var selectedAnn = new SelectedAnn();
    var favoriteAnn = new FavoriteAnn();
    var stateCategory = $stateParams.categories_id;
    console.log('параметр:', stateCategory);
    if (stateCategory != undefined) {
        filter.CategoryId= stateCategory;
    }
    $scope.contents = new Contents(filter);

    $scope.AddtoFavorite = function (ann_id) {
        status = CheckAuthService.check();
        if (!status) return;
            //console.log('Пользователь не авторизирован!');
           //ApiService.AddtoFavorite(favoriteAnn).success(function (response) {
           //    console.log('success');
           //}).error(function (response) {
           //    console.log('fail');
           //});
     
        console.log('Пользователь авторизирован!');
        logUser = $cookieStore.get('token');
        ApiService.GetMyUser(logUser.Mail)
            .success(function (response) {
                console.log(response);
                user = response;
                console.log('Favorite GetMyUser success!', user);
                console.log('user:', user);
                favoriteAnn.Announcing_id = ann_id;
                favoriteAnn.User_id = user.User_id;
                console.log('favorite Ann:', favoriteAnn);
                ApiService.AddtoFavorite(favoriteAnn)
        .then(function (response) {
            console.log('Add to favorite response:', response.data);
            if (response.data.Code == 200) console.log('Операци прошла успешно!');
        })
            }).error(function (fail) {
                console.log('fail', fail);
                return;
            });
    }

    $scope.AddtoSelected = function (ann_id) {
        status = CheckAuthService.check();
        if (!status) return;
        console.log('Пользователь авторизирован!');
        logUser = $cookieStore.get('token');
        ApiService.GetMyUser(logUser.Mail)
            .success(function (response) {
                console.log(response);
                user = response;
                console.log('Favorite GetMyUser success!', user);
                console.log('user:', user);
                selectedAnn.Announcing_id = ann_id;
               selectedAnn.User_id = user.User_id;
               console.log('selected Ann:', selectedAnn);
                ApiService.AddtoSelected(selectedAnn)
        .then(function (response) {
            console.log('Add to selected response:', response.data);
            if (response.data.Code == 200) console.log('Операци прошла успешно!');
        })
            }).error(function (fail) {
                console.log('fail', fail);
                return;
            });
    }
    //$scope.AddAnn = function (ann_id) {

    //    console.log('ann_id:', Ann_id);
    //    var result = CheckAuthService.check();
    //    console.log('result code:', result);
    //    if (result == true) {
    //        console.log('result=true');
    //        ApiService.GetAnnFull(ann_id)
    //        .success(function (response) {
    //            console.log(response);
    //        })
    //        .error(function (fail) {
    //            console.log(fail);
    //        });
    //    }
    //}
}
AnnController.$inject = ['$scope', '$http', 'ApiService', '$stateParams', 'Contents', 'CheckAuthService', '$cookieStore'];