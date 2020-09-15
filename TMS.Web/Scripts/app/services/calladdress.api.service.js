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

            console.debug('calladdressApiService factory was called and an object was returned', result);
            return result;
        };

        service.serviceName = angularConfig.core.services.calladdressApiService;

        service.$inject = [angularConfig.core.services.commonService];

        console.debug('calladdress api service created');
        return service;
});