function checkPass() {
    'use strict';
    return  {
        require: "ngModel",
        scope: {
            pass: "=checkPass"
        },
        link: function (scope, element, attrs, ctrl) {
            //console.log('work check PASs!!!!!');
                ctrl.$parsers.unshift(function (viewValue) {
                    ctrl.$setValidity('pwErr', scope.pass == viewValue);
                    return viewValue;
                });
                //scope.$watch(me, function (value) {
                //    console.log('watch work!');
                //    console.log(value);
                //ctrl.$setValidity('pwErr', scope.pass == value);
                //});
            }
    }
    //return {
    //    link: function (scope, element, attributes, ngModel) {

    //        ngModel.$validators.compareTo = function (modelValue) {
    //            return modelValue == scope.otherModelValue;
    //        };

    //        scope.$watch("otherModelValue", function () {
    //            ngModel.$validate();
    //        });
    //    },
    //    require: "ngModel",
    //    scope: {
    //        otherModelValue: "=compareTo"
    //    }
    //};
}


    