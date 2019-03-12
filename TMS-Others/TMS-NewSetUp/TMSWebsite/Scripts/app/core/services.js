define([
	  'console'
	, 'underscore'
    , 'app/core/angular.config'   
    , 'app/services/common.service'
    , 'app/services/callactivity.api.service'  
], function (
          console
        , _
        , angularConfig       
        , commonService
        , callactivityApiService      

) {
    "use strict";
    console.group("Entering Service module.");

    var services = {
        commonService : commonService, 
        callactivityApiService: callactivityApiService
    };

    _.each(services, function (value, key) {
        console.debug("Adding service ", key, ":", value.serviceName);
        angular.module(angularConfig.angularAppName).factory(value.serviceName, value);
    });

    console.groupEnd();
    return services;
});