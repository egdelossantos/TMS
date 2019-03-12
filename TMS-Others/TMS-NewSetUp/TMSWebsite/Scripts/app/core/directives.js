define([
	'console'
	, 'underscore'
    , 'app/core/angular.config'
    , 'app/directives/common.sense'
    , 'app/directives/date'
    , 'app/directives/integer'
    , 'app/directives/validation.message'
], function (
      console
    , _
    , angularConfig
    , validationMessages
    , integer
    , commonSense
    , date
    ) {
    
    "use strict";
    console.group("Entering directives module.");

    var directives = {
        validationMessages: validationMessages,
        integer: integer,
        commonSense: commonSense,
        date: date
    };

    _.each(directives, function (value, key) {
        console.debug("Adding directive ", key, ":", value.directiveName);
        angular.module(angularConfig.angularAppName).directive(value.directiveName, value);
    });

    console.info("Registered directives: ", directives);

    console.groupEnd();
    return directives;
});