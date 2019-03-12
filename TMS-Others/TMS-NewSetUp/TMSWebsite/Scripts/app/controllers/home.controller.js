define(['console', 'app/core/angular.config', 'infragisticsLob'],
    function (console, angularConfig) {
        "use strict";

        var getBindings = function () {
            return {
                textKey: "Name",
                valueKey: "Id",
                childDataProperty: "Questions",
                bindings: {
                    textKey: "Name",
                    valueKey: "Id",
                    childDataProperty: "Answers",
                    bindings: {
                        textKey: "Name",
                        valueKey: "Id"
                    }
                }
            };
        };

        var controller = function ($scope, $http, $q, apiService) {
            console.group("home controller entered.");
            $scope.message = "PLACEHOLDER";
            $scope.isLoading = true;
            $scope.LoadingStatus = "Loading.....";

            $scope.getCallActivities = function () {
                var promise = apiService.getCallActivities();
                promise.then(function (data) {
                    $scope.CallActivities = data;
                    console.log($scope.Packages);
                    toastr['info']("Call Activities loaded");                 
                }, function (status) {
                    console.log(status);
                    toastr['error']("Error loading CallActivities");
                });
            };           

            console.groupEnd();
        };

        controller.controllerName = angularConfig.core.controllers.home.home;
        controller.$inject = ['$scope', '$http', '$q', angularConfig.core.services.apiService];

        return controller;
    });