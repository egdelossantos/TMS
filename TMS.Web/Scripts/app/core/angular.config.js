// all arv constants live here. 
//later versions of angular you have to ask explicitly for the routing service
define(['console'],
    function (console) {
        console.group("Setting Foundation's Angular Configuration");

        // setup empty js obj structure
        var config = {
            angularAppName: "TerritoryManagementSystem",
            pageTitle: "Territory Management System",
            useDynamicLoading: true,
            core: {},
            routes: {}
        };
        
        config.application = {
            deps: ['ngRoute']
        };

        //routes
        config.routes.home = {};
        config.routes.home.home = '/Home';

        config.routes.callactivity = {};
        config.routes.callactivity.index = '/CallActivity';
        config.routes.callactivity.details = '/tms/CallActivity/Details/:id';

        config.routes.publisher = {};
        config.routes.publisher.index = '/Publisher';

        //services
        config.core.services = {
            commonService: 'common.service',           
            callactivityApiService: 'callactivity.api.service',
            publisherApiService: 'publisher.api.service',
        };

        //controllers
        config.core.controllers = {
            common: {
                menuController: 'menu.controller',
                appController: 'app.controller',
                callactivityController: 'callactivity.controller',
                publisherController: 'publisher.controller'
            }
        };

        config.core.controllers.home = {};
        config.core.controllers.home.homeController = 'home.controller';       

        //diagnostic logging
        console.debug('config:', config);
        console.groupEnd();
        return config;
    });