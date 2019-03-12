define(['require', 'app/core/lazy-directives'], function (require, lazyDirectives) {

    var $controllerProvider,
        $compileProvider;

    function setControllerProvider(value) {
        $controllerProvider = value;
    }

    function setCompileProvider(value) {
        $compileProvider = value;
        lazyDirectives.setCompileProvider(value);
    }

    function config(templateUrl, controllerName, controllers, directives) {
        if (!$controllerProvider) {
            throw new Error("$controllerProvider is not set!");
        }

        var defer,
            html,
            routeDefinition = {};

        routeDefinition.templateUrl = templateUrl;
        /*
        routeDefinition.template = function () {
            return html;
        };
        */
        routeDefinition.controller = controllerName;
        routeDefinition.resolve = {
            delay: function($q, $rootScope) {
                defer = $q.defer();
                if (!html) {
                    //                    var dependencies = [controllerName, "text!" + templateUrl];
                    var dependencies = ["text!" + templateUrl, controllerName];
                    if (controllers) {
                        dependencies = dependencies.concat(controllers);
                    }
                    if (directives) {
                        dependencies = dependencies.concat(directives);
                    }
                    require(dependencies, function() {
                        var template = arguments[0];
                        $controllerProvider.register(controllerName, arguments[1]);

                        if (controllers) {
                            for (var i = 2; i < 2 + controllers.length; i++) {
                                $controllerProvider.register(arguments[i].controllerName, arguments[i]);
                               // $controllerProvider.register(arguments[i][0], arguments[i][1]);
                            }
                        }
                        if (directives) {
                            for (var i = 2 + (controllers == null ? 0 : controllers.length); i < arguments.length; i++) {
                                lazyDirectives.register(arguments[i]);
                            }
                        }

                        //html = template;
                        defer.resolve();
                        $rootScope.$apply();
                    });

                } else {
                    defer.resolve();
                }
                return defer.promise;
            }
        };

        return routeDefinition;
    }

    return {
        setControllerProvider: setControllerProvider,
        setCompileProvider: setCompileProvider,
        config: config
    };
})

