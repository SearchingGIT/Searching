var app = angular.module('appModule', ['ui.router', 'ui.bootstrap', 'LocalStorageModule', 'ngCookies', 'ngMessages', 'ngRoute', 'infinite-scroll']);
//controllers

app.controller('SearchController', SearchController);
app.controller('AnnController', AnnController);
app.controller('StartController', StartController);
app.controller('ProfileController', ProfileController);
app.controller('LoginController', LoginController);
app.controller('RegistrationController', RegistrationController);
app.controller('LoadController', LoadController);
app.controller('MessageController', MessageController);





//services

app.service('AuthService', AuthService);
app.service('ApiService', ApiService);
app.service('TestService', TestService);
app.service('CheckAuthService',CheckAuthService);
app.service('LoginService', LoginService);
app.service('StartService', StartService);

//Directions

app.directive("checkPass", checkPass);
app.directive("scroll", scroll);
app.directive("foo", foo);


//factories
app.service('Contents', Contents);

//filters
app.filter("DateFilter",DateFilter);



