define(['console', 'app/core/config', 'app/core/angular.config'
], function (console, config, angularConfig) {
    "use strict";
    console.group("Entering menu controller module.");

    var controller = function ($scope, $location) {
        console.debug("****** menu controller entered");

        $scope.applicationDisplayName = angularConfig.angularAppName;

        $scope.goToHome = function () {
            $location.path(angularConfig.routes.home.home);
        };

        $scope.goToCallActivity = function () {
            $location.path(angularConfig.routes.callactivity.index);
        };
    };
    controller.$inject = ['$scope', '$location'];

    controller.$eager = true;
    controller.controllerName = angularConfig.core.controllers.common.menuController;

    console.groupEnd();
    return controller;
});