define([
	  'console'
	, 'angular'
    , 'app/core/config'
    , 'app/core/route-config'
    , 'app/core/angular.config'
], function (console, angular, config, routeConfig, angularConfig) {
    "use strict";
    var routes = {};

    console.group("Setting up routing.");

    routes = angular.module(angularConfig.angularAppName).config(['$routeProvider', function ($routeProvider) {

        console.log("Config");
        console.debug(config);
        console.debug("Virtual Path: " + config.virtualPath);

        if(angularConfig.useDynamicLoading){          
            $routeProvider.when(angularConfig.routes.callactivity.index,
                                routeConfig.config(config.virtualPath + '/views/callactivity/index', 'app/controllers/callactivity.controller'));

            $routeProvider.when(angularConfig.routes.callactivity.details,
                                routeConfig.config(config.virtualPath + '/views/callactivity/details', 'app/controllers/callactivity.controller'));

            $routeProvider.when(angularConfig.routes.publisher.index,
                                routeConfig.config(config.virtualPath + '/views/publisher/publisherindex', 'app/controllers/publisher.controller'));
        }
        else{
            //TODO add non-dynamic controller loading
        }

        //default page...
        $routeProvider.otherwise({ redirectTo: angularConfig.routes.home.home });
        
    }]);

    console.debug("route obj", routes);
    console.groupEnd();

    return routes;
});

