define([
	'console'
	, 'underscore'
    , 'app/core/angular.config'

], function (
    console
        , _
        , angularConfig
       ) {
    "use strict";
    console.group("Entering Filters module.");
       
    angular.module(angularConfig.angularAppName).filter('callActivityFilter', function () {
        return function (input, searchTerm) {
            var out = [];

            if (input == undefined) return out;

            for (var i = 0; i < input.length; i++) {
                    if (searchTerm && searchTerm.length > 0) {
                        searchTerm = searchTerm.toLowerCase();

                        // call type
                        if (input[i].CallType.CallTypeName.toLowerCase().indexOf(searchTerm) > -1) {
                            out.push(input[i]);
                            continue;
                        }

                        // publisher
                        if (input[i].Publisher.Name.toLowerCase().indexOf(searchTerm) > -1 ) {
                            out.push(input[i]);
                            continue;
                        }

                        // date released
                        if (input[i].DateReleasedText.toLowerCase().indexOf(searchTerm) > -1) {
                            out.push(input[i]);
                            continue;
                        }

                        // map name
                        if (input[i].CallGroup.CallGroupName.toLowerCase().indexOf(searchTerm) > -1) {
                            out.push(input[i]);
                            continue;
                        }

                        var keepGoing = true;
                        angular.forEach(input[i].CallActivityAddresses, function (address) {
                            if(keepGoing) {
                                if (address.Address.toLowerCase().indexOf(searchTerm) > -1) {
                                    out.push(input[i]);
                                    keepGoing = false;
                                }
                            }
                        });
                    } else {
                        out.push(input[i]);
                    }
            }
            return out;
        };
    });
    
    var filters = {};

    console.groupEnd();
    return filters;
});