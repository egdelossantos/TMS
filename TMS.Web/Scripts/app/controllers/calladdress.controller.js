define(['console', 'app/core/angular.config', 'infragisticsLob', 'toastr', 'jQueryUi'],
    function (console, angularConfig, infragisticsLob, toastr, jQueryUi) {
        "use strict";

        var controller = function ($scope, $location, $routeParams, calladdressApiService) {
        };

        controller.controllerName = angularConfig.core.controllers.common.calladdressController;
        controller.$inject = ['$scope', '$location', '$routeParams', angularConfig.core.services.calladdressApiService];

        return controller;
    }
);