var LoadController = function ($location) {
    console.log('loadController success');
    $location.path('/search/');
};
LoadController.$inject = ['$location'];