define(['console', 'app/core/angular.config'],
    function (console, angularConfig) {
        "use strict";
        console.group("Entering AppController module.");

        var controller = function ($scope, $location) {
            console.group("AppController entered");

            $scope.isBusy = false;
            $scope.pageTitle = angularConfig.pageTitle;

            console.groupEnd();
        };
        controller.$inject = ['$scope', '$location'];

        controller.$eager = true;
        controller.controllerName = angularConfig.core.controllers.common.appController;

        console.groupEnd();
        return controller;
    });