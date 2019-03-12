"use strict";

require.config(requireConfig);

//top-level require: bootstrap-in the require configuration
require(['require'], function (require) {
    //next require: load some requried libraries, and make sure app/app is always loaded before any other angular scripts    
    require(['console', 'toastr', 'supplant', 'bootstrap', 'app/core/jsextensions', 'app/app'],
        function (console, toastr, supplant, bootstrap, jsExtensions, app) {
            console.group("Bootstrap dependencies loaded. Starting bootstrap.");

            //next require: start the application :)
            require([
                    'app/core/routes',
                    'app/core/services',
                    'app/core/filters',
                    'app/core/controllers',
                    'app/core/directives'
            ], function (routes, controllers, directives, services, filters) {
                console.group("Starting bootstrap.");
                console.info("App: ", app);

                app.init();

                console.debug('angular loaded :)');
                window.angularLoaded = true;

                console.groupEnd();
            });

            console.groupEnd();
        });
});

//remove require from the global namespace :)
//the only way to get one will be via a dependency in 'define'
require = undefined;
requirejs = undefined;