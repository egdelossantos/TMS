define(['console', 'app/core/angular.config', 'infragisticsLob', 'toastr', 'jQueryUi'],
    function (console, angularConfig, infragisticsLob, toastr, jQueryUi) {
        "use strict";

        var controller = function ($scope, $location, $routeParams, callactivityApiService) {
            console.group("map controller entered.");

            $scope.dialogText = "";
            $scope.currentCallActivity = null;

            // inits
            $scope.initList = function() {               
                console.log($location.path());                
                $scope.getCallActivities();

                $scope.dialogConfirm = $("#dialogConfirm");

                $scope.dialogConfirm.hide();
            };
            // end of inits

            // new address
            $scope.getNewAddresses = function () {
                var promise = callactivityApiService.getCallActivities();
                promise.then(function (data) {
                    $scope.NewAddresses = data;
                    console.log($scope.NewAddresses);
                    toastr['info']("New Addresses  loaded");
                }, function (status) {
                    console.log(status);
                        toastr['error']("Error loading New Addresses");
                });
            };            

            $scope.mapNameOnClick = function (callActivity, rowId) {
                if (!($('#mapAddress' + rowId).hasClass('in'))) {
                    callActivity = $scope.CallActivities[rowId - 1];
                    $scope.getCallActivityAddresses(callActivity, rowId, "");                    
                }
                return false;
            };

            $scope.getCallActivityAddresses = function (callActivity, rowId, todoNext) {
                if (callActivity.CallActivityAddresses == undefined || callActivity.CallActivityAddresses == null || callActivity.CallActivityAddresses.length == 0) {
                    var promise = callactivityApiService.getCallActivityAddresses(callActivity.Id);
                    promise.then(function (data) {
                        callActivity.CallActivityAddresses = data.callAddress;
                        $scope.$apply(function () {
                            $scope.CallActivities[rowId - 1].CallActivityAddresses = callActivity.CallActivityAddresses;
                            //$scope.isGoogleMapHidden(rowId);
                        });
                        $scope.DoNext(callActivity, rowId, todoNext); $scope.DoNext(callActivity, rowId, todoNext);
                    }, function (status) {
                        console.log(status);
                        toastr['error']("Error loading Call Activity Address");
                    });
                }
                else {
                    $scope.DoNext(callActivity, rowId, todoNext);
                }
            };

            $scope.DoNext = function (callActivity, rowId, todoNext) {
                //if (todoNext == "plotmap")
                //{
                //    $scope.plotAddressInMap(callActivity, rowId);
                //}

                if (todoNext == "sendemail") {
                    $scope.sendEmail(callActivity, rowId);
                }
            }
            
            //$scope.refreshMap = function (callActivity, rowId) {                
            //    $scope.plotAddressInMap(callActivity, rowId);            
            //    return false;
            //};

            //$scope.isGoogleMapHidden = function(rowId){
            //    var mapElement = document.getElementById("googleMap" + rowId);
            //    if (mapElement != undefined) {
            //        return mapElement.innerHTML == "";
            //    }
            //    else {
            //        return true;
            //    }
            //}  

            //$scope.plotAddressInMap = function (callActivity, rowId) {                
            //    var mapElement = document.getElementById("googleMap" + rowId);
            //    plotAddressInMap(callActivity.CallActivityAddresses, mapElement);                
            //    return false;
            //};

            // end of maps

            console.groupEnd();
        };
        
        controller.controllerName = angularConfig.core.controllers.common.callactivityController;
        controller.$inject = ['$scope', '$location', '$routeParams', angularConfig.core.services.callactivityApiService];

        return controller;
    });