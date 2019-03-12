define([
	'console'
	, 'jQuery'
	, 'underscore'
    , 'angular'
    , 'angularRoutes'
    , 'toastr'
    , 'app/core/angular.config'
    , 'app/core/route-config'
], function (console, $, _, angular, angularRoutes, toastr, angularConfig, routeConfig) {
    "use strict";

    console.group("Starting application.");
    console.group("Setup Angular");

    var app = {};
    var module = angular.module(angularConfig.angularAppName, angularConfig.application.deps, function ($compileProvider, $controllerProvider) {
        // if dynamic loading of controllers/directives is desired.
        if (angularConfig.useDynamicLoading) {
            routeConfig.setCompileProvider($compileProvider);
            routeConfig.setControllerProvider($controllerProvider);
        }
    });


    app.module = module;

    app.init = function init() {
        console.info("Angular compiled and executed.", document);

        // this injector can be used to get services if the application
        // needs to be bootstrapped
        var injector = angular.bootstrap(document, [angularConfig.angularAppName]);
        try {
            //angular.element('html').attr('ng-app', 'test');
        } catch (e) { }

        /*
        var referenceService = injector.get(domainConfig.core.services.referenceService);
        referenceService.loadAllReferenceData();
        */
    };

    console.groupEnd();
    console.groupEnd();

    return app;
});

