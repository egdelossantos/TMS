define(['console'], function (console) {
    "use strict";
    console.group("Entering integer directive.");
    var INTEGER_REGEXP = /^\-?\d*$/;
    
    var directive =
        function() {
            return {
                require: 'ngModel',
                link: function(scope, elm, attrs, ctrl) {
                    ctrl.$parsers.unshift(function(viewValue) {
                        if (INTEGER_REGEXP.test(viewValue)) {
                            // it is valid
                            ctrl.$setValidity('integer', true);
                            return viewValue;
                        } else {
                            // it is invalid, return undefined (no model update)
                            ctrl.$setValidity('integer', false);
                            return undefined;
                        }
                    });
                }
            };
        };

    directive.directiveName = "integer"; //

    console.groupEnd();
    return directive;
});
