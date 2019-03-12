define(['console'], function (console) {
    "use strict";
    console.group("Entering Compare Validator directive.");

    var directive =
        function () {
            return {
                require: 'ngModel',
                link: function (scope, elm, attr, ctrl) {
                    if (!ctrl) return;

                    var validator = function (viewValue) {

                        //compare: {to:'formName.fieldName', operation:'lessThan|greaterThan|equals'}
                        var compare = $.parseJSON(attr.compare);

                        //compare.to should be in this format "formName.fieldName"
                        var formParts = compare.to.split(".");

                        var compareTo = scope[formParts[0]][formParts[1]];
                        var compareToValue = compareTo.$viewValue;
                        
                        ctrl.$setValidity('compare', true);
                        compareTo.$setValidity('compare', true);

                        if ((compare.operation === 'lessThan' && viewValue > compareToValue) ||
                            (compare.operation === 'greaterThan' && viewValue < compareToValue) ||
                            (compare.operation === 'equals' && viewValue !== compareToValue) ||
                            ((!_.isUndefined(viewValue) && !_.isNull(viewValue) && viewValue != "") && (_.isUndefined(compareToValue) || _.isNull(compareToValue) || compareToValue == "")) ||
                            ((_.isUndefined(viewValue) || _.isNull(viewValue) || viewValue == "") && (!_.isUndefined(compareToValue) && !_.isNull(compareToValue) && compareToValue != ""))) {
                            // it is invalid, 
                            ctrl.$setValidity('compare', false);
                            compareTo.$setValidity('compare', false);
                            //return undefined (no model update)
                            //return undefined;
                        }
                        return viewValue;
                    };

                    ctrl.$formatters.push(validator);
                    ctrl.$parsers.unshift(validator);

                    attr.$observe('compare', function () {

                        validator(ctrl.$viewValue);
                    });
                }
            };
        };

    directive.directiveName = "compare"; //

    console.groupEnd();
    return directive;
});