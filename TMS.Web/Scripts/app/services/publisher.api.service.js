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

        result.getPublishers = function() {
            var url = "Publisher/GetPublishers/";
            return commonService.doGetRequestAndReturnPromise(url, {});
        };

        console.debug('publisherApiService factory was called and an object was returned', result);
        return result;
    };

    service.serviceName = angularConfig.core.services.publisherApiService;

    service.$inject = [angularConfig.core.services.commonService];

    console.debug('package api service created');
    return service;
});