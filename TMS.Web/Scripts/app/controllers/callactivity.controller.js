define(['console', 'app/core/angular.config', 'infragisticsLob', 'toastr', 'jQueryUi'],
    function (console, angularConfig, infragisticsLob, toastr, jQueryUi) {
        "use strict";

        var controller = function ($scope, $location, $routeParams, callactivityApiService) {
            console.group("call activity controller entered.");

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

            // call activities 
            $scope.updateAddress = function () {
                var promise = callactivityApiService.updateAddress(1);
                promise.then(function (data) {
                    $scope.CallActivities = data;
                    console.log($scope.CallActivities);
                    toastr['info']("Call Activities  loaded");
                }, function (status) {
                    console.log(status);
                    toastr['error']("Error loading Call Activities");
                });
            };


            // call activities 
            $scope.getCallActivities = function() {
                var promise = callactivityApiService.getCallActivities();
                promise.then(function(data) {
                    $scope.CallActivities = data;
                    console.log($scope.CallActivities);
                    toastr['info']("Call Activities  loaded");                  
                }, function(status) {
                    console.log(status);
                    toastr['error']("Error loading Call Activities");
                });
            };

            // navigation
            $scope.goToCallActivityList = function() {
                $location.path(angularConfig.routes.callactivity.index);
            }

            $scope.goToCallActivityDetails = function (id) {
                console.log(angularConfig.routes.callactivity.details);
                var url = angularConfig.routes.callactivity.details.replace("/:id", "?id=" + id);
                window.location.replace(url);
            }

            $scope.addCallActivity = function () {
                var promise = callactivityApiService.isMapAvailable();
                promise.then(function (data) {
                    if (data.isMapAvailable == false) {
                        toastr['error']("No available map to assign. Please contact Territory Overseer.");
                    }
                    else {
                        $scope.goToCallActivityDetails(0);
                    }
                }, function (status) {
                    console.log(status);
                    toastr['error']("Error checking Map availability");
                });                
                
                return false;
            };

            $scope.editCallActivity = function (callActivity) {
                $scope.goToCallActivityDetails(callActivity.Id);
                return false;
            };

            $scope.onDeleteClick = function (callActivity) {
                $scope.currentCallActivity = callActivity;
                $scope.dialogConfirm.show();
            };           

            $scope.deleteCallActivity = function () {
                var promise = callactivityApiService.deleteCallActivity($scope.currentCallActivity);
                promise.then(function (data) {
                    if (data == '""') {
                        toastr['info']("Call Activity deleted");
                        $scope.getCallActivities();
                    }
                    else {
                        toastr['error'](data);
                    }                    
                }, function (status) {
                    console.log(status);
                    toastr['error']("Error deleting Call Activity");                    
                });
                
                $scope.dialogConfirm.modal('hide');
               
                return;
            };

            $scope.emailCallActivity = function (callActivity, rowId) {
                if (callActivity.Publisher.EmailAddress == null || callActivity.Publisher.EmailAddress == "") {
                    toastr['error']("Cannot send email." + callActivity.Publisher.Name + " doesn't have email address.");
                }
                else {
                    $scope.getCallActivityAddresses(callActivity, rowId, "sendemail");
                }

                return false;
            };

            $scope.mapNameOnClick = function (callActivity, rowId) {
                if (!($('#mapAddress' + rowId).hasClass('in'))) {
                    callActivity = $scope.CallActivities[rowId - 1];
                    $scope.getCallActivityAddresses(callActivity, rowId, "plotmap");                    
                }
                return false;
            };
            
            $scope.refreshMap = function (callActivity, rowId) {                
                $scope.plotAddressInMap(callActivity, rowId);            
                return false;
            };

            $scope.isGoogleMapHidden = function(rowId){
                var mapElement = document.getElementById("googleMap" + rowId);
                if (mapElement != undefined) {
                    return mapElement.innerHTML == "";
                }
                else {
                    return true;
                }
            }

            $scope.getCallActivityAddresses = function (callActivity, rowId, todoNext) {
                if (callActivity.CallActivityAddresses == undefined || callActivity.CallActivityAddresses == null || callActivity.CallActivityAddresses.length == 0) {
                    var promise = callactivityApiService.getCallActivityAddresses(callActivity.Id);
                    promise.then(function (data) {
                        callActivity.CallActivityAddresses = data.callAddress;
                        $scope.$apply(function () {
                            $scope.CallActivities[rowId - 1].CallActivityAddresses = callActivity.CallActivityAddresses;
                            $scope.isGoogleMapHidden(rowId);
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
                if (todoNext == "plotmap")
                {
                    $scope.plotAddressInMap(callActivity, rowId);
                }
               
                if (todoNext == "sendemail") {
                    $scope.sendEmail(callActivity, rowId);
                }                    
            }

            $scope.plotAddressInMap = function (callActivity, rowId) {                
                var mapElement = document.getElementById("googleMap" + rowId);
                plotAddressInMap(callActivity.CallActivityAddresses, mapElement);                
                return false;
            };

            $scope.navigateToAddress = function (callActivityAddress) {
                var address = callActivityAddress.GpsAddress.replace(/ /g, "+"); 
                var googleMapUrl = "https://www.google.com/maps/dir/?api=1&destination=[destination]";
                var url = googleMapUrl.replace("[destination]", address);
                window.open(url, "_blank");
                return false;
            };

            $scope.sendEmail = function (callActivity, rowId) {
                var divId = "#mapAddress" + rowId;
                var htmlDiv = $(divId).html();
                callActivity.ContentHtml = htmlDiv;
                var promise = callactivityApiService.emailCallAddress(callActivity);
                promise.then(function (data) {
                    if (data == '"Ok"') {
                        toastr['info']("Email Sent");
                    }
                    else {
                        toastr['error'](data);
                    }
                }, function (status) {
                    console.log(status);
                    toastr['error']("Error sending email");
                });
            }
            // end of call activities

            console.groupEnd();
        };
        
        controller.controllerName = angularConfig.core.controllers.common.callactivityController;
        controller.$inject = ['$scope', '$location', '$routeParams', angularConfig.core.services.callactivityApiService];

        return controller;
    });