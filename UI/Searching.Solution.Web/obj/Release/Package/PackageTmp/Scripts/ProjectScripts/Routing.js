
var configFunction = function ($stateProvider, $httpProvider, $locationProvider, $routeProvider, $urlRouterProvider) {
    //$httpProvider.defaults.transformResponse.push(function (responseData) {
    //    convertJsonDateToDates(responseData);
    //   // console.log('--------------response data:',responseData);
    //    return responseData;
    //});
    //var newBaseUrl = "";
    //if (window.location.hostname == "localhost") {
    //    newBaseUrl = "http://localhost:14396/Scripts";
    //} else {
    //    var deployedAt = window.location.href.substring(0, window.location.href);
    //    newBaseUrl = deployedAt + "/Scripts";
    //}
    //RestangularProvider.setBaseUrl(newBaseUrl);

    //$routeProvider.otherwise({ redirectTo: '/search/' });

    //$locationProvider.hashPrefix('!').html5Mode(true);
    $locationProvider.html5Mode({
        enabled: true,
        requireBase: false
    }).hashPrefix('!');
    $urlRouterProvider.otherwise('/search');
    $stateProvider

        .state('root', {
            abstract:true,
            views: {
                "@root": {
                    templateUrl: '/Ann/UserBlock' ,
                    controller:StartController
                }
            }     
        })

        .state('search.root', {
            parent: 'root',
            url: '/search',
            views:{
                '@root': { templateUrl: '/Ann/UserBlock' }
            }
            
        })
            
        //.state('start', {
        //    url: '/',
        //    controller: LoadController
        //})
        //.state('stateSearch', {
        //    url: '/Search',
        //    views: {
        //        "ContentContainer": {
        //            templateUrl: '/Navigation/Search',
        //            controller: SearchController
                        
        //        },
        //        "AnnContainer@stateSearch": {
        //            templateUrl: '/Ann/AnnouncingList',
        //            controller: AnnController
        //        }
        //    }
        //})

        //.state('stateSearch.Announcing', {
        //    url: '/Announcing?categories_id',
        //    views: {
        //        "AnnContainer": {
        //            templateUrl: function (param) { return '/Ann/AnnouncingList?categories_id=' + param.categories_id; },
        //            controller: AnnController
        //        }
        //    }
        //})

        .state('stateAnn', {
            url: '/Announc',
            views: {
                "ContentContainer": {
                    templateUrl: '/Search/Test'
                }
            }
        })
        
        .state('stateProfile', {
            url: '/Profile',
            views: {
                "ContentContainer": {
                    templateUrl: '/Navigation/Profile',
                    controller: ProfileController,
                    resolve: {
                        factory: AuthService
                        }
                }
                //"ProfileContainer@stateProfile": {
                //    templateUrl: '/Navigation/Profile',
                //    controller: ProfileController,
                //    resolve: {
                //        factory: AuthService
                //    }
                //}
                }
        })

        .state('stateLogin', {
            url: '/Login',
            views: {
                "ContentContainer": {
                    templateUrl: '/Profile/Login',
                    controller: LoginController,
                    resolve: {
                        factory: LoginService
                    }
                } 
            }
        })

        .state('stateRegistration', {
            url: '/Registration',
            views: {
                "ContentContainer": {
                    templateUrl: '/Profile/Registration',
                    controller: RegistrationController
                }
            }
        })
        
    .state('home.Announcing', {
        url: 'Announcing?categories_id',
        views: {
            "AnnContainer": {
                templateUrl: function (param) { return '/Ann/AnnBlock?categories_id=' + param.categories_id; },
                //templateUrl: '/Ann/AnnBlock',
                controller: AnnController
            }
        }
    })

    .state('Messages', {
        url: '/messages',
        templateUrl: 'Home/StartPage',
        views: {
            "ContentContainer": {
                templateUrl: '/Navigation/Messages',
                controller: MessageController,
                resolve: {
                    factory: AuthService
                }       
            }
        }
    })

    
}
configFunction.$inject = ['$stateProvider', '$httpProvider', '$locationProvider','$routeProvider','$urlRouterProvider'];
app.config(configFunction);
