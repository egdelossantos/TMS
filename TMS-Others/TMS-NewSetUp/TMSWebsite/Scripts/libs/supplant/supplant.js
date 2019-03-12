//http://javascript.crockford.com/remedial.html

// usage
// "{0} {1}".supplant(["one", "another"])
define(['console'], function (console) {
    console.group("Loading supplant");
    
    var supplant = function (o) {
        return this.replace(
            /\{([^{}]*)\}/g,
            function (a, b) {
                var r = o[b];
                return typeof r === 'string' || typeof r === 'number' ? r : a;
            }
        );
    };

    if (!String.prototype.supplant) {
        console.debug("supplant attached");
        String.prototype.supplant = supplant;
    } else {
        console.debug("supplant NOT attached");
    }

    console.groupEnd();
    
    return supplant;
});
