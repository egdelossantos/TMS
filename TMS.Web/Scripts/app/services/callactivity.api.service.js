define(['console'
    , 'app/core/config'
    , 'app/core/angular.config'
], function (
    console
    , config
    , angularConfig
) {
    "use strict";

    var service = function (commonService) {
        var result = {};

        result.getCallActivities = function() {
            var url = "CallActivity/GetCallActivities/";
            return commonService.doGetRequestAndReturnPromise(url, {});
        };

        result.getCallActivityAddresses = function (callActivityId) {
            var url = "CallActivity/GetCallActivityAddresses?callActivityId=" + callActivityId;
            return commonService.doGetRequestAndReturnPromise(url, {});
        };

        result.deleteCallActivity = function (callActivity) {
            var url = "CallActivity/DeleteCallActivity";
            return commonService.doPostRequestAndReturnPromiseForData(url, callActivity);
        };

        result.emailCallAddress = function (callActivity, contentHtml) {
            var url = "CallActivity/EmailCallAddress";
            return commonService.doPostRequestAndReturnPromiseForData(url, callActivity);
        };

        result.updateAddress = function (suburbId) {
            var url = "Map/UpdateMapPoint?suburbId=" + suburbId;
            return commonService.doGetRequestAndReturnPromise(url, {});
        };

        result.isMapAvailable = function () {
            var url = "CallActivity/IsMapAvailable/";
            return commonService.doGetRequestAndReturnPromise(url, {});
        };

        console.debug('callactivityApiService factory was called and an object was returned', result);
        return result;
    };

    service.serviceName = angularConfig.core.services.callactivityApiService;

    service.$inject = [angularConfig.core.services.commonService];

    console.debug('package api service created');
    return service;
});