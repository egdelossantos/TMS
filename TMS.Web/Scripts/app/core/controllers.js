define([
	  'console'
	, 'underscore'
    , 'app/core/angular.config'
    , 'app/controllers/app.controller'
    , 'app/controllers/menu.controller'
    , 'app/controllers/callactivity.controller'
    , 'app/controllers/publisher.controller'
    , 'app/controllers/calladdress.controller'
], function (
        console
        , _
        , angularConfig
        , appController
        , menuController
        , callactivityController
        , publisherController
        , calladdressController
    ) {
    "use strict";
    console.group("Entering controllers module.");

    var registeredControllers = {
        appController: appController,
        menuController: menuController,
        callactivityController: callactivityController,
        publisherController: publisherController,
        calladdressController: calladdressController
    };

    _.each(registeredControllers, function (value, key) {
        console.debug("Adding ", key, ":", value.controllerName);
        angular.module(angularConfig.angularAppName).controller(value.controllerName, value);
    });

    console.info("Registered Controllers: ", registeredControllers);

    console.groupEnd();
    return registeredControllers;
});