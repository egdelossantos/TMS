define(['console'], function (console) {
    "use strict";
    console.group("Entering date directive.");
    var DATE_REGEXP = /^(0[1-9]|[1-9]|[12][0-9]|3[01])[/.](0[1-9]|[1-9]|1[012])[/.](19|20)\d\d$/;

    var isDate = function (value, sepVal, dayIdx, monthIdx, yearIdx) {
        try {
            //Change the below values to determine which format of date you wish to check. It is set to dd/mm/yyyy by default.
            var DayIndex = dayIdx !== undefined ? dayIdx : 0;
            var MonthIndex = monthIdx !== undefined ? monthIdx : 1;
            var YearIndex = yearIdx !== undefined ? yearIdx : 2;

            value = value.replace(/-/g, "/").replace(/\./g, "/");
            var SplitValue = value.split(sepVal || "/");
            var isValidDate = true;
            if (!(SplitValue[DayIndex].length == 1 || SplitValue[DayIndex].length == 2)) {
                isValidDate = false;
            }
            if (isValidDate && !(SplitValue[MonthIndex].length == 1 || SplitValue[MonthIndex].length == 2)) {
                isValidDate = false;
            }
            if (isValidDate && SplitValue[YearIndex].length != 4) {
                isValidDate = false;
            }
            var date = undefined;
            if (isValidDate) {
                var Day = parseInt(SplitValue[DayIndex], 10);
                var Month = parseInt(SplitValue[MonthIndex], 10);
                var Year = parseInt(SplitValue[YearIndex], 10);

                if (isValidDate = Year > 1900) {
                    if (isValidDate = (Month <= 12 && Month > 0)) {

                        var LeapYear = (((Year % 4) == 0) && ((Year % 100) != 0) || ((Year % 400) == 0));

                        if (isValidDate = Day > 0) {
                            if (Month == 2) {
                                isValidDate = LeapYear ? Day <= 29 : Day <= 28;
                            } else {
                                if ((Month == 4) || (Month == 6) || (Month == 9) || (Month == 11)) {
                                    isValidDate = Day <= 30;
                                } else {
                                    isValidDate = Day <= 31;
                                }
                            }
                        }
                    }
                }

                if (isValidDate) {
                    date = new Date(Year, Month - 1, Day);
                }
            }
            return date;

        } catch (e) {

            return undefined;
        }
    };
    var directive =
        function () {
            return {
                require: 'ngModel',
                link: function (scope, elm, attr, ctrl) {
                    if (!ctrl) return;

                    attr.date = true;

                    var validator = function (viewValue) {
                        
                        var date = undefined;
                        ctrl.$setValidity('futuredate', true); //always reset futuredate to true
                        if (viewValue == undefined || (DATE_REGEXP.test(viewValue) && (date = isDate(viewValue)))) {
                            var today = new Date();
                            ctrl.$setValidity('date', true);

                            if (date > today) {
                                ctrl.$setValidity('futuredate', false);
                                return undefined;
                            }
                            // it is valid
                            return viewValue;
                        } else {
                            // it is invalid, return undefined (no model update)
                            ctrl.$setValidity('date', false);
                            return undefined;
                        }
                    };

                    ctrl.$formatters.push(validator);
                    ctrl.$parsers.unshift(validator);

                    attr.$observe('date', function () {
                        validator(ctrl.$viewValue);
                    });
                }
            };
        };

    directive.directiveName = "date"; //

    console.groupEnd();
    return directive;
});