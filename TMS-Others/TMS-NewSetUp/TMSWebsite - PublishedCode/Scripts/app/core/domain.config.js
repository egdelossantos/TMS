// all arv constants live here. 
define([], function () {
    // setup empty js obj structure
    var config = {
        messages: {
            errors: {},
            confirmations: {},
            validation: {}
        }
    };


    config.messages.validation = {
        generalRequired: "{0} is required",
        generalShortRequired: "Required",
        generalShortInteger: "Must be an integer",
        noFutureDate: "Date cannot be in future",
        commonSenseCharactersOnly: "Only the following alpha-numeric and the following special characters @,.()[]!#+' are allowed",

    };

    return config;
});