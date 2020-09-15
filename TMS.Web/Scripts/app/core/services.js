define([
	  'console'
	, 'underscore'
    , 'app/core/angular.config'   
    , 'app/services/common.service'
    , 'app/services/callactivity.api.service'
    , 'app/services/publisher.api.service'
    , 'app/services/calladdress.api.service'
], function (
          console
        , _
        , angularConfig       
        , commonService
        , callactivityApiService
        , publisherApiService
        , calladdressApiService

) {
    "use strict";
    console.group("Entering Service module.");

    var services = {
        commonService : commonService, 
        callactivityApiService: callactivityApiService,
        publisherApiService: publisherApiService,
        calladdressApiService: calladdressApiService
    };

    _.each(services, function (value, key) {
        console.debug("Adding service ", key, ":", value.serviceName);
        angular.module(angularConfig.angularAppName).factory(value.serviceName, value);
    });

    console.groupEnd();
    return services;
});