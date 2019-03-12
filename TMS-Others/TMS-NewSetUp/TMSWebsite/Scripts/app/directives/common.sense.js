define(['console'], function (console) {
    "use strict";
    console.group("Entering Common Sense directive.");
    var REGEXP = /^[a-zA-Z0-9-()@.,' \n\r!\[\]\+#]*$/;

    var directive =
        function () {
            return {
                require: 'ngModel',
                link: function (scope, elm, attrs, ctrl) {
                    ctrl.$parsers.unshift(function (viewValue) {
                        if (REGEXP.test(viewValue)) {
                            // it is valid
                            ctrl.$setValidity('commonsense', true);
                            return viewValue;
                        } else {
                            // it is invalid, return undefined (no model update)
                            ctrl.$setValidity('commonsense', false);
                            return undefined;
                        }
                    });
                }
            };
        };

    directive.directiveName = "commonSense"; //

    console.groupEnd();
    return directive;
});
