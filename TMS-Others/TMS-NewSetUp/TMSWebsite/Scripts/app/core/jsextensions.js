define(['console', 'underscore'], function (console, _) {
    //Sorting
    function dynamicSort(property) {
        property = property.split('.');
        var len = property.length;

        var sortOrder = 1;

        if (property[0][0] === "-") {
            sortOrder = -1;
            property[0] = property[0].substr(1, property[0].length - 1);
        }

        return function (a, b) {
            //var result = (a[property] < b[property]) ? -1 : (a[property] > b[property]) ? 1 : 0;
            var i = 0;
            var result;
            while (i < len) {
                // check for arrays 
                if (property[i].indexOf('[') != -1) {
                    // array notation
                    var prop = property[i].substr(0, property[i].indexOf('['));
                    var i1 = property[i].indexOf(']');
                    var i2 = property[i].indexOf('[') + 1;
                    var length = i1 - i2;
                    var index = property[i].substr(property[i].indexOf('[') + 1, length);

                    a = a[prop][parseInt(index)];
                    b = b[prop][parseInt(index)];


                }
                else {
                    a = a[property[i]];
                    b = b[property[i]];
                }
                i++;
            }

            // we have to deal with empty strings separately. 
            if (_.isString(a) && a.length === 0) {
                result = -1;
            }
            else if (_.isString(b) && a.length === b) {
                result = 1;
            } else if (a < b) {
                result = -1;
            } else if (a > b) {
                result = 1;
            } else {
                result = 0;
            }
            return result * sortOrder;
        };
    }
    // add sorting to Arrays
    Array.prototype.sortBy = function (property) {
        return this.sort(dynamicSort(property));
    };

    String.prototype.lastSectionOf = function () {
        return this.substr(this.indexOf('.') + 1);
    };


    if (!Array.prototype.indexOf) {
        Array.prototype.indexOf = function (obj, start) {
            for (var i = (start || 0), j = this.length; i < j; i++) {
                if (this[i] === obj) {
                    return i;
                }
            }
            return -1;
        };
    }

});