define(['console', 'app/core/angular.config', 'infragisticsLob', 'toastr', 'jQueryUi'],
    function (console, angularConfig, infragisticsLob, toastr, jQueryUi) {
        "use strict";

        var controller = function ($scope, $location, $routeParams, publisherApiService) {
            console.group("publisher controller entered.");

            $scope.dialogText = "";
            $scope.currentPublisher = null;

            // inits
            $scope.initList = function() {               
                console.log($location.path());                
                $scope.getPublishers();

                $scope.dialogConfirm = $("#dialogConfirm");

                $scope.dialogConfirm.hide();
            };
            // end of inits

            // publishers Actions
            $scope.goToPublisherDetails = function (id) {
                console.log(angularConfig.routes.publisher.details);
                var url = angularConfig.routes.publisher.details.replace("/:id", "?id=" + id);
                window.location.replace(url);
            }

            $scope.getPublishers = function () {
                var promise = publisherApiService.getPublishers();
                promise.then(function(data) {
                    $scope.Publishers = data;
                    console.log($scope.Publishers);
                    toastr['info']("Publishers loaded");
                }, function(status) {
                    console.log(status);
                    toastr['error']("Error loading Publishers");
                });
            };    

            $scope.editPublisher = function (publisher) {
                $scope.goToPublisherDetails(publisher.id);
                return false;
            };

            $scope.activatePublisher = function (publisherId, isActive) {
                alert(publisherId);
                return false;
            };
            
            // end of publishers Actions

            console.groupEnd();
        };
        
        controller.controllerName = angularConfig.core.controllers.common.publisherController;
        controller.$inject = ['$scope', '$location', '$routeParams', angularConfig.core.services.publisherApiService];

        return controller;
    });